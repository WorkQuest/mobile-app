// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'choose_role_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChooseRoleStore on _ChooseRoleStore, Store {
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
  Computed<UserRole>? _$userRoleComputed;

  @override
  UserRole get userRole =>
      (_$userRoleComputed ??= Computed<UserRole>(() => super.userRole,
              name: '_ChooseRoleStore.userRole'))
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

  final _$_userRoleAtom = Atom(name: '_ChooseRoleStore._userRole');

  @override
  UserRole get _userRole {
    _$_userRoleAtom.reportRead();
    return super._userRole;
  }

  @override
  set _userRole(UserRole value) {
    _$_userRoleAtom.reportWrite(value, super._userRole, () {
      super._userRole = value;
    });
  }

  final _$_ChooseRoleStoreActionController =
      ActionController(name: '_ChooseRoleStore');

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
termsAndConditions: ${termsAndConditions},
amlAndCtfPolicy: ${amlAndCtfPolicy},
userRole: ${userRole}
    ''';
  }
}