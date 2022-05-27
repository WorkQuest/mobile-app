import 'dart:io';
import 'dart:math';

import 'package:app/http/api_provider.dart';
import 'package:app/web3/contractEnums.dart';
import 'package:app/web3/service/client_service.dart';
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

  final List<String> disputeCategoriesList = [
    "chat.disputeTheme.noResponse",
    "chat.disputeTheme.badlyDone",
    "chat.disputeTheme.additionalRequirements",
    "chat.disputeTheme.inconsistencies",
    "chat.disputeTheme.notConfirmed",
    "chat.disputeTheme.anotherReason"
  ];

  @observable
  String theme = "dispute.theme";

  String themeValue = "";

  @observable
  String description = '';

  String fee = "";

  bool isButtonEnable() =>
      theme != "dispute.theme" && description.isNotEmpty && !this.isLoading;

  @action
  void setDescription(String value) => description = value;

  @action
  void changeTheme(String selectTheme) {
    switch (selectTheme) {
      case "chat.disputeTheme.noResponse":
        theme = "chat.disputeTheme.noResponse";
        break;
      case "chat.disputeTheme.badlyDone":
        theme = "chat.disputeTheme.badlyDone";
        break;
      case "chat.disputeTheme.additionalRequirements":
        theme = "chat.disputeTheme.additionalRequirements";
        break;
      case "chat.disputeTheme.inconsistencies":
        theme = "chat.disputeTheme.inconsistencies";
        break;
      case "chat.disputeTheme.notConfirmed":
        theme = "chat.disputeTheme.notConfirmed";
        break;
      case "chat.disputeTheme.anotherReason":
        theme = "chat.disputeTheme.anotherReason";
        break;
      default:
        theme = "chat.disputeTheme.anotherReason";
    }
  }

  String getTheme() {
    switch (theme) {
      case "chat.disputeTheme.noResponse":
        return themeValue = "NoAnswer";
      case "chat.disputeTheme.badlyDone":
        return themeValue = "PoorlyDoneJob";
      case "chat.disputeTheme.additionalRequirements":
        return themeValue = "AdditionalRequirement";
      case "chat.disputeTheme.inconsistencies":
        return themeValue = "RequirementDoesNotMatch";
      case "chat.disputeTheme.notConfirmed":
        return themeValue = "NoConfirmationOfComplete";
      case "chat.disputeTheme.anotherReason":
        return themeValue = "AnotherReason";
    }
    return themeValue;
  }

  Future<void> getFee() async {
    try {
      final gas = await AccountRepository().service!.getGas();
      fee = (1 + (gas.getInWei.toInt() / pow(10, 18))).toStringAsFixed(17);
    } on SocketException catch (_) {
      onError("Lost connection to server");
    }
  }

  Future<void> openDispute(String questId, String contractAddress) async {
    try {
      this.onLoading();
      final result = await _apiProvider.openDispute(
        questId: questId,
        reason: getTheme(),
        problemDescription: description,
      );
      if (result) {
        await AccountRepository().service!.handleEvent(
          function: WQContractFunctions.arbitration,
          contractAddress: contractAddress,
          value: "1",
        );
        this.onSuccess(true);
      } else
        this.onError("Dispute not created");
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
