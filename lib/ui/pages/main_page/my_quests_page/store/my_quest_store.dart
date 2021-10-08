import 'package:app/base_store/i_store.dart';
import 'package:app/enums.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'my_quest_store.g.dart';

@singleton
class MyQuestStore extends _MyQuestStore with _$MyQuestStore {
  MyQuestStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _MyQuestStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _MyQuestStore(this._apiProvider);

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
  List<BaseQuestResponse>? active;

  @observable
  List<BaseQuestResponse>? starred;

  @observable
  List<BaseQuestResponse>? performed;

  @observable
  List<BaseQuestResponse>? requested;

  @observable
  List<BaseQuestResponse>? invited;

  @observable
  List<BitmapDescriptor> iconsMarker = [];

  @observable
  BaseQuestResponse? selectQuestInfo;

  @action
  Future getQuests(String userId, UserRole role) async {
    try {
      this.onLoading();
      if (role == UserRole.Employer) {
        active = await _apiProvider.getEmployerQuests(userId: userId);

        invited = await _apiProvider.getEmployerQuests(
          userId: userId,
          status: 4,
        );

        performed = await _apiProvider.getEmployerQuests(
          userId: userId,
          status: 6,
        );
      } else {
        active = await _apiProvider.getQuests(
          offset: this.offset,
          limit: this.limit,
          performing: true,
          status: 1,
        );

        starred = await _apiProvider.getQuests(
          offset: this.offset,
          limit: this.limit,
          starred: true,
        );

        requested = []; //= await _apiProvider.responsesQuests();

        invited = await _apiProvider.getQuests(
          offset: this.offset,
          limit: this.limit,
          performing: true,
          status: 4,
        );

        performed = await _apiProvider.getQuests(
          offset: this.offset,
          limit: this.limit,
          performing: true,
          status: 6,
        );
      }
      this.onSuccess(true);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }
}
