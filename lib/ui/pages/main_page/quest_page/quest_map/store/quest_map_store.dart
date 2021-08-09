import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
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

  BaseQuestResponse? selectQuestInfo;

  @observable
  List<BitmapDescriptor> iconsMarker = [];

  @action
  Future getQuests(String userId) async {
    try {
      this.onLoading();

      var response = await _apiProvider.mapPoints();

      print(response);

      this.onSuccess(true);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }

  //  @action
  // loadIcons(BuildContext context) async {
  //   const size = Size(22, 29);
  //   iconsMarker.add(await svgToBitMap(
  //       context, "assets/marker.svg", size, Color(0xFF22CC14)));
  //   iconsMarker.add(await svgToBitMap(
  //       context, "assets/marker.svg", size, Color(0xFF22CC14)));
  //   iconsMarker.add(await svgToBitMap(
  //       context, "assets/marker.svg", size, Color(0xFFE8D20D)));
  //   iconsMarker.add(await svgToBitMap(
  //       context, "assets/marker.svg", size, Color(0xFFDF3333)));
  // }

  // Set<Marker> getMapMakers() {
  //   return {
  //     for (BaseQuestResponse quest in questsList ?? [])
  //       Marker(
  //         onTap: () => selectQuestInfo = quest,
  //         icon: iconsMarker[quest.priority],
  //         markerId: MarkerId(quest.id),
  //         position: LatLng(quest.location.latitude, quest.location.longitude),
  //       )
  //   };
  // }
}
