import 'dart:async';
import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/keys.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
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

  _QuestMapStore(this._apiProvider) {
    clusterManager = initClusterManager();
  }

  @observable
  InfoPanel infoPanel = InfoPanel.Nope;

  @observable
  BaseQuestResponse? selectQuestInfo;

  @observable
  Map<String, BaseQuestResponse> bufferQuests = {};

  List<BaseQuestResponse> questsOnMap = [];

  @observable
  ObservableSet<Marker> markers = ObservableSet();

  @observable
  CameraPosition? initialCameraPosition;

  @observable
  Position? locationPosition;

  @observable
  Timer? debounce;

  @observable
  MarkerLoader? markerLoader;

  late final ClusterManager clusterManager;

  @observable
  String address = "";

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
      questsOnMap = await _apiProvider.mapPoints(bounds);
      clusterManager.setItems(questsOnMap);
      this.onSuccess(true);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }

  ClusterManager initClusterManager() {
    return ClusterManager(questsOnMap,
        _updateMarkers, // Method to be called when markers are updated
        markerBuilder: MarkerLoader.markerBuilder,
        // Optional : Method to implement if you want to customize markers
        levels: const [1, 4.25, 6.75, 8.25, 11.5, 14.5, 16.0, 16.5, 20.0],
        // Optional : Configure this if you want to change zoom levels at which the clustering precision change
        extraPercent: 0.2,
        // Optional : This number represents the percentage (0.2 for 20%) of latitude and longitude (in each direction) to be considered on top of the visible map bounds to render clusters. This way, clusters don't "pop out" when you cross the map.
        stopClusteringZoom:
            17.0 // Optional : The zoom level to stop clustering, so it's only rendering single item "clusters"
        );
  }

  void _updateMarkers(Set<Marker> markers) {
    print('Updated ${markers.length} markers');
    print('Updated add ${this.markers.length} ');
    this.markers = ObservableSet.of(markers);
  }

  // Set<Marker> getMarkerSet() {
  //   Set<Marker> markers = Set();
  //
  //   //return markers;
  //   return c
  //       .items
  //       .map((e) => Marker(markerId: MarkerId(e.geohash), position: e.location))
  //       .toSet();
  // }

  @action
  onTabQuest(String id) async {
    this.infoPanel = InfoPanel.Point;
    this.selectQuestInfo = null;
    if (bufferQuests.containsKey(id)) {
      this.selectQuestInfo = bufferQuests[id];
    } else {
      this.selectQuestInfo = await _apiProvider.getQuest(id: id);
      bufferQuests[id] = this.selectQuestInfo!;
    }
  }

  @action
  onCloseQuest() {
    this.infoPanel = InfoPanel.Nope;
    this.selectQuestInfo = null;
  }

  @action
  createMarkerLoader(BuildContext context) =>
      this.markerLoader = new MarkerLoader(context);
}

enum InfoPanel { Nope, Point, Cluster }
