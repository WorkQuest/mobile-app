// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'choose_role_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChooseRoleStore on _ChooseRoleStore, Store {
  Computed<bool>? _$canSubmitCodeComputed;

  @override
  bool get canSubmitCode =>
      (_$canSubmitCodeComputed ??= Computed<bool>(() => super.canSubmitCode,
              name: '_ChooseRoleStore.canSubmitCode'))
          .value;
  Computed<bool>? _$privacyPolicyComputed;

  @override
  bool get privacyPolicy =>
      (_$privacyPolicyComputed ??= Computed<bool>(() => super.privacyPolicy,
              name: '_ChooseRoleStore.privacyPolicy'))
          .value;
  Computed<bool>? _$termsAndConditionsComputed;

  @override
  bool get termsAndConditions => (_$termsAndConditionsComputed ??=
          Computed<bool>(() => super.termsAndConditions,
              name: '_ChooseRoleStore.termsAndConditions'))
      .value;
  Computed<bool>? _$amlAndCtfPolicyComputed;

  @override
  bool get amlAndCtfPolicy =>
      (_$amlAndCtfPolicyComputed ??= Computed<bool>(() => super.amlAndCtfPolicy,
              name: '_ChooseRoleStore.amlAndCtfPolicy'))
          .value;
  Computed<bool>? _$canApproveComputed;

  @override
  bool get canApprove =>
      (_$canApproveComputed ??= Computed<bool>(() => super.canApprove,
              name: '_ChooseRoleStore.canApprove'))
          .value;

  final _$_privacyPolicyAtom = Atom(name: '_ChooseRoleStore._privacyPolicy');

  @override
  bool get _privacyPolicy {
    _$_privacyPolicyAtom.reportRead();
    return super._privacyPolicy;
  }

  @override
  set _privacyPolicy(bool value) {
    _$_privacyPolicyAtom.reportWrite(value, super._privacyPolicy, () {
      super._privacyPolicy = value;
    });
  }

  final _$totpAtom = Atom(name: '_ChooseRoleStore.totp');

  @override
  String get totp {
    _$totpAtom.reportRead();
    return super.totp;
  }

  @override
  set totp(String value) {
    _$totpAtom.reportWrite(value, super.totp, () {
      super.totp = value;
    });
  }

  final _$_codeFromEmailAtom = Atom(name: '_ChooseRoleStore._codeFromEmail');

  @override
  String get _codeFromEmail {
    _$_codeFromEmailAtom.reportRead();
    return super._codeFromEmail;
  }

  @override
  set _codeFromEmail(String value) {
    _$_codeFromEmailAtom.reportWrite(value, super._codeFromEmail, () {
      super._codeFromEmail = value;
    });
  }

  final _$_termsAndConditionsAtom =
      Atom(name: '_ChooseRoleStore._termsAndConditions');

  @override
  bool get _termsAndConditions {
    _$_termsAndConditionsAtom.reportRead();
    return super._termsAndConditions;
  }

  @override
  set _termsAndConditions(bool value) {
    _$_termsAndConditionsAtom.reportWrite(value, super._termsAndConditions, () {
      super._termsAndConditions = value;
    });
  }

  final _$_amlAndCtfPolicyAtom =
      Atom(name: '_ChooseRoleStore._amlAndCtfPolicy');

  @override
  bool get _amlAndCtfPolicy {
    _$_amlAndCtfPolicyAtom.reportRead();
    return super._amlAndCtfPolicy;
  }

  @override
  set _amlAndCtfPolicy(bool value) {
    _$_amlAndCtfPolicyAtom.reportWrite(value, super._amlAndCtfPolicy, () {
      super._amlAndCtfPolicy = value;
    });
  }

  final _$userRoleAtom = Atom(name: '_ChooseRoleStore.userRole');

  @override
  UserRole get userRole {
    _$userRoleAtom.reportRead();
    return super.userRole;
  }

  @override
  set userRole(UserRole value) {
    _$userRoleAtom.reportWrite(value, super.userRole, () {
      super.userRole = value;
    });
  }

  final _$approveRoleAsyncAction = AsyncAction('_ChooseRoleStore.approveRole');

  @override
  Future<dynamic> approveRole() {
    return _$approveRoleAsyncAction.run(() => super.approveRole());
  }

  final _$changeRoleAsyncAction = AsyncAction('_ChooseRoleStore.changeRole');

  @override
  Future<dynamic> changeRole() {
    return _$changeRoleAsyncAction.run(() => super.changeRole());
  }

  final _$confirmEmailAsyncAction =
      AsyncAction('_ChooseRoleStore.confirmEmail');

  @override
  Future<dynamic> confirmEmail() {
    return _$confirmEmailAsyncAction.run(() => super.confirmEmail());
  }

  final _$refreshTokenAsyncAction =
      AsyncAction('_ChooseRoleStore.refreshToken');

  @override
  Future<dynamic> refreshToken() {
    return _$refreshTokenAsyncAction.run(() => super.refreshToken());
  }

  final _$_ChooseRoleStoreActionController =
      ActionController(name: '_ChooseRoleStore');

  @override
  void setTotp(String value) {
    final _$actionInfo = _$_ChooseRoleStoreActionController.startAction(
        name: '_ChooseRoleStore.setTotp');
    try {
      return super.setTotp(value);
    } finally {
      _$_ChooseRoleStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCode(String value) {
    final _$actionInfo = _$_ChooseRoleStoreActionController.startAction(
        name: '_ChooseRoleStore.setCode');
    try {
      return super.setCode(value);
    } finally {
      _$_ChooseRoleStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPrivacyPolicy(bool value) {
    final _$actionInfo = _$_ChooseRoleStoreActionController.startAction(
        name: '_ChooseRoleStore.setPrivacyPolicy');
    try {
      return super.setPrivacyPolicy(value);
    } finally {
      _$_ChooseRoleStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTermsAndConditions(bool value) {
    final _$actionInfo = _$_ChooseRoleStoreActionController.startAction(
        name: '_ChooseRoleStore.setTermsAndConditions');
    try {
      return super.setTermsAndConditions(value);
    } finally {
      _$_ChooseRoleStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAmlAndCtfPolicy(bool value) {
    final _$actionInfo = _$_ChooseRoleStoreActionController.startAction(
        name: '_ChooseRoleStore.setAmlAndCtfPolicy');
    try {
      return super.setAmlAndCtfPolicy(value);
    } finally {
      _$_ChooseRoleStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUserRole(UserRole role) {
    final _$actionInfo = _$_ChooseRoleStoreActionController.startAction(
        name: '_ChooseRoleStore.setUserRole');
    try {
      return super.setUserRole(role);
    } finally {
      _$_ChooseRoleStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
totp: ${totp},
userRole: ${userRole},
canSubmitCode: ${canSubmitCode},
privacyPolicy: ${privacyPolicy},
termsAndConditions: ${termsAndConditions},
amlAndCtfPolicy: ${amlAndCtfPolicy},
canApprove: ${canApprove}
    ''';
  }
}
