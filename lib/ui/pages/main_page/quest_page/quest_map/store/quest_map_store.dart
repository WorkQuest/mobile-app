import 'dart:async';

import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/model/quests_models/quest_map_point.dart';
import 'package:app/utils/marker_louder_for_map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

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
  List<Marker> markers = [];

  @observable
  Timer? debounce;

  @observable
  List<BitmapDescriptor> iconsMarker = [];

  @action
  Future getQuests(LatLngBounds bounds) async {
    try {
      this.onLoading();
      points = await _apiProvider.mapPoints(bounds);
      markers = await getMarkerList();
      this.onSuccess(true);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }

  Future<List<Marker>> getMarkerList() async {
    final elipse = await getImageFromPath("assets/Ellipse.png");
    List<Marker> newMarkersList = [];
    for (var item in points) {
      newMarkersList.add(
        Marker(
          onTap: item.type == TypeMarker.Cluster
              ? () => this.infoPanel = InfoPanel.Cluster
              : () => onTabQuest(item.questId!),
          icon: item.type == TypeMarker.Cluster
              ? await getClusterMarker(item.pointsCount, elipse)
              : iconsMarker[1],
          markerId: MarkerId(item.questId == null
              ? item.location.latitude.toString() +
                  item.location.longitude.toString()
              : item.questId!),
          position: LatLng(item.location.longitude, item.location.latitude),
        ),
      );
    }
    return newMarkersList;
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
  loadIcons(BuildContext context) async {
    const size = Size(26, 34.27);
    iconsMarker.add(await svgToBitMap(
        context, "assets/marker.svg", size, Color(0xFF22CC14)));
    iconsMarker.add(await svgToBitMap(
        context, "assets/marker.svg", size, Color(0xFF22CC14)));
    iconsMarker.add(await svgToBitMap(
        context, "assets/marker.svg", size, Color(0xFFE8D20D)));
    iconsMarker.add(await svgToBitMap(
        context, "assets/marker.svg", size, Color(0xFFDF3333)));
  }
}

enum InfoPanel { Nope, Point, Cluster }
