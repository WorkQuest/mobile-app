// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_verification_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SMSVerificationStore on _SMSVerificationStore, Store {
  Computed<bool>? _$canSubmitCodeComputed;

  @override
  bool get canSubmitCode =>
      (_$canSubmitCodeComputed ??= Computed<bool>(() => super.canSubmitCode,
              name: '_SMSVerificationStore.canSubmitCode'))
          .value;

  final _$timerAtom = Atom(name: '_SMSVerificationStore.timer');

  @override
  Timer? get timer {
    _$timerAtom.reportRead();
    return super.timer;
  }

  @override
  set timer(Timer? value) {
    _$timerAtom.reportWrite(value, super.timer, () {
      super.timer = value;
    });
  }

  final _$secondsCodeAgainAtom =
      Atom(name: '_SMSVerificationStore.secondsCodeAgain');

  @override
  int get secondsCodeAgain {
    _$secondsCodeAgainAtom.reportRead();
    return super.secondsCodeAgain;
  }

  @override
  set secondsCodeAgain(int value) {
    _$secondsCodeAgainAtom.reportWrite(value, super.secondsCodeAgain, () {
      super.secondsCodeAgain = value;
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

  final _$startTimerAsyncAction =
      AsyncAction('_SMSVerificationStore.startTimer');

  @override
  Future startTimer() {
    return _$startTimerAsyncAction.run(() => super.startTimer());
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
  dynamic setCode(String? value) {
    final _$actionInfo = _$_SMSVerificationStoreActionController.startAction(
        name: '_SMSVerificationStore.setCode');
    try {
      return super.setCode(value);
    } finally {
      _$_SMSVerificationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic stopTimer() {
    final _$actionInfo = _$_SMSVerificationStoreActionController.startAction(
        name: '_SMSVerificationStore.stopTimer');
    try {
      return super.stopTimer();
    } finally {
      _$_SMSVerificationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
timer: ${timer},
secondsCodeAgain: ${secondsCodeAgain},
code: ${code},
canSubmitCode: ${canSubmitCode}
    ''';
  }
}
