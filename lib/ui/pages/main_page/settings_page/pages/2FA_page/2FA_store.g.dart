// GENERATED CODE - DO NOT MODIFY BY HAND

part of '2FA_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TwoFAStore on _TwoFAStore, Store {
  Computed<bool>? _$canFinishComputed;

  @override
  bool get canFinish => (_$canFinishComputed ??=
          Computed<bool>(() => super.canFinish, name: '_TwoFAStore.canFinish'))
      .value;

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

  final _$googleAuthenticatorSecretCodeAtom =
      Atom(name: '_TwoFAStore.googleAuthenticatorSecretCode');

  @override
  String get googleAuthenticatorSecretCode {
    _$googleAuthenticatorSecretCodeAtom.reportRead();
    return super.googleAuthenticatorSecretCode;
  }

  @override
  set googleAuthenticatorSecretCode(String value) {
    _$googleAuthenticatorSecretCodeAtom
        .reportWrite(value, super.googleAuthenticatorSecretCode, () {
      super.googleAuthenticatorSecretCode = value;
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

  final _$enable2FAAsyncAction = AsyncAction('_TwoFAStore.enable2FA');

  @override
  Future<void> enable2FA() {
    return _$enable2FAAsyncAction.run(() => super.enable2FA());
  }

  final _$disable2FAAsyncAction = AsyncAction('_TwoFAStore.disable2FA');

  @override
  Future<dynamic> disable2FA() {
    return _$disable2FAAsyncAction.run(() => super.disable2FA());
  }

  final _$confirm2FAAsyncAction = AsyncAction('_TwoFAStore.confirm2FA');

  @override
  Future<dynamic> confirm2FA() {
    return _$confirm2FAAsyncAction.run(() => super.confirm2FA());
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
  void setCodeFromEmail(String value) {
    final _$actionInfo = _$_TwoFAStoreActionController.startAction(
        name: '_TwoFAStore.setCodeFromEmail');
    try {
      return super.setCodeFromEmail(value);
    } finally {
      _$_TwoFAStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
index: ${index},
googleAuthenticatorSecretCode: ${googleAuthenticatorSecretCode},
codeFromEmail: ${codeFromEmail},
codeFromAuthenticator: ${codeFromAuthenticator},
canFinish: ${canFinish}
    ''';
  }
}
