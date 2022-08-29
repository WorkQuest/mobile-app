import 'dart:async';

import 'package:app/base_store/i_store.dart';
import 'package:app/enums.dart';
import 'package:app/repository/choose_role_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:app/http/api_provider.dart';
import 'package:mobx/mobx.dart';

part 'choose_role_store.g.dart';

@singleton
class ChooseRoleStore extends _ChooseRoleStore with _$ChooseRoleStore {
  ChooseRoleStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _ChooseRoleStore extends IStore<ChooseRoleState> with Store {
  final IChooseRoleRepository _repository;

  _ChooseRoleStore(ApiProvider apiProvider)
      : _repository = ChooseRoleRepository(apiProvider);

  @observable
  bool _privacyPolicy = false;

  bool isChange = false;

  @observable
  String platform = "";

  @observable
  String totp = "";

  @observable
  bool _termsAndConditions = false;

  @observable
  bool _amlAndCtfPolicy = false;

  @observable
  UserRole userRole = UserRole.Employer;

  void setRole(UserRole role) => userRole = role;

  void setPlatform(String value) => platform = value;

  String getRole() {
    if (userRole == UserRole.Employer)
      return UserRole.Worker.name;
    else
      return UserRole.Employer.name;
  }

  void setChange(bool change) => isChange = true;

  @action
  void setTotp(String value) => totp = value;

  @action
  void setPrivacyPolicy(bool value) => _privacyPolicy = value;

  @action
  void setTermsAndConditions(bool value) => _termsAndConditions = value;

  @action
  void setAmlAndCtfPolicy(bool value) => _amlAndCtfPolicy = value;

  @action
  void setUserRole(UserRole role) => userRole = role;

  @action
  Future approveRole() async {
    try {
      this.onLoading();
      await _repository.approveRole(isChange: isChange, role: userRole);
      this.onSuccess(ChooseRoleState.approveRole);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future changeRole() async {
    try {
      this.onLoading();
      await _repository.changeRole(totp);
      this.onSuccess(ChooseRoleState.changeRole);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future refreshToken() async {
    try {
      this.onLoading();
      await _repository.refreshToken();
      this.onSuccess(ChooseRoleState.refreshToken);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  Future<void> deletePushToken() async {
    try {
      this.onLoading();
      await _repository.deletePushToken();
      this.onSuccess(ChooseRoleState.deletePushToken);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @computed
  bool get privacyPolicy => _privacyPolicy;

  @computed
  bool get termsAndConditions => _termsAndConditions;

  @computed
  bool get amlAndCtfPolicy => _amlAndCtfPolicy;

  @computed
  bool get canApprove =>
      _privacyPolicy && _amlAndCtfPolicy && _termsAndConditions;

  @action
  clearData() {
    _privacyPolicy = false;
    isChange = false;
    platform = '';
    totp = '';
    _termsAndConditions = false;
    _amlAndCtfPolicy = false;
    userRole = UserRole.Employer;
  }
}

enum ChooseRoleState { approveRole, deletePushToken, refreshToken, changeRole }
