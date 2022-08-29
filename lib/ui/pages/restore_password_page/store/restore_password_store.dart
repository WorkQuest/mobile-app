import 'package:app/http/api_provider.dart';
import 'package:injectable/injectable.dart';
import 'package:app/base_store/i_store.dart';
import 'package:mobx/mobx.dart';

part 'restore_password_store.g.dart';

@injectable
class RestorePasswordStore extends _RestorePasswordStore
    with _$RestorePasswordStore {
  RestorePasswordStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _RestorePasswordStore extends IStore<RestorePasswordState>
    with Store {
  final ApiProvider _apiProvider;

  _RestorePasswordStore(this._apiProvider);

  @observable
  String email = '';
  @observable
  String password = '';
  @observable
  String code = '';

  @action
  void setPassword(String value) {
    password = value;
  }

  @action
  void setEmail(String value) {
    email = value;
  }

  @action
  void setCode(String value) {
    code = value;
  }

  @computed
  bool get canSubmit => !isLoading && password.isNotEmpty && code.isNotEmpty;

  @action
  Future requestCode() async {
    try {
      this.onLoading();
      await _apiProvider.sendCodeToEmail(
        email: email,
      );
      this.onSuccess(RestorePasswordState.requestCode);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future restorePassword() async {
    try {
      this.onLoading();
      await _apiProvider.setPassword(
        newPassword: password,
        token: code,
      );
      this.onSuccess(RestorePasswordState.restorePassword);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}

enum RestorePasswordState { requestCode, restorePassword }
