// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_quests_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MyQuestStore on _MyQuestStore, Store {
  final _$questListAtom = Atom(name: '_MyQuestStore.questList');

  @override
  List<BaseQuestResponse>? get questList {
    _$questListAtom.reportRead();
    return super.questList;
  }

  @override
  set questList(List<BaseQuestResponse>? value) {
    _$questListAtom.reportWrite(value, super.questList, () {
      super.questList = value;
    });
  }

  final _$searchWordAtom = Atom(name: '_MyQuestStore.searchWord');

  @override
  String? get searchWord {
    _$searchWordAtom.reportRead();
    return super.searchWord;
  }

  @override
  set searchWord(String? value) {
    _$searchWordAtom.reportWrite(value, super.searchWord, () {
      super.searchWord = value;
    });
  }

  final _$priorityAtom = Atom(name: '_MyQuestStore.priority');

  @override
  int get priority {
    _$priorityAtom.reportRead();
    return super.priority;
  }

  @override
  set priority(int value) {
    _$priorityAtom.reportWrite(value, super.priority, () {
      super.priority = value;
    });
  }

  final _$statusAtom = Atom(name: '_MyQuestStore.status');

  @override
  int get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(int value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  final _$listAsyncAction = AsyncAction('_MyQuestStore.list');

  @override
  Future<dynamic> list() {
    return _$listAsyncAction.run(() => super.list());
  }

  @override
  String toString() {
    return '''
questList: ${questList},
searchWord: ${searchWord},
priority: ${priority},
status: ${status}
    ''';
  }
}
