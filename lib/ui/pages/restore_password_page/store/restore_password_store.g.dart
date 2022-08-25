// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restore_password_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RestorePasswordStore on _RestorePasswordStore, Store {
  Computed<bool>? _$canSubmitComputed;

  @override
  bool get canSubmit =>
      (_$canSubmitComputed ??= Computed<bool>(() => super.canSubmit,
              name: '_RestorePasswordStore.canSubmit'))
          .value;

  final _$emailAtom = Atom(name: '_RestorePasswordStore.email');

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  final _$passwordAtom = Atom(name: '_RestorePasswordStore.password');

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

  final _$codeAtom = Atom(name: '_RestorePasswordStore.code');

  @override
  String get code {
    _$codeAtom.reportRead();
    return super.code;
  }

  @override
  set code(String value) {
    _$codeAtom.reportWrite(value, super.code, () {
      super.code = value;
    });
  }

  final _$requestCodeAsyncAction =
      AsyncAction('_RestorePasswordStore.requestCode');

  @override
  Future<dynamic> requestCode() {
    return _$requestCodeAsyncAction.run(() => super.requestCode());
  }

  final _$restorePasswordAsyncAction =
      AsyncAction('_RestorePasswordStore.restorePassword');

  @override
  Future<dynamic> restorePassword() {
    return _$restorePasswordAsyncAction.run(() => super.restorePassword());
  }

  final _$_RestorePasswordStoreActionController =
      ActionController(name: '_RestorePasswordStore');

  @override
  void setPassword(String value) {
    final _$actionInfo = _$_RestorePasswordStoreActionController.startAction(
        name: '_RestorePasswordStore.setPassword');
    try {
      return super.setPassword(value);
    } finally {
      _$_RestorePasswordStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEmail(String value) {
    final _$actionInfo = _$_RestorePasswordStoreActionController.startAction(
        name: '_RestorePasswordStore.setEmail');
    try {
      return super.setEmail(value);
    } finally {
      _$_RestorePasswordStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCode(String value) {
    final _$actionInfo = _$_RestorePasswordStoreActionController.startAction(
        name: '_RestorePasswordStore.setCode');
    try {
      return super.setCode(value);
    } finally {
      _$_RestorePasswordStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
email: ${email},
password: ${password},
code: ${code},
canSubmit: ${canSubmit}
    ''';
  }
}
