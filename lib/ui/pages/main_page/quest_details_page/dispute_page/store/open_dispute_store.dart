import 'dart:io';

import 'package:app/http/api_provider.dart';
import 'package:app/utils/dispute_util.dart';
import 'package:app/web3/contractEnums.dart';
import 'package:app/web3/service/client_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/base_store/i_store.dart';

import '../../../../../../web3/repository/account_repository.dart';

part 'open_dispute_store.g.dart';

@injectable
class OpenDisputeStore extends _OpenDisputeStore with _$OpenDisputeStore {
  OpenDisputeStore(ApiProvider _apiProvider) : super(_apiProvider);
}

abstract class _OpenDisputeStore extends IStore<bool> with Store {
  _OpenDisputeStore(this._apiProvider);

  final ApiProvider _apiProvider;

  @observable
  String theme = "dispute.theme";

  @observable
  String description = '';

  String fee = "";

  @computed
  bool get isButtonEnable =>
      theme != "dispute.theme" && description.isNotEmpty && !this.isLoading;

  @action
  void setDescription(String value) => description = value;

  @action
  void setTheme(String theme) => this.theme = theme;

  getFee(String contractAddress) async {
    try {
      final _client = AccountRepository().getClientWorkNet();
      final _contract = await _client.getDeployedContract("WorkQuest", contractAddress);
      final _function = _contract.function(WQContractFunctions.arbitration.name);
      final _gas = await _client.getEstimateGasCallContract(
        contract: _contract,
        function: _function,
        params: [],
        value: "1",
      );
      fee = _gas.toStringAsFixed(17);
    } on SocketException catch (_) {
      onError("Lost connection to server");
    }
  }

  @action
  openDispute(String questId, String contractAddress) async {
    try {
      this.onLoading();
      final result = await _apiProvider.openDispute(
        questId: questId,
        reason: DisputeUtil.getThemeValue(theme),
        problemDescription: description,
      );
      if (result) {
        await AccountRepository().getClientWorkNet().handleEvent(
              function: WQContractFunctions.arbitration,
              contractAddress: contractAddress,
              value: "1",
            );
        this.onSuccess(true);
      } else {
        this.onError("modals.disputeNotCreated".tr());
      }
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
