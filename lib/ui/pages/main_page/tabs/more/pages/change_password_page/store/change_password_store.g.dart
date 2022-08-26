// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChangePasswordStore on _ChangePasswordStore, Store {
  Computed<bool>? _$canSubmitComputed;

  @override
  bool get canSubmit =>
      (_$canSubmitComputed ??= Computed<bool>(() => super.canSubmit,
              name: '_ChangePasswordStore.canSubmit'))
          .value;

  final _$privacyAtom = Atom(name: '_ChangePasswordStore.privacy');

  @override
  int get privacy {
    _$privacyAtom.reportRead();
    return super.privacy;
  }

  @override
  set privacy(int value) {
    _$privacyAtom.reportWrite(value, super.privacy, () {
      super.privacy = value;
    });
  }

  final _$filterAtom = Atom(name: '_ChangePasswordStore.filter');

  @override
  int get filter {
    _$filterAtom.reportRead();
    return super.filter;
  }

  @override
  set filter(int value) {
    _$filterAtom.reportWrite(value, super.filter, () {
      super.filter = value;
    });
  }

  final _$passwordAtom = Atom(name: '_ChangePasswordStore.password');

  @override
  String get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  final _$newPasswordAtom = Atom(name: '_ChangePasswordStore.newPassword');

  @override
  String get newPassword {
    _$newPasswordAtom.reportRead();
    return super.newPassword;
  }

  @override
  set newPassword(String value) {
    _$newPasswordAtom.reportWrite(value, super.newPassword, () {
      super.newPassword = value;
    });
  }

  final _$confirmNewPasswordAtom =
      Atom(name: '_ChangePasswordStore.confirmNewPassword');

  @override
  String get confirmNewPassword {
    _$confirmNewPasswordAtom.reportRead();
    return super.confirmNewPassword;
  }

  @override
  set confirmNewPassword(String value) {
    _$confirmNewPasswordAtom.reportWrite(value, super.confirmNewPassword, () {
      super.confirmNewPassword = value;
    });
  }

  final _$_ChangePasswordStoreActionController =
      ActionController(name: '_ChangePasswordStore');

  @override
  void setPassword(String value) {
    final _$actionInfo = _$_ChangePasswordStoreActionController.startAction(
        name: '_ChangePasswordStore.setPassword');
    try {
      return super.setPassword(value);
    } finally {
      _$_ChangePasswordStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNewPassword(String value) {
    final _$actionInfo = _$_ChangePasswordStoreActionController.startAction(
        name: '_ChangePasswordStore.setNewPassword');
    try {
      return super.setNewPassword(value);
    } finally {
      _$_ChangePasswordStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setConfirmNewPassword(String value) {
    final _$actionInfo = _$_ChangePasswordStoreActionController.startAction(
        name: '_ChangePasswordStore.setConfirmNewPassword');
    try {
      return super.setConfirmNewPassword(value);
    } finally {
      _$_ChangePasswordStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
privacy: ${privacy},
filter: ${filter},
password: ${password},
newPassword: ${newPassword},
confirmNewPassword: ${confirmNewPassword},
canSubmit: ${canSubmit}
    ''';
  }
}
