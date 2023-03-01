import 'package:app/http/api_provider.dart';
import 'package:injectable/injectable.dart';
import 'package:app/base_store/i_store.dart';
import 'package:mobx/mobx.dart';

part 'deposit_store.g.dart';

@injectable
class DepositStore extends _DepositStore with _$DepositStore {
  DepositStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _DepositStore extends IStore<bool> with Store {
  final ApiProvider apiProvider;

  _DepositStore(this.apiProvider);

  String amount = '';

  @action
  void setAmount(String value) {
    amount = value;
  }
// @computed
// bool get canSubmit =>
//     !isLoading &&
//         password.isNotEmpty &&
//         newPassword.isNotEmpty &&
//         confirmNewPassword.isNotEmpty;
}
