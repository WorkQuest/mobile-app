import 'dart:async';
import 'package:app/base_store/i_store.dart';
import 'package:app/di/injector.dart';
import 'package:app/enums.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/keys.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/utils/marker_loader_for_map.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:easy_localization/easy_localization.dart';

part 'quest_map_store.g.dart';

@singleton
class QuestMapStore extends _QuestMapStore with _$QuestMapStore {
  QuestMapStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _QuestMapStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _QuestMapStore(this._apiProvider);

  @observable
  bool? isWorker;

  @observable
  bool hideInfo = true;

  @observable
  String address = "";

  @observable
  Timer? debounce;

  @observable
  MarkerLoader? markerLoader;

  @observable
  Position? locationPosition;

  @observable
  CameraPosition? initialCameraPosition;

  List<BaseQuestResponse> questsOnMap = [];

  List<ProfileMeResponse> workersOnMap = [];

  late ClusterManager clusterManager;

  @observable
  Map<String, BaseQuestResponse> bufferQuests = {};

  @observable
  ObservableSet<Marker> markers = ObservableSet();

  ObservableList<ProfileMeResponse> currentWorkerCluster = ObservableList();

  ObservableList<BaseQuestResponse> currentQuestCluster = ObservableList();

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: Keys.googleKey);

  @action
  Future<Null> getPrediction(
    BuildContext context,
    GoogleMapController controller,
  ) async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: Keys.googleKey,
      mode: Mode.overlay,
      logo: SizedBox(),
      hint: "quests.ui.search".tr(),
      startText: address.isNotEmpty ? address : "",
    );
    if (p != null) {
      address = p.description!;
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId!);
      controller.moveCamera(
        CameraUpdate.newLatLng(
          LatLng(
            detail.result.geometry!.location.lat,
            detail.result.geometry!.location.lng,
          ),
        ),
      );
      LatLngBounds bounds = await controller.getVisibleRegion();
      getQuestsOnMap(bounds);
    }
  }

  @action
  Future getQuestsOnMap(LatLngBounds bounds) async {
    try {
      this.onLoading();
      if (isWorker!) {
        questsOnMap = await _apiProvider.questMapPoints(bounds);
        clusterManager.setItems(questsOnMap);
      } else {
        workersOnMap = await _apiProvider.workerMapPoints(bounds);
        clusterManager.setItems(workersOnMap);
      }

      this.onSuccess(true);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }

  ClusterManager<ClusterItem> initClusterManager() {
    final List<double> level = const [
      1,
      4.25,
      6.75,
      8.25,
      11.5,
      14.5,
      16.0,
      16.5,
      20.0
    ];

    if (isWorker!)
      return ClusterManager<BaseQuestResponse>(questsOnMap, _updateMarkers,
          markerBuilder: questMarkerBuilder,
          levels: level,
          extraPercent: 0.5,
          stopClusteringZoom: 25.0);
    return ClusterManager<ProfileMeResponse>(workersOnMap, _updateMarkers,
        markerBuilder: workersMarkerBuilder,
        levels: level,
        extraPercent: 0.5,
        stopClusteringZoom: 25.0);
  }

  void _updateMarkers(Set<Marker> markers) {
    this.markers = ObservableSet.of(markers);
  }

  void closeInfo() => this.hideInfo = true;

  @action
  createMarkerLoader(BuildContext context) {
    this.markerLoader = new MarkerLoader(context);
    // assign value here, null if assigned in constructor
    isWorker = getIt.get<ProfileMeStore>().userData?.role == UserRole.Worker;
    clusterManager = initClusterManager();
  }

  Future<Marker> Function(Cluster<BaseQuestResponse>) get questMarkerBuilder =>
      (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () {
            hideInfo = false;
            currentQuestCluster = ObservableList.of(cluster.items.toList());
          },
          icon: cluster.isMultiple
              ? await MarkerLoader.getClusterMarkerBitmap(
                  cluster.count.toString())
              : markerLoader!.icons[cluster.items.toList()[0].priority],
        );
      };

  Future<Marker> Function(Cluster<ProfileMeResponse>)
      get workersMarkerBuilder => (cluster) async {
            return Marker(
                markerId: MarkerId(cluster.getId()),
                position: cluster.location,
                onTap: () {
                  hideInfo = false;
                  currentWorkerCluster =
                      ObservableList.of(cluster.items.toList());
                },
                icon: cluster.isMultiple
                    ? await MarkerLoader.getClusterMarkerBitmap(
                        cluster.count.toString())
                    : await MarkerLoader.getMarkerImageFromUrl(
                        cluster.items.toList()[0].avatar!.url,
                        targetWidth: 10));
          };
}
