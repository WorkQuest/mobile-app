import 'package:app/http/api_provider.dart';
import 'package:app/utils/storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:app/base_store/i_store.dart';
import 'package:mobx/mobx.dart';

part 'change_password_store.g.dart';

@injectable
class ChangePasswordStore extends _ChangePasswordStore with _$ChangePasswordStore {
  ChangePasswordStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _ChangePasswordStore extends IStore<ChangePasswordState> with Store {
  final ApiProvider apiProvider;

  _ChangePasswordStore(this.apiProvider);

  @observable
  String password = '';

  @observable
  String newPassword = '';

  @observable
  String confirmNewPassword = '';

  @action
  void setPassword(String value) => password = value;

  @action
  void setNewPassword(String value) => newPassword = value;

  @action
  void setConfirmNewPassword(String value) => confirmNewPassword = value;

  @computed
  bool get canSubmit => !isLoading && password.isNotEmpty && newPassword.isNotEmpty && confirmNewPassword.isNotEmpty;

  @action
  changePassword() async {
    try {
      this.onLoading();
      await apiProvider.changePassword(
        oldPassword: password,
        newPassword: newPassword,
      );
      this.onSuccess(ChangePasswordState.changePassword);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  deleteToken() async {
    try {
      this.onLoading();
      final token = await Storage.readPushToken();
      if (token != null) apiProvider.deletePushToken(token: token);
      FirebaseMessaging.instance.deleteToken();
      this.onSuccess(ChangePasswordState.deleteToken);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}

enum ChangePasswordState { changePassword, deleteToken }
