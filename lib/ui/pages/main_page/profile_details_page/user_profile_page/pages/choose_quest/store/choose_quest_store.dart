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

abstract class _ChooseQuestStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _ChooseQuestStore(this._apiProvider);

  int offset = 0;

  @observable
  ObservableList<BaseQuestResponse> quests = ObservableList.of([]);

  @observable
  String questId = "";

  @action
  void setQuest(String id) => questId = id;

  String chatId = "";

  @action
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
        quests.addAll(await _apiProvider.getAvailableQuests(
          userId: userId,
          offset: offset,
        ));

        quests.toList().sort((key1, key2) =>
            key1.createdAt!.millisecondsSinceEpoch <
                    key2.createdAt!.millisecondsSinceEpoch
                ? 1
                : 0);
        offset += 10;
        this.onSuccess(true);
      }
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future<void> startQuest({
    required String userId,
  }) async {
    try {
      this.onLoading();
      chatId = await _apiProvider.inviteOnQuest(
        questId: questId,
        userId: userId,
        message: "quests.inviteToQuest".tr(),
      );
      this.onSuccess(true);
    } catch (e) {
      print("getQuests error: $e");
      this.onError(e.toString());
    }
  }
}
