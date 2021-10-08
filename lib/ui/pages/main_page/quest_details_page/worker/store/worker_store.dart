import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'worker_store.g.dart';

@injectable
class WorkerStore extends _WorkerStore with _$WorkerStore {
  WorkerStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _WorkerStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _WorkerStore(this._apiProvider);

  Observable<BaseQuestResponse?> quest = Observable(null);

  _getQuest() async {
    final newQuest = await _apiProvider.getQuest(id: quest.value!.id);
    quest.value!.update(newQuest);
    quest.reportChanged();
  }

  onStar() async {
    if (quest.value!.star) {
      await _apiProvider.removeStar(id: quest.value!.id);
    } else
      await _apiProvider.setStar(id: quest.value!.id);
    await _getQuest();
  }

  sendAcceptOnQuest() async {
    try {
      this.onLoading();
      await _apiProvider.acceptOnQuest(questId: quest.value!.id);
      this.onSuccess(true);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }

  sendRejectOnQuest() async {
    try {
      this.onLoading();
      await _apiProvider.rejectOnQuest(questId: quest.value!.id);
      this.onSuccess(true);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }

  sendCompleteWork() async {
    try {
      this.onLoading();
      await _apiProvider.completeWork(questId: quest.value!.id);
      this.onSuccess(true);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }

  sendRespondOnQuest(String message) async {
    try {
      this.onLoading();
      await _apiProvider.respondOnQuest(id: quest.value!.id, message: message);
      this.onSuccess(true);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }
}
