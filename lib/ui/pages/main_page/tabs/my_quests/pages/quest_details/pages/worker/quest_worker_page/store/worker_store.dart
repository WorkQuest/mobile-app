import 'dart:io';

import 'package:app/http/api_provider.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/model/media_model.dart';
import 'package:app/model/quests_models/responded.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/utils/quest_util.dart';
import 'package:app/web3/contractEnums.dart';
import 'package:app/web3/repository/wallet_repository.dart';
import 'package:app/web3/service/client_service.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/http/web_socket.dart';
import 'package:app/ui/widgets/media_upload/store/i_media_store.dart';

part 'worker_store.g.dart';

@injectable
class WorkerStore extends _WorkerStore with _$WorkerStore {
  WorkerStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _WorkerStore extends IMediaStore<WorkerStoreState> with Store {
  final ApiProvider _apiProvider;

  _WorkerStore(this._apiProvider) {
    WebSocket().handlerQuests = this.changeQuest;
  }

  @observable
  String opinion = "";

  String fee = "";

  @observable
  ObservableList<File> mediaFile = ObservableList();

  @observable
  ObservableList<Media> mediaIds = ObservableList();

  @observable
  Observable<BaseQuestResponse?> quest = Observable(null);

  @action
  setOpinion(String value) => opinion = value;

  getFee(String functionName) async {
    try {
      final _client = WalletRepository().getClientWorkNet();
      final _contract = await _client.getDeployedContract(
          "WorkQuest", quest.value!.contractAddress!);
      final _function = _contract.function(functionName);
      final _gas = await _client.getEstimateGasCallContract(
          contract: _contract, function: _function, params: []);
      fee = _gas.toStringAsFixed(17);
    } on SocketException catch (_) {
      onError("Lost connection to server");
    }
  }

  @action
  getQuest(String questId) async {
    quest.value = await _apiProvider.getQuest(id: questId);
    quest.reportChanged();
  }

  @action
  changeQuest(dynamic json) {
    var changedQuest =
        BaseQuestResponse.fromJson(json["data"]["quest"] ?? json["data"]);
    if (changedQuest.id == quest.value?.id) {
      getQuest(quest.value!.id);
    }
  }

  @action
  setQuestStatus(int value) => quest.value!.status = value;

  @action
  onStar() async {
    quest.reportChanged();
  }

  @action
  sendAcceptOnQuest() async {
    print('sendAcceptOnQuest');
    try {
      this.onLoading();
      await WalletRepository().getClientWorkNet().handleEvent(
            function: WQContractFunctions.acceptJob,
            contractAddress: quest.value!.contractAddress!,
          );
      quest.value!.status = QuestConstants.questWaitWorker;
      quest.reportChanged();
      this.onSuccess(WorkerStoreState.sendAcceptOnQuest);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }

  // @action
  // sendRejectOnQuest() async {
  //   try {
  //     this.onLoading();
  //     WalletRepository().getClientWorkNet().handleEvent(
  //           function: WQContractFunctions.declineJob,
  //           contractAddress: quest.value!.contractAddress!,
  //           value: null,
  //         );
  //     await _getQuest();
  //     this.onSuccess(WorkerStoreState.sendRejectOnQuest);
  //   } catch (e, trace) {
  //     print("getQuests error: $e\n$trace");
  //     this.onError(e.toString());
  //   }
  // }

  @action
  acceptInvite(String responseId) async {
    try {
      this.onLoading();
      await _apiProvider.acceptInvite(responseId: responseId);
      quest.value!.status = QuestConstants.questCreated;
      quest.value!.responded = Responded(
        id: quest.value!.responded!.id,
        status: QuestConstants.questResponseAccepted,
        type: QuestConstants.questResponseTypeResponded,
      );
      quest.reportChanged();
      this.onSuccess(WorkerStoreState.acceptInvite);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }

  @action
  rejectInvite(String responseId) async {
    try {
      this.onLoading();
      await _apiProvider.rejectInvite(responseId: responseId);
      WalletRepository().getClient().handleEvent(
            function: WQContractFunctions.declineJob,
            contractAddress: quest.value!.contractAddress!,
            value: null,
          );
      quest.value!.status = QuestConstants.questWaitWorkerOnAssign;
      quest.value!.responded = Responded(
        id: responseId,
        workerId: GetIt.I.get<ProfileMeStore>().userData!.id,
        status: QuestConstants.questResponseRejected,
        type: QuestConstants.questResponseTypeResponded,
      );
      quest.reportChanged();
      this.onSuccess(WorkerStoreState.rejectInvite);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }

  @action
  sendCompleteWork() async {
    try {
      this.onLoading();
      await WalletRepository().getClientWorkNet().handleEvent(
            function: WQContractFunctions.verificationJob,
            contractAddress: quest.value!.contractAddress!,
            value: null,
          );
      quest.value!.status = QuestConstants.questWaitEmployerConfirm;
      quest.reportChanged();
      this.onSuccess(WorkerStoreState.sendCompleteWork);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }

  @action
  sendRespondOnQuest(String message) async {
    try {
      this.onLoading();
      await sendImages(_apiProvider);
      final _id = await _apiProvider.respondOnQuest(
          id: quest.value!.id,
          message: message,
          media: medias.map((media) => media.id).toList());
      quest.value!.status = QuestConstants.questCreated;
      quest.value!.responded = Responded(
        id: _id,
        workerId: GetIt.I.get<ProfileMeStore>().userData!.id,
        status: QuestConstants.questResponseOpen,
        type: QuestConstants.questResponseTypeResponded,
      );
      quest.reportChanged();
      this.onSuccess(WorkerStoreState.sendRespondOnQuest);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }
}

enum WorkerStoreState {
  getQuest,
  sendAcceptOnQuest,
  sendRejectOnQuest,
  acceptInvite,
  rejectInvite,
  sendCompleteWork,
  sendRespondOnQuest,
}
