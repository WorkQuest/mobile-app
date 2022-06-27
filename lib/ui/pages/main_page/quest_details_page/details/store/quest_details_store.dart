import 'package:app/base_store/i_store.dart';
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
  String? questId;

  @action
  initQuest(BaseQuestResponse quest) => questInfo = quest;

  @action
  initQuestId(String value) => questId = value;

  @action
  updateQuest() async {
    try {
      onLoading();
      final result = await _apiProvider.getQuest(id: questInfo?.id ?? questId!);
      questInfo = result;
      onSuccess(true);
    } catch (e) {
      onError(e.toString());
    }
  }
}
