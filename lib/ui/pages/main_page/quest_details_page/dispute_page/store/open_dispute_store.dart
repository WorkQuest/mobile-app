import 'package:app/http/api_provider.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/base_store/i_store.dart';

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

  bool isButtonEnable() => theme != "dispute.theme" && description.isNotEmpty;

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
        return themeValue = "noAnswer";
      case "chat.disputeTheme.badlyDone":
        return themeValue = "poorlyDoneJob";
      case "chat.disputeTheme.additionalRequirements":
        return themeValue = "additionalRequirement";
      case "chat.disputeTheme.inconsistencies":
        return themeValue = "requirementDoesNotMatch";
      case "chat.disputeTheme.notConfirmed":
        return themeValue = "noConfirmationOfComplete";
      case "chat.disputeTheme.anotherReason":
        return themeValue = "anotherReason";
    }
    return themeValue;
  }

  Future<void> openDispute(String questId) async {
    try {
      this.onLoading();
      await _apiProvider.openDispute(
        questId: questId,
        reason: getTheme(),
        problemDescription: description,
      );
      this.onSuccess(true);
    } on Exception catch (e) {
      onError(e.toString());
    }
  }
}
