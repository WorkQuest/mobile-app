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

  @override
  String toString() {
    return '''
respondedList: ${respondedList},
selectedResponders: ${selectedResponders}
    ''';
  }
}
