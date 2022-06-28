import 'dart:io';

import 'package:app/base_store/i_store.dart';
import 'package:app/constants.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/model/media_model.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/utils/web_socket.dart';

import '../../../../../../web3/contractEnums.dart';
import '../../../../../../web3/repository/account_repository.dart';
import '../../../../../../web3/service/client_service.dart';

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

  String fee = "";

  @observable
  ObservableList<File> mediaFile = ObservableList();

  @observable
  ObservableList<Media> mediaIds = ObservableList();

  Future<void> getFee(String functionName) async {
    try {
      final _client = AccountRepository().getClient();
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
  Future<void> getQuest(String questId) async {
    try {
      this.onLoading();
      quest.value = await _apiProvider.getQuest(id: questId);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

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

  @action
  Future<void> checkPossibilityTx(String functionName) async {
    try {
      this.onLoading();
      await getFee(functionName);
      await Web3Utils.checkPossibilityTx(
        typeCoin: TokenSymbols.WQT,
        gas: double.parse(fee),
        amount: 0.0,
        isMain: true,
      );
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  sendAcceptOnQuest() async {
    try {
      this.onLoading();
      // await _apiProvider.acceptOnQuest(questId: quest.value!.id);
      await AccountRepository().getClient().handleEvent(
            function: WQContractFunctions.acceptJob,
            contractAddress: quest.value!.contractAddress!,
          );
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
      // await _apiProvider.rejectOnQuest(questId: quest.value!.id);
      AccountRepository().getClient().handleEvent(
            function: WQContractFunctions.declineJob,
            contractAddress: quest.value!.contractAddress!,
          );
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
      await AccountRepository().getClient().handleEvent(
            function: WQContractFunctions.verificationJob,
            contractAddress: quest.value!.contractAddress!,
          );
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
