import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:easy_localization/easy_localization.dart';

part 'choose_quest_store.g.dart';

@injectable
class ChooseQuestStore extends _ChooseQuestStore with _$ChooseQuestStore {
  ChooseQuestStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _ChooseQuestStore extends IStore<ChooseQuestState> with Store {
  final ApiProvider _apiProvider;

  _ChooseQuestStore(this._apiProvider);

  @observable
  ObservableList<BaseQuestResponse> quests = ObservableList.of([]);

  @observable
  String questId = "";

  @observable
  bool showMore = false;

  @action
  void setQuest(String id) => questId = id;

  String chatId = "";

  @action
  getQuests({
    required String userId,
    bool isForce = true,
  }) async {
    try {
      if (isForce) {
        this.onLoading();
        quests.clear();
      } else {
        showMore = true;
      }
      final result = await _apiProvider.getAvailableQuests(userId: userId, offset: quests.length);
      quests.addAll(result);
      quests.toList().sort(
          (key1, key2) => key1.createdAt!.millisecondsSinceEpoch < key2.createdAt!.millisecondsSinceEpoch ? 1 : 0);
      this.onSuccess(ChooseQuestState.getQuests);
    } catch (e) {
      this.onError(e.toString());
    }
    showMore = false;
  }

  @action
  startQuest({
    required String userId,
  }) async {
    try {
      this.onLoading();
      chatId = await _apiProvider.inviteOnQuest(
        questId: questId,
        userId: userId,
        message: "quests.inviteToQuest".tr(),
      );
      this.onSuccess(ChooseQuestState.startQuest);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}

enum ChooseQuestState { getQuests, startQuest }
