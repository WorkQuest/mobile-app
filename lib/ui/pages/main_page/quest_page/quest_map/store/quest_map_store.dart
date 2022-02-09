import 'dart:async';
import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/keys.dart';
import 'package:app/model/quests_models/assigned_worker.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/model/quests_models/quest_map_point.dart';
import 'package:app/utils/marker_louder_for_map.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:easy_localization/easy_localization.dart';

part 'quest_map_store.g.dart';

@injectable
@singleton
class QuestMapStore extends _QuestMapStore with _$QuestMapStore {
  QuestMapStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _QuestMapStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _QuestMapStore(this._apiProvider);

  @observable
  InfoPanel infoPanel = InfoPanel.Nope;

  @observable
  BaseQuestResponse? selectQuestInfo;

  @observable
  Map<String, BaseQuestResponse> bufferQuests = {};

  @observable
  List<QuestMapPoint> points = [];

  @observable
  ObservableList<BaseQuestResponse> questsOnMap = ObservableList();

  @observable
  ObservableList<AssignedWorker> workersOnMap = ObservableList();

  @observable
  CameraPosition? initialCameraPosition;

  @observable
  Position? locationPosition;

  @observable
  List<MapMarker> markers = [];

  @observable
  Timer? debounce;

  @observable
  MarkerLoader? markerLoader;

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
      questsOnMap.addAll( await _apiProvider.mapPoints(bounds));
      markers = await getMarkerList();
      this.onSuccess(true);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }

  Future<List<MapMarker>> getMarkerList() async {
    if (this.markerLoader == null) return [];
    List<MapMarker> newMarkersList = [];
    for (var item in questsOnMap) {
      newMarkersList.add(
        MapMarker(
          //onTap:(){},
          //infoWindow:InfoWindow.noText,
          // item.type == TypeMarker.Cluster
          //     ? () => this.infoPanel = InfoPanel.Cluster
          //     : () =>
             // onTabQuest(item.title),
          icon:BitmapDescriptor.defaultMarker,
          //item.type == TypeMarker.Cluster
          //     ? await markerLoader!.getCluster(item.pointsCount)
          //     :
          //markerLoader!.icons[1],
          id: item.id,
          // MarkerId(
          //   item.id
          //       // == null
          //       // ? item.location[0].toString() + item.location[1].toString()
          //       // : item.questId!
          //   ,
          // ),
          position: LatLng(item.locationCode.latitude, item.locationCode.longitude),
        ),
      );
    }
    return newMarkersList;
  }

  Fluster<MapMarker> getPoints(){
    Fluster<MapMarker> fluster = Fluster<MapMarker>(
      minZoom: 0, // The min zoom at clusters will show
      maxZoom: 20, // The max zoom at clusters will show
      radius: 150, // Cluster radius in pixels
      extent: 2048, // Tile extent. Radius is calculated with it.
      nodeSize: 64, // Size of the KD-tree leaf node.
      points: markers, // The list of markers created before
      createCluster: ( // Create cluster marker
          BaseCluster? cluster,
          double? lng,
          double? lat,
          ) => MapMarker(
        id: cluster?.id.toString(),
        position: LatLng(lat!, lng!),
        icon: BitmapDescriptor.defaultMarker,
        isCluster: cluster?.isCluster,
        clusterId: cluster?.id,
        pointsSize: cluster?.pointsSize,
        childMarkerId: cluster?.childMarkerId,
      ),
    );
    return fluster;
  }


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
