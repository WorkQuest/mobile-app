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

  @observable
  BaseQuestResponse? quest;

  _getQuest() async {
    quest = await _apiProvider.getQuest(id: quest!.id);
  }

  onStar() async {
    if (quest!.star)
      await _apiProvider.removeStar(id: quest!.id);
    else
      await _apiProvider.setStar(id: quest!.id);
    await _getQuest();
  }

  sendRespondOnQuest(String message) async {
    try {
      this.onLoading();
      await _apiProvider.respondOnQuest(id: quest!.id, message: message);
      this.onSuccess(true);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }
}
