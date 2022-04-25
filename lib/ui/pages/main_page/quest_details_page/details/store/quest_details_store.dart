import 'package:app/base_store/i_store.dart';
import 'package:app/enums.dart';
import 'package:app/http/api_provider.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../../../../../model/quests_models/base_quest_response.dart';

part 'quest_details_store.g.dart';

@injectable
class QuestDetailsStore extends _QuestDetailsStore with _$QuestDetailsStore {
  QuestDetailsStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _QuestDetailsStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _QuestDetailsStore(this._apiProvider);

  @observable
  BaseQuestResponse? questInfo;

  @observable
  QuestItemPriorityType questType = QuestItemPriorityType.Active;

  @action
  initQuest(BaseQuestResponse quest) => questInfo = quest;

  @action
  QuestItemPriorityType getQuestType(BaseQuestResponse quest, UserRole role) {
    switch (quest.status) {
      case 0:
        return questType = QuestItemPriorityType.Active;
      case 1:
        return questType = QuestItemPriorityType.Active;
      case 2:
        if (role == UserRole.Worker)
          return questType = QuestItemPriorityType.Invited;
        else
          return questType = QuestItemPriorityType.Requested;
      case 5:
        return questType = QuestItemPriorityType.Performed;
      case -3:
        return questType = QuestItemPriorityType.Performed;
    }
    return questType = QuestItemPriorityType.Active;
  }

  @action
  updateQuest() async {
    try {
      onLoading();
      final result = await _apiProvider.getQuest(id: questInfo!.id);
      questInfo = result;
      onSuccess(true);
    } catch (e) {
      onError(e.toString());
    }
  }
}
