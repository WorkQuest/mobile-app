import 'dart:io';

import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/model/respond_model.dart';
import 'package:app/utils/web_socket.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:web3dart/credentials.dart';

import '../../../../../../web3/contractEnums.dart';
import '../../../../../../web3/service/client_service.dart';

part 'employer_store.g.dart';

@injectable
class EmployerStore extends _EmployerStore with _$EmployerStore {
  EmployerStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _EmployerStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _EmployerStore(this._apiProvider) {
    WebSocket().handlerQuests = this.changeQuest;
  }

  @observable
  List<RespondModel> respondedList = [];

  @observable
  RespondModel? selectedResponders;

  @observable
  bool isValid = false;

  @observable
  String totp = "";

  String fee = "";

  Observable<BaseQuestResponse?> quest = Observable(null);

  @action
  setTotp(String value) => totp = value;

  @action
  setQuestStatus(int value) => quest.value!.status = value;

  @action
  getRespondedList(String id, String idWorker) async {
    respondedList = await _apiProvider.responsesQuest(id);
    for (int index = 0; index < respondedList.length; index++)
      if (respondedList[index].workerId == idWorker ||
          respondedList[index].status == -1 ||
          // respondedList[index].status == 0 ||
          (respondedList[index].type == 1 && respondedList[index].status != 1))
        respondedList.removeAt(index);
  }

  _getQuest() async {
    final newQuest = await _apiProvider.getQuest(id: quest.value!.id);
    quest.value!.update(newQuest);
    quest.reportChanged();
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
  void changeQuest(dynamic json) {
    var changedQuest =
        BaseQuestResponse.fromJson(json["data"]["quest"] ?? json["data"]);
    if (changedQuest.id == quest.value?.id) {
      quest.value = changedQuest;
      _getQuest();
      getRespondedList(changedQuest.id, changedQuest.assignedWorker?.id ?? "");
    }
  }

  Future<void> getFee(String userId) async {
    try {
      final _user = await _apiProvider.getProfileUser(userId: userId);
      final _client = AccountRepository().getClient();
      final _contract = await _client.getDeployedContract("WorkQuest", quest.value!.contractAddress!);
      final _function = _contract.function(WQContractFunctions.assignJob.name);
      final _gas = await _client.getEstimateGasCallContract(contract: _contract, function: _function, params: [EthereumAddress.fromHex(_user.walletAddress!)]);
      fee = _gas.toStringAsFixed(17);
    } on SocketException catch (_) {
      onError("Lost connection to server");
    }
  }

  @action
  startQuest({
    required String questId,
    required String userId,
  }) async {
    try {
      this.onLoading();
      final user = await _apiProvider.getProfileUser(userId: userId);
      // Remove request
      // await _apiProvider.startQuest(questId: questId, userId: userId);

      await AccountRepository().getClient().handleEvent(
            function: WQContractFunctions.assignJob,
            contractAddress: quest.value!.contractAddress!,
            params: [
              EthereumAddress.fromHex(user.walletAddress!),
            ],
            value: null,
          );
      await _getQuest();
      this.onSuccess(true);
    } catch (e, trace) {
      print("accept error: $e\n$trace");
      this.onError(e.toString());
    }
  }

  @action
  acceptCompletedWork({
    required String questId,
  }) async {
    try {
      this.onLoading();
      // await _apiProvider.acceptCompletedWork(questId: questId);
      await AccountRepository().getClient().handleEvent(
            function: WQContractFunctions.acceptJobResult,
            contractAddress: quest.value!.contractAddress!,
            value: null,
          );
      await _getQuest();
      this.onSuccess(true);
    } catch (e, trace) {
      print("accept error: $e\n$trace");
      this.onError(e.toString());
    }
  }

  @action
  deleteQuest({
    required String questId,
  }) async {
    try {
      this.onLoading();
      await _getQuest();
      // await _apiProvider.deleteQuest(questId: questId);
      await AccountRepository().getClient().handleEvent(
            function: WQContractFunctions.cancelJob,
            contractAddress: quest.value!.contractAddress!,
            value: null,
          );
      this.onSuccess(true);
    } catch (e, trace) {
      print("accept error: $e\n$trace");
      this.onError(e.toString());
    }
  }

  @action
  Future<void> validateTotp() async {
    try {
      this.onLoading();
      isValid = await _apiProvider.validateTotp(totp: totp);
      if (isValid == false) {
        this.onError("Invalid 2FA");
        return;
      }
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
