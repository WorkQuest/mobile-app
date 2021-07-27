import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../../../../utils/marker_louder_for_map.dart';

part 'quests_store.g.dart';

@injectable
@singleton
class QuestsStore extends _QuestsStore with _$QuestsStore {
  QuestsStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _QuestsStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _QuestsStore(this._apiProvider);

  @observable
  String? searchWord = "";

  @observable
  String? sort = "";

  @observable
  int priority = -1;

  @observable
  int offset = 0;

  @observable
  int limit = 10;

  @observable
  int status = -1;

  @observable
  List<BaseQuestResponse>? questsList;

  @observable
  List<BaseQuestResponse>? starredQuestsList;

  @observable
  List<BaseQuestResponse>? performedQuestsList;

  @observable
  List<BaseQuestResponse>? invitedQuestsList;

  @observable
  _MapList mapListChecker = _MapList.Map;

  @observable
  List<BitmapDescriptor> iconsMarker = [];

  @observable
  BaseQuestResponse? selectQuestInfo;

  @action
  changeValue() {
    if (mapListChecker == _MapList.Map) {
      mapListChecker = _MapList.List;
    } else {
      mapListChecker = _MapList.Map;
    }
  }

  @action
  isMapOpened() {
    return mapListChecker == _MapList.Map;
  }

  @action
  Future getQuests(
      /*{
    required bool invited,
    required performing,
    required bool starred,
  }*/
      ) async {
    try {
      this.onLoading();
      questsList = await _apiProvider.getQuests(
        offset: this.offset,
        limit: this.limit,
        status: this.status,
        invited: false,
        performing: false,
        priority: this.priority,
        searchWord: this.searchWord,
        sort: this.sort,
        starred: false,
      );

      starredQuestsList = await _apiProvider.getQuests(
        offset: this.offset,
        limit: this.limit,
        status: this.status,
        invited: false,
        performing: false,
        priority: this.priority,
        searchWord: this.searchWord,
        sort: this.sort,
        starred: true,
      );

      invitedQuestsList = await _apiProvider.getQuests(
        offset: this.offset,
        limit: this.limit,
        status: this.status,
        invited: true,
        performing: false,
        priority: this.priority,
        searchWord: this.searchWord,
        sort: this.sort,
        starred: false,
      );

      performedQuestsList = await _apiProvider.getQuests(
        offset: this.offset,
        limit: this.limit,
        status: this.status,
        invited: false,
        performing: true,
        priority: this.priority,
        searchWord: this.searchWord,
        sort: this.sort,
        starred: false,
      );
      print(questsList);
      print(starredQuestsList);
      print(performedQuestsList);
      print(invitedQuestsList);
      this.onSuccess(true);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }

  @action
  loadIcons() async {
    iconsMarker.add( await getMarkerIcon("assets/LowMarker.png", Size(110.0, 145.0)));
    iconsMarker.add(iconsMarker[0]);
    iconsMarker.add( await getMarkerIcon("assets/NormalMarker.png", Size(110.0, 145.0)));
    iconsMarker.add( await getMarkerIcon("assets/UrgentMarker.png", Size(110.0, 145.0)));
  }

   Set<Marker> getMapMakers() {
    return {
      for (BaseQuestResponse quest in questsList ?? [])
        Marker(
          onTap: () => selectQuestInfo = quest,
          icon: iconsMarker[quest.priority],
          markerId: MarkerId(quest.id),
          position: LatLng(
            quest.location.latitude,
            quest.location.longitude,
          ),
        )
    };
  }
}

enum _MapList {
  Map,
  List,
}
