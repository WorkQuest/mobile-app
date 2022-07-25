import 'package:app/enums.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/utils/quest_util.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';

part 'profile_quests_store.g.dart';

@injectable
class ProfileQuestsStore extends _ProfileQuestsStore with _$ProfileQuestsStore {
  ProfileQuestsStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _ProfileQuestsStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _ProfileQuestsStore(this._apiProvider);

  @observable
  ObservableList<BaseQuestResponse> quests = ObservableList.of([]);

  @action
  getCompletedQuests({
    required UserRole userRole,
    required String userId,
    required bool isProfileYours,
    bool isForce = false,
  }) async {
    try {
      this.onLoading();
      if (isForce) {
        quests.clear();
      }
      quests.addAll(
        userRole == UserRole.Employer
            ? await _apiProvider.getEmployerQuests(
                userId: userId,
                offset: quests.length,
                statuses: [QuestConstants.questDone],
                me: isProfileYours,
              )
            : await _apiProvider.getWorkerQuests(
                userId: userId,
                offset: quests.length,
                statuses: [QuestConstants.questDone],
                me: isProfileYours,
              ),
      );
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  getActiveQuests({
    required UserRole userRole,
    required String userId,
    required bool isProfileYours,
    bool isForce = false,
  }) async {
    try {
      this.onLoading();
      if (isForce) {
        quests.clear();
      }
      quests.addAll(
        userRole == UserRole.Employer
            ? await _apiProvider.getEmployerQuests(
                offset: quests.length,
                userId: userId,
                statuses: [
                  QuestConstants.questDispute,
                  QuestConstants.questWaitWorker,
                  QuestConstants.questWaitEmployerConfirm
                ],
                me: isProfileYours,
              )
            : await _apiProvider.getWorkerQuests(
                offset: quests.length,
                userId: userId,
                statuses: [
                  QuestConstants.questDispute,
                  QuestConstants.questWaitWorker,
                  QuestConstants.questWaitEmployerConfirm
                ],
                me: isProfileYours,
              ),
      );
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
