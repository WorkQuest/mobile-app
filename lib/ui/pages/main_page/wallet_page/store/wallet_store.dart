import 'package:app/http/api_provider.dart';
import 'package:injectable/injectable.dart';
import 'package:app/base_store/i_store.dart';
import 'package:mobx/mobx.dart';

part 'wallet_store.g.dart';

@injectable
class WalletStore extends _WalletStore with _$WalletStore {
  WalletStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _WalletStore extends IStore<bool> with Store {
  final ApiProvider apiProvider;

  _WalletStore(this.apiProvider);

  @observable
  String _recipientAddress = '';
  @observable
  String amount = '';

  @action
  void setRecipientAddress(String value) => _recipientAddress = value;

  @action
  void setAmount(String value) => amount = value;

  @action
  String getAmount() => amount;

  @action
  String getAddress() => _recipientAddress;

  @action
  void clearValues() {
    amount = "";
    _recipientAddress = "";
  }

  @computed
  bool get canSubmit =>
      !isLoading && _recipientAddress.isNotEmpty && amount.isNotEmpty;
}
