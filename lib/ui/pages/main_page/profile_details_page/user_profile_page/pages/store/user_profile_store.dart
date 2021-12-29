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
  ObservableList<BaseQuestResponse> userQuest = ObservableList.of([]);

  @observable
  ObservableList<BaseQuestResponse> questForWorker = ObservableList.of([]);

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
        final quests = await _apiProvider.getEmployerQuests(
          userId: userId,
          offset: 10,
          statuses: [6],
        );
        userQuest.addAll(ObservableList.of(List<BaseQuestResponse>.from(
            quests["quests"].map((x) => BaseQuestResponse.fromJson(x)))));
      }
      if (role == UserRole.Worker) {
        final quests = await _apiProvider.getEmployerQuests(
          userId: userId,
          offset: offset,
          statuses: [0, 4],
        );
        questForWorker.addAll(ObservableList.of(List<BaseQuestResponse>.from(
            quests["quests"].map((x) => BaseQuestResponse.fromJson(x)))));
        removeOddQuests();
        offset += 10;
      }
      this.onSuccess(true);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }
}
