// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_verification_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SMSVerificationStore on _SMSVerificationStore, Store {
  final _$indexAtom = Atom(name: '_SMSVerificationStore.index');

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

  final _$validateAtom = Atom(name: '_SMSVerificationStore.validate');

  @override
  bool get validate {
    _$validateAtom.reportRead();
    return super.validate;
  }

  @override
  set validate(bool value) {
    _$validateAtom.reportWrite(value, super.validate, () {
      super.validate = value;
    });
  }

  final _$phoneAtom = Atom(name: '_SMSVerificationStore.phone');

  @override
  String get phone {
    _$phoneAtom.reportRead();
    return super.phone;
  }

  @override
  set phone(String value) {
    _$phoneAtom.reportWrite(value, super.phone, () {
      super.phone = value;
    });
  }

  final _$codeAtom = Atom(name: '_SMSVerificationStore.code');

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

  final _$submitPhoneNumberAsyncAction =
      AsyncAction('_SMSVerificationStore.submitPhoneNumber');

  @override
  Future<dynamic> submitPhoneNumber() {
    return _$submitPhoneNumberAsyncAction.run(() => super.submitPhoneNumber());
  }

  final _$submitCodeAsyncAction =
      AsyncAction('_SMSVerificationStore.submitCode');

  @override
  Future<dynamic> submitCode() {
    return _$submitCodeAsyncAction.run(() => super.submitCode());
  }

  final _$_SMSVerificationStoreActionController =
      ActionController(name: '_SMSVerificationStore');

  @override
  void setPhone(String value) {
    final _$actionInfo = _$_SMSVerificationStoreActionController.startAction(
        name: '_SMSVerificationStore.setPhone');
    try {
      return super.setPhone(value);
    } finally {
      _$_SMSVerificationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCode(String value) {
    final _$actionInfo = _$_SMSVerificationStoreActionController.startAction(
        name: '_SMSVerificationStore.setCode');
    try {
      return super.setCode(value);
    } finally {
      _$_SMSVerificationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
index: ${index},
validate: ${validate},
phone: ${phone},
code: ${code}
    ''';
  }
}
