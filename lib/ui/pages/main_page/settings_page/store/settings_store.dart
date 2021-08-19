import 'package:app/http/api_provider.dart';
import 'package:injectable/injectable.dart';
import 'package:app/base_store/i_store.dart';
import 'package:mobx/mobx.dart';
part 'settings_store.g.dart';

@injectable
class SettingsPageStore extends _SettingsPageStore with _$SettingsPageStore {
  SettingsPageStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _SettingsPageStore extends IStore<bool> with Store {
  final ApiProvider apiProvider;

  _SettingsPageStore(this.apiProvider);

  @observable
  bool smsVerificationStatus = false;
  @observable
  bool faStatus = false;
  @observable
  int privacy = 1;
  @observable
  int filter = 2;
  @observable
  String password = '';
  @observable
  String newPassword = '';
  @observable
  String confirmNewPassword = '';

  @action
  void changePrivacy(int? value) {
    privacy = value!;
  }

  @action
  void changeFilter(int? choice) {
    filter = choice!;
  }

  @action
  void changeSmsVerification(bool value) {
    smsVerificationStatus = value;
  }

  @action
  void change2FAStatus(bool value) {
    faStatus = value;
  }

  @action
  void setPassword(String value) {
    password = value;
  }

  @action
  void setNewPassword(String value) {
    newPassword = value;
  }

  @action
  void setConfirmNewPassword(String value) {
    confirmNewPassword = value;
  }

  @computed
  bool get canSubmit =>
      !isLoading &&
      password.isNotEmpty &&
      newPassword.isNotEmpty &&
      confirmNewPassword.isNotEmpty;

  @action
  Future changePassword() async {
    try {
      this.onLoading();
      await apiProvider.changePassword(
        oldPassword: password,
        newPassword: newPassword,
      );
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
