import 'package:app/http/api_provider.dart';
import 'package:injectable/injectable.dart';
import 'package:app/base_store/i_store.dart';
import 'package:mobx/mobx.dart';

part 'withdraw_page_store.g.dart';

@injectable
class WithdrawPageStore extends _WithdrawPageStore with _$WithdrawPageStore {
  WithdrawPageStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _WithdrawPageStore extends IStore<bool> with Store {
  final ApiProvider apiProvider;

  _WithdrawPageStore(this.apiProvider);

  @observable
  String _recipientAddress = '';
  @observable
  String amount = '';

  @action
  void setRecipientAddress(String value) {
    _recipientAddress = value;
  }

  @action
  void setAmount(String value) {
    amount = value;
  }

  @action
  String getAmount() => amount;

  @action
  String getAddress() => _recipientAddress;

  @computed
  bool get canSubmit =>
      !isLoading && _recipientAddress.isNotEmpty && amount.isNotEmpty;
}
