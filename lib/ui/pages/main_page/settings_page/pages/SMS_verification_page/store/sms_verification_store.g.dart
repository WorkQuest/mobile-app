// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_verification_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SMSVerificationStore on _SMSVerificationStore, Store {
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

  final _$submitCodeAsyncAction =
      AsyncAction('_SMSVerificationStore.submitCode');

  @override
  Future<dynamic> submitCode() {
    return _$submitCodeAsyncAction.run(() => super.submitCode());
  }

  final _$_SMSVerificationStoreActionController =
      ActionController(name: '_SMSVerificationStore');

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
code: ${code}
    ''';
  }
}
