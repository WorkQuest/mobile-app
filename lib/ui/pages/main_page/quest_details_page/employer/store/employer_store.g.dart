// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employer_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$EmployerStore on _EmployerStore, Store {
  final _$respondedListAtom = Atom(name: '_EmployerStore.respondedList');

  @override
  List<RespondModel>? get respondedList {
    _$respondedListAtom.reportRead();
    return super.respondedList;
  }

  @override
  set respondedList(List<RespondModel>? value) {
    _$respondedListAtom.reportWrite(value, super.respondedList, () {
      super.respondedList = value;
    });
  }

  final _$selectedRespondersAtom =
      Atom(name: '_EmployerStore.selectedResponders');

  @override
  String get selectedResponders {
    _$selectedRespondersAtom.reportRead();
    return super.selectedResponders;
  }

  @override
  set selectedResponders(String value) {
    _$selectedRespondersAtom.reportWrite(value, super.selectedResponders, () {
      super.selectedResponders = value;
    });
  }

  final _$getRespondedListAsyncAction =
      AsyncAction('_EmployerStore.getRespondedList');

  @override
  Future getRespondedList(String id) {
    return _$getRespondedListAsyncAction.run(() => super.getRespondedList(id));
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

  final _$rejectCompletedWorkAsyncAction =
      AsyncAction('_EmployerStore.rejectCompletedWork');

  @override
  Future rejectCompletedWork({required String questId}) {
    return _$rejectCompletedWorkAsyncAction
        .run(() => super.rejectCompletedWork(questId: questId));
  }

  final _$deleteQuestAsyncAction = AsyncAction('_EmployerStore.deleteQuest');

  @override
  Future deleteQuest({required String questId}) {
    return _$deleteQuestAsyncAction
        .run(() => super.deleteQuest(questId: questId));
  }

  @override
  String toString() {
    return '''
respondedList: ${respondedList},
selectedResponders: ${selectedResponders}
    ''';
  }
}
