// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SignInStore on _SignInStore, Store {
  Computed<bool>? _$canSignInComputed;

  @override
  bool get canSignIn => (_$canSignInComputed ??=
          Computed<bool>(() => super.canSignIn, name: '_SignInStore.canSignIn'))
      .value;

  final _$_usernameAtom = Atom(name: '_SignInStore._username');

  @override
  String get _username {
    _$_usernameAtom.reportRead();
    return super._username;
  }

  @override
  set _username(String value) {
    _$_usernameAtom.reportWrite(value, super._username, () {
      super._username = value;
    });
  }

  final _$_passwordAtom = Atom(name: '_SignInStore._password');

  @override
  String get _password {
    _$_passwordAtom.reportRead();
    return super._password;
  }

  @override
  set _password(String value) {
    _$_passwordAtom.reportWrite(value, super._password, () {
      super._password = value;
    });
  }

  final _$signInWithUsernameAsyncAction =
      AsyncAction('_SignInStore.signInWithUsername');

  @override
  Future<dynamic> signInWithUsername() {
    return _$signInWithUsernameAsyncAction
        .run(() => super.signInWithUsername());
  }

  final _$_SignInStoreActionController = ActionController(name: '_SignInStore');

  @override
  void setUsername(String value) {
    final _$actionInfo = _$_SignInStoreActionController.startAction(
        name: '_SignInStore.setUsername');
    try {
      return super.setUsername(value);
    } finally {
      _$_SignInStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String getUsername() {
    final _$actionInfo = _$_SignInStoreActionController.startAction(
        name: '_SignInStore.getUsername');
    try {
      return super.getUsername();
    } finally {
      _$_SignInStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPassword(String value) {
    final _$actionInfo = _$_SignInStoreActionController.startAction(
        name: '_SignInStore.setPassword');
    try {
      return super.setPassword(value);
    } finally {
      _$_SignInStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
canSignIn: ${canSignIn}
    ''';
  }
}
