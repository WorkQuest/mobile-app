// GENERATED CODE - DO NOT MODIFY BY HAND

part of '2FA_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TwoFAStore on _TwoFAStore, Store {
  final _$indexAtom = Atom(name: '_TwoFAStore.index');

  @override
  int get index {
    _$indexAtom.reportRead();
    return super.index;
  }

  @override
  set index(int value) {
    _$indexAtom.reportWrite(value, super.index, () {
      super.index = value;
    });
  }

  final _$codeFromEmailAtom = Atom(name: '_TwoFAStore.codeFromEmail');

  @override
  String get codeFromEmail {
    _$codeFromEmailAtom.reportRead();
    return super.codeFromEmail;
  }

  @override
  set codeFromEmail(String value) {
    _$codeFromEmailAtom.reportWrite(value, super.codeFromEmail, () {
      super.codeFromEmail = value;
    });
  }

  final _$codeFromAuthenticatorAtom =
      Atom(name: '_TwoFAStore.codeFromAuthenticator');

  @override
  String get codeFromAuthenticator {
    _$codeFromAuthenticatorAtom.reportRead();
    return super.codeFromAuthenticator;
  }

  @override
  set codeFromAuthenticator(String value) {
    _$codeFromAuthenticatorAtom.reportWrite(value, super.codeFromAuthenticator,
        () {
      super.codeFromAuthenticator = value;
    });
  }

  final _$_TwoFAStoreActionController = ActionController(name: '_TwoFAStore');

  @override
  void setCodeFromAuthenticator(String value) {
    final _$actionInfo = _$_TwoFAStoreActionController.startAction(
        name: '_TwoFAStore.setCodeFromAuthenticator');
    try {
      return super.setCodeFromAuthenticator(value);
    } finally {
      _$_TwoFAStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCode(String value) {
    final _$actionInfo =
        _$_TwoFAStoreActionController.startAction(name: '_TwoFAStore.setCode');
    try {
      return super.setCode(value);
    } finally {
      _$_TwoFAStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
index: ${index},
codeFromEmail: ${codeFromEmail},
codeFromAuthenticator: ${codeFromAuthenticator}
    ''';
  }
}