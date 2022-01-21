import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../enums.dart';

part 'user_profile_store.g.dart';

@singleton
class UserProfileStore extends _UserProfileStore with _$UserProfileStore {
  UserProfileStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _UserProfileStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;
  ProfileMeResponse? userData;
  ProfileMeResponse? questHolder;

  @observable
  ObservableList<BaseQuestResponse> quests = ObservableList.of([]);

  _UserProfileStore(
    this._apiProvider,
  );

  int offset = 0;

  String workerId = "";

  @observable
  String questName = "";

  String questId = "";

  @action
  void setQuest(String? index, String id) {
    questName = index ?? "";
    questId = id;
  }

  Future<void> startQuest(String userId) async {
    try {
      await _apiProvider.inviteOnQuest(
          questId: questId,
          userId: userId,
          message: "quests.inviteToQuest".tr());
    } catch (e) {
      print("getQuests error: $e");
      this.onError(e.toString());
    }
  }

  void removeOddQuests() {
    // for (int i = 0; i < questForWorker.length; i++) {
    //   if (questForWorker[i].responded?.workerId == workerId ||
    //       questForWorker[i].invited?.workerId == workerId) {
    //     questForWorker.removeAt(i);
    //     i--;
    //   }
    // }
    // questForWorker.removeWhere((element) => element.title == questName);
  }

  Future<void> getQuests(
    String userId,
    UserRole role,
  ) async {
    try {
      this.onLoading();
      //TODO:offset scroll
      if (role == UserRole.Employer) {
        quests.addAll(await _apiProvider.getEmployerQuests(
          userId: userId,
          offset: offset,
          statuses: [6],
        ));
      }
      if (role == UserRole.Worker) {
        quests.addAll (await _apiProvider.getEmployerQuests(
          userId: userId,
          offset: offset,
          statuses: [0, 4],
        ));
        removeOddQuests();
      }

      quests.toList().sort((key1, key2) =>
      key1.createdAt.millisecondsSinceEpoch <
          key2.createdAt.millisecondsSinceEpoch
          ? 1
          : 0);
      offset += 10;
      this.onSuccess(true);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }
}
