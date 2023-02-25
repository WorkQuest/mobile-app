// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employer_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$EmployerStore on _EmployerStore, Store {
  final _$respondedListAtom = Atom(name: '_EmployerStore.respondedList');

  @override
  List<RespondModel> get respondedList {
    _$respondedListAtom.reportRead();
    return super.respondedList;
  }

  @override
  set respondedList(List<RespondModel> value) {
    _$respondedListAtom.reportWrite(value, super.respondedList, () {
      super.respondedList = value;
    });
  }

  final _$selectedRespondersAtom =
      Atom(name: '_EmployerStore.selectedResponders');

  @override
  RespondModel? get selectedResponders {
    _$selectedRespondersAtom.reportRead();
    return super.selectedResponders;
  }

  @override
  set selectedResponders(RespondModel? value) {
    _$selectedRespondersAtom.reportWrite(value, super.selectedResponders, () {
      super.selectedResponders = value;
    });
  }

  final _$isValidAtom = Atom(name: '_EmployerStore.isValid');

  @override
  bool get isValid {
    _$isValidAtom.reportRead();
    return super.isValid;
  }

  @override
  set isValid(bool value) {
    _$isValidAtom.reportWrite(value, super.isValid, () {
      super.isValid = value;
    });
  }

  final _$totpAtom = Atom(name: '_EmployerStore.totp');

  @override
  String get totp {
    _$totpAtom.reportRead();
    return super.totp;
  }

  @override
  set totp(String value) {
    _$totpAtom.reportWrite(value, super.totp, () {
      super.totp = value;
    });
  }

  final _$getRespondedListAsyncAction =
      AsyncAction('_EmployerStore.getRespondedList');

  @override
  Future getRespondedList(String id, String idWorker) {
    return _$getRespondedListAsyncAction
        .run(() => super.getRespondedList(id, idWorker));
  }

  final _$startQuestAsyncAction = AsyncAction('_EmployerStore.startQuest');

  @override
  Future startQuest({required String questId, required String userId}) {
    return _$startQuestAsyncAction
        .run(() => super.startQuest(questId: questId, userId: userId));
  }

  final _$acceptCompletedWorkAsyncAction =
      AsyncAction('_EmployerStore.acceptCompletedWork');

  @override
  Future acceptCompletedWork({required String questId}) {
    return _$acceptCompletedWorkAsyncAction
        .run(() => super.acceptCompletedWork(questId: questId));
  }

  final _$deleteQuestAsyncAction = AsyncAction('_EmployerStore.deleteQuest');

  @override
  Future deleteQuest({required String questId}) {
    return _$deleteQuestAsyncAction
        .run(() => super.deleteQuest(questId: questId));
  }

  final _$validateTotpAsyncAction = AsyncAction('_EmployerStore.validateTotp');

  @override
  Future<void> validateTotp() {
    return _$validateTotpAsyncAction.run(() => super.validateTotp());
  }

  final _$_EmployerStoreActionController =
      ActionController(name: '_EmployerStore');

  @override
  dynamic setTotp(String value) {
    final _$actionInfo = _$_EmployerStoreActionController.startAction(
        name: '_EmployerStore.setTotp');
    try {
      return super.setTotp(value);
    } finally {
      _$_EmployerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeQuest(dynamic json) {
    final _$actionInfo = _$_EmployerStoreActionController.startAction(
        name: '_EmployerStore.changeQuest');
    try {
      return super.changeQuest(json);
    } finally {
      _$_EmployerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
respondedList: ${respondedList},
selectedResponders: ${selectedResponders},
isValid: ${isValid},
totp: ${totp}
    ''';
  }
}
