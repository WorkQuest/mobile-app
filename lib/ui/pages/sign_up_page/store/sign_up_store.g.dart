// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SignUpStore on _SignUpStore, Store {
  Computed<bool>? _$canSignUpComputed;

  @override
  bool get canSignUp => (_$canSignUpComputed ??=
          Computed<bool>(() => super.canSignUp, name: '_SignUpStore.canSignUp'))
      .value;

  final _$_emailAtom = Atom(name: '_SignUpStore._email');

  @override
  String get _email {
    _$_emailAtom.reportRead();
    return super._email;
  }

  @override
  set _email(String value) {
    _$_emailAtom.reportWrite(value, super._email, () {
      super._email = value;
    });
  }

  final _$_firstNameAtom = Atom(name: '_SignUpStore._firstName');

  @override
  String get _firstName {
    _$_firstNameAtom.reportRead();
    return super._firstName;
  }

  @override
  set _firstName(String value) {
    _$_firstNameAtom.reportWrite(value, super._firstName, () {
      super._firstName = value;
    });
  }

  final _$_lastNameAtom = Atom(name: '_SignUpStore._lastName');

  @override
  String get _lastName {
    _$_lastNameAtom.reportRead();
    return super._lastName;
  }

  @override
  set _lastName(String value) {
    _$_lastNameAtom.reportWrite(value, super._lastName, () {
      super._lastName = value;
    });
  }

  final _$_passwordAtom = Atom(name: '_SignUpStore._password');

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

  final _$registerAsyncAction = AsyncAction('_SignUpStore.register');

  @override
  Future<dynamic> register() {
    return _$registerAsyncAction.run(() => super.register());
  }

  final _$_SignUpStoreActionController = ActionController(name: '_SignUpStore');

  @override
  void setEmail(String value) {
    final _$actionInfo = _$_SignUpStoreActionController.startAction(
        name: '_SignUpStore.setEmail');
    try {
      return super.setEmail(value);
    } finally {
      _$_SignUpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFirstName(String value) {
    final _$actionInfo = _$_SignUpStoreActionController.startAction(
        name: '_SignUpStore.setFirstName');
    try {
      return super.setFirstName(value);
    } finally {
      _$_SignUpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLastName(String value) {
    final _$actionInfo = _$_SignUpStoreActionController.startAction(
        name: '_SignUpStore.setLastName');
    try {
      return super.setLastName(value);
    } finally {
      _$_SignUpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPassword(String value) {
    final _$actionInfo = _$_SignUpStoreActionController.startAction(
        name: '_SignUpStore.setPassword');
    try {
      return super.setPassword(value);
    } finally {
      _$_SignUpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
canSignUp: ${canSignUp}
    ''';
  }
}
