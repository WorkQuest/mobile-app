import 'package:app/base_store/i_store.dart';
import 'package:app/enums.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'choose_role_store.g.dart';

@injectable
@singleton
class ChooseRoleStore extends _ChooseRoleStore with _$ChooseRoleStore {
  ChooseRoleStore();
}

abstract class _ChooseRoleStore extends IStore<bool> with Store {
  _ChooseRoleStore();

  @observable
  bool _privacyPolicy = false;

  @observable
  bool _termsAndConditions = false;

  @observable
  bool _amlAndCtfPolicy = false;

  @observable
  UserRole _userRole = UserRole.Worker;

  @action
  void setPrivacyPolicy(bool value) => _privacyPolicy = value;

  @action
  void setTermsAndConditions(bool value) => _termsAndConditions = value;

  @action
  void setAmlAndCtfPolicy(bool value) => _amlAndCtfPolicy = value;

  @action
  void setUserRole(UserRole role) => _userRole = role;

  @computed
  bool get privacyPolicy => _privacyPolicy;

  @computed
  bool get termsAndConditions => _termsAndConditions;

  @computed
  bool get amlAndCtfPolicy => _amlAndCtfPolicy;

  @computed
  UserRole get userRole => _userRole;
}
