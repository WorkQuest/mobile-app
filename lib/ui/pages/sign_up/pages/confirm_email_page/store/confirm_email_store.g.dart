// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirm_email_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ConfirmEmailStore on _ConfirmEmailStore, Store {
  Computed<bool>? _$canSubmitCodeComputed;

  @override
  bool get canSubmitCode =>
      (_$canSubmitCodeComputed ??= Computed<bool>(() => super.canSubmitCode,
              name: '_ConfirmEmailStore.canSubmitCode'))
          .value;

  final _$_codeFromEmailAtom = Atom(name: '_ConfirmEmailStore._codeFromEmail');

  @override
  String get _codeFromEmail {
    _$_codeFromEmailAtom.reportRead();
    return super._codeFromEmail;
  }

  @override
  set _codeFromEmail(String value) {
    _$_codeFromEmailAtom.reportWrite(value, super._codeFromEmail, () {
      super._codeFromEmail = value;
    });
  }

  final _$secondsCodeAgainAtom =
      Atom(name: '_ConfirmEmailStore.secondsCodeAgain');

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

  final _$confirmEmailAsyncAction =
      AsyncAction('_ConfirmEmailStore.confirmEmail');

  @override
  Future confirmEmail() {
    return _$confirmEmailAsyncAction.run(() => super.confirmEmail());
  }

  final _$startTimerAsyncAction = AsyncAction('_ConfirmEmailStore.startTimer');

  @override
  Future startTimer(String email) {
    return _$startTimerAsyncAction.run(() => super.startTimer(email));
  }

  final _$_ConfirmEmailStoreActionController =
      ActionController(name: '_ConfirmEmailStore');

  @override
  void setCode(String value) {
    final _$actionInfo = _$_ConfirmEmailStoreActionController.startAction(
        name: '_ConfirmEmailStore.setCode');
    try {
      return super.setCode(value);
    } finally {
      _$_ConfirmEmailStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
secondsCodeAgain: ${secondsCodeAgain},
canSubmitCode: ${canSubmitCode}
    ''';
  }
}
