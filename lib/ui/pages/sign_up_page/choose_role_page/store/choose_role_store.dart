import 'package:app/base_store/i_store.dart';
import 'package:app/enums.dart';
import 'package:injectable/injectable.dart';
import 'package:app/http/api_provider.dart';
import 'package:mobx/mobx.dart';

part 'choose_role_store.g.dart';

@injectable
@singleton
class ChooseRoleStore extends _ChooseRoleStore with _$ChooseRoleStore {
  ChooseRoleStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _ChooseRoleStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _ChooseRoleStore(this._apiProvider);

  @observable
  bool _privacyPolicy = false;

  bool isChange = false;

  @observable
  String totp = "";

  @observable
  String _codeFromEmail = "";

  @observable
  bool _termsAndConditions = false;

  @observable
  bool _amlAndCtfPolicy = false;

  @observable
  UserRole _userRole = UserRole.Employer;

  String getRole() {
    if (userRole == UserRole.Employer)
      return UserRole.Worker.name;
    else
      return UserRole.Employer.name;
  }

  @action
  void setTotp(String value) => totp = value;

  @action
  void setCode(String value) => _codeFromEmail = value;

  @action
  void setPrivacyPolicy(bool value) => _privacyPolicy = value;

  @action
  void setTermsAndConditions(bool value) => _termsAndConditions = value;

  @action
  void setAmlAndCtfPolicy(bool value) => _amlAndCtfPolicy = value;

  @action
  void setUserRole(UserRole role) => _userRole = role;

  @action
  Future approveRole() async {
    try {
      this.onLoading();
      await _apiProvider.setRole(
        isChange
            ? _userRole == UserRole.Worker
                ? "employer"
                : "worker"
            : _userRole == UserRole.Worker
                ? "worker"
                : "employer",
      );
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future changeRole() async {
    try{
      this.onLoading();
      await _apiProvider.changeRole(totp);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future confirmEmail() async {
    try {
      this.onLoading();
      await _apiProvider.confirmEmail(
        code: _codeFromEmail.trim(),
      );
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @computed
  bool get canSubmitCode =>
      _codeFromEmail.isNotEmpty && _codeFromEmail.length > 4;

  @computed
  bool get privacyPolicy => _privacyPolicy;

  @computed
  bool get termsAndConditions => _termsAndConditions;

  @computed
  bool get amlAndCtfPolicy => _amlAndCtfPolicy;

  @computed
  bool get canApprove =>
      _privacyPolicy && _amlAndCtfPolicy && _termsAndConditions;

  @computed
  UserRole get userRole => _userRole;
}
