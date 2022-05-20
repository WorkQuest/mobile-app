import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';

part 'user_profile_store.g.dart';

@singleton
class UserProfileStore extends _UserProfileStore with _$UserProfileStore {
  UserProfileStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _UserProfileStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  @observable
  ProfileMeResponse? userData;

  @observable
  ObservableList<BaseQuestResponse> quests = ObservableList.of([]);

  _UserProfileStore(
    this._apiProvider,
  );

  int offset = 0;

  String workerId = "";

  @observable
  String questId = "";

  @observable
  String contractAddress = "";

  @action
  void setQuest(String id, String contractAddress) {
    questId = id;
    this.contractAddress = contractAddress;
  }

  @action
  Future<void> getProfile({
    required String userId,
  }) async {
    try {
      this.onLoading();
      userData = await _apiProvider.getProfileUser(userId: userId);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  Future<void> getQuests({
    required String userId,
    required bool newList,
    required bool isProfileYours,
  }) async {
    try {
      this.onLoading();
      if (newList) {
        quests.clear();
        offset = 0;
      }
      if (offset == quests.length) {
          quests.addAll(await _apiProvider.getEmployerQuests(
            userId:userId,
            offset: offset,
            invited: false,
            sort: "sort[createdAt]=desc",
            me: isProfileYours ? true : false,
          ));

        quests.toList().sort((key1, key2) =>
            key1.createdAt!.millisecondsSinceEpoch <
                    key2.createdAt!.millisecondsSinceEpoch
                ? 1
                : 0);
        offset += 10;
        this.onSuccess(true);
      }
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }
}
