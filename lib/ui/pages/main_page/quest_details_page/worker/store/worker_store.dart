import 'dart:io';

import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/model/quests_models/media_model.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/utils/web_socket.dart';

part 'worker_store.g.dart';

@injectable
class WorkerStore extends _WorkerStore with _$WorkerStore {
  WorkerStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _WorkerStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  @observable
  String opinion = "";

  @observable
  bool response = false;

  @observable
  ObservableList<File> mediaFile = ObservableList();

  @observable
  ObservableList<Media> mediaIds = ObservableList();

  @action
  void setOpinion(String value) => opinion = value;

  _WorkerStore(this._apiProvider) {
    WebSocket().handlerQuests = this.changeQuest;
  }

  Observable<BaseQuestResponse?> quest = Observable(null);

  @action
  void changeQuest(dynamic json) {
    var changedQuest =
    BaseQuestResponse.fromJson(json["data"]["quest"] ?? json["data"]);
    if (changedQuest.id == quest.value?.id) {
      quest.value = changedQuest;
      _getQuest();
    }
  }

  @action
  setQuestStatus(int value) => quest.value!.status = value;

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
      // ClientService().handleEvent(WQContractFunctions.acceptJob);
      await _getQuest();
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
      // ClientService().handleEvent(WQContractFunctions.declineJob);
      await _getQuest();
      this.onSuccess(true);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }

  acceptInvite(String responseId) async {
    try {
      this.onLoading();
      await _apiProvider.acceptInvite(responseId: responseId);
      // ClientService().handleEvent(WQContractFunctions.acceptJob);
      await _getQuest();
      this.onSuccess(true);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }

  rejectInvite(String responseId) async {
    try {
      this.onLoading();
      await _apiProvider.rejectInvite(responseId: responseId);
      // ClientService().handleEvent(WQContractFunctions.declineJob);
      await _getQuest();
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
      // ClientService().handleEvent(WQContractFunctions.verificationJob);
      await _getQuest();
      this.onSuccess(true);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }

  sendRespondOnQuest(String message) async {
    try {
      this.onLoading();
      await _apiProvider.respondOnQuest(
        id: quest.value!.id,
        message: message,
        media: mediaIds.map((e) => e.id).toList() +
            await _apiProvider.uploadMedia(
              medias: mediaFile,
            ),
      );
      await _getQuest();
      this.onSuccess(true);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }
}
