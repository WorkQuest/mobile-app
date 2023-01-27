import 'package:app/base_store/i_store.dart';
import 'package:app/constants.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/model/respond_model.dart';
import 'package:app/http/web_socket.dart';
import 'package:app/utils/quest_util.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart';
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

abstract class _EmployerStore extends IStore<EmployerStoreState> with Store {
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
      this.onSuccess(EmployerStoreState.getQuest);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  void changeQuest(dynamic json) {
    var changedQuest = BaseQuestResponse.fromJson(json["data"]["quest"] ?? json["data"]);
    if (changedQuest.id == quest.value?.id) {
      quest.value = changedQuest;
      // _getQuest();
      getRespondedList(changedQuest.id, changedQuest.assignedWorker?.id ?? "");
    }
  }

  getFee(String userId, String functionName) async {
    final _needParams = functionName == WQContractFunctions.assignJob.name;
    List<dynamic> _params = [];
    final _client = AccountRepository().getClientWorkNet();
    final _contract = await _client.getDeployedContract(
      "WorkQuest",
      quest.value!.contractAddress!,
    );
    final _function = _contract.function(functionName);
    if (_needParams) {
      final _user = await _apiProvider.getProfileUser(userId: userId);
      _params = [EthereumAddress.fromHex(_user.walletAddress!)];
    }
    final _gas = await _client.getEstimateGasCallContract(
        contract: _contract,
        function: _function,
        params: _params,
        value: functionName == WQContractFunctions.arbitration.name ? "1" : null);
    await Web3Utils.checkPossibilityTx(
      typeCoin: TokenSymbols.WQT,
      fee: Decimal.parse(_gas.toString()),
      amount: 0.0,
      isMain: true,
    );
    fee = _gas.toStringAsFixed(17);
  }

  @action
  startQuest({
    required String questId,
    required String userId,
  }) async {
    try {
      this.onLoading();
      print('startQuest');
      final user = await _apiProvider.getProfileUser(userId: userId);
      await AccountRepository().getClient().handleEvent(
            function: WQContractFunctions.assignJob,
            contractAddress: quest.value!.contractAddress!,
            params: [
              EthereumAddress.fromHex(user.walletAddress!),
            ],
            value: null,
          );
      quest.value!.status = QuestConstants.questWaitWorker;
      quest.reportChanged();
      this.onSuccess(EmployerStoreState.startQuest);
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
      await AccountRepository().getClientWorkNet().handleEvent(
            function: WQContractFunctions.acceptJobResult,
            contractAddress: quest.value!.contractAddress!,
            value: null,
          );
      quest.value!.status = QuestConstants.questDone;
      quest.reportChanged();
      this.onSuccess(EmployerStoreState.acceptCompletedWork);
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
      await AccountRepository().getClientWorkNet().handleEvent(
            function: WQContractFunctions.cancelJob,
            contractAddress: quest.value!.contractAddress!,
            value: null,
          );
      this.onSuccess(EmployerStoreState.deleteQuest);
    } catch (e, trace) {
      print("accept error: $e\n$trace");
      this.onError(e.toString());
    }
  }

  @action
  validateTotp({bool isEdit = false}) async {
    try {
      this.onLoading();
      isValid = await _apiProvider.validateTotp(totp: totp);
      if (isValid == false) {
        this.onError("modals.invalid2FA".tr());
        return;
      }
      this.onSuccess(isEdit
          ? EmployerStoreState.validateTotpEdit
          : EmployerStoreState.validateTotpDelete);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}

enum EmployerStoreState {
  startQuest,
  deleteQuest,
  validateTotpDelete,
  validateTotpEdit,
  acceptCompletedWork,
  getQuest,
  getFee
}
