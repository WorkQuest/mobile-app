// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quests_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$QuestsStore on _QuestsStore, Store {
  final _$searchWordAtom = Atom(name: '_QuestsStore.searchWord');

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

  final _$sortAtom = Atom(name: '_QuestsStore.sort');

  @override
  String? get sort {
    _$sortAtom.reportRead();
    return super.sort;
  }

  @override
  set sort(String? value) {
    _$sortAtom.reportWrite(value, super.sort, () {
      super.sort = value;
    });
  }

  final _$priorityAtom = Atom(name: '_QuestsStore.priority');

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

  final _$offsetAtom = Atom(name: '_QuestsStore.offset');

  @override
  int get offset {
    _$offsetAtom.reportRead();
    return super.offset;
  }

  @override
  set offset(int value) {
    _$offsetAtom.reportWrite(value, super.offset, () {
      super.offset = value;
    });
  }

  final _$limitAtom = Atom(name: '_QuestsStore.limit');

  @override
  int get limit {
    _$limitAtom.reportRead();
    return super.limit;
  }

  @override
  set limit(int value) {
    _$limitAtom.reportWrite(value, super.limit, () {
      super.limit = value;
    });
  }

  final _$statusAtom = Atom(name: '_QuestsStore.status');

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

  final _$questsListAtom = Atom(name: '_QuestsStore.questsList');

  @override
  List<BaseQuestResponse>? get questsList {
    _$questsListAtom.reportRead();
    return super.questsList;
  }

  @override
  set questsList(List<BaseQuestResponse>? value) {
    _$questsListAtom.reportWrite(value, super.questsList, () {
      super.questsList = value;
    });
  }

  final _$starredQuestsListAtom = Atom(name: '_QuestsStore.starredQuestsList');

  @override
  List<BaseQuestResponse>? get starredQuestsList {
    _$starredQuestsListAtom.reportRead();
    return super.starredQuestsList;
  }

  @override
  set starredQuestsList(List<BaseQuestResponse>? value) {
    _$starredQuestsListAtom.reportWrite(value, super.starredQuestsList, () {
      super.starredQuestsList = value;
    });
  }

  final _$performingQuestsListAtom =
      Atom(name: '_QuestsStore.performingQuestsList');

  @override
  List<BaseQuestResponse>? get performedQuestsList {
    _$performingQuestsListAtom.reportRead();
    return super.performedQuestsList;
  }

  @override
  set performedQuestsList(List<BaseQuestResponse>? value) {
    _$performingQuestsListAtom.reportWrite(value, super.performedQuestsList,
        () {
      super.performedQuestsList = value;
    });
  }

  final _$invitedQuestsListAtom = Atom(name: '_QuestsStore.invitedQuestsList');

  @override
  List<BaseQuestResponse>? get invitedQuestsList {
    _$invitedQuestsListAtom.reportRead();
    return super.invitedQuestsList;
  }

  @override
  set invitedQuestsList(List<BaseQuestResponse>? value) {
    _$invitedQuestsListAtom.reportWrite(value, super.invitedQuestsList, () {
      super.invitedQuestsList = value;
    });
  }

  final _$mapListCheckerAtom = Atom(name: '_QuestsStore.mapListChecker');

  @override
  _MapList get mapListChecker {
    _$mapListCheckerAtom.reportRead();
    return super.mapListChecker;
  }

  @override
  set mapListChecker(_MapList value) {
    _$mapListCheckerAtom.reportWrite(value, super.mapListChecker, () {
      super.mapListChecker = value;
    });
  }

  final _$getQuestsAsyncAction = AsyncAction('_QuestsStore.getQuests');

  @override
  Future<dynamic> getQuests() {
    return _$getQuestsAsyncAction.run(() => super.getQuests());
  }

  final _$_QuestsStoreActionController = ActionController(name: '_QuestsStore');

  @override
  dynamic changeValue() {
    final _$actionInfo = _$_QuestsStoreActionController.startAction(
        name: '_QuestsStore.changeValue');
    try {
      return super.changeValue();
    } finally {
      _$_QuestsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic isMapOpened() {
    final _$actionInfo = _$_QuestsStoreActionController.startAction(
        name: '_QuestsStore.isMapOpened');
    try {
      return super.isMapOpened();
    } finally {
      _$_QuestsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
searchWord: ${searchWord},
sort: ${sort},
priority: ${priority},
offset: ${offset},
limit: ${limit},
status: ${status},
questsList: ${questsList},
starredQuestsList: ${starredQuestsList},
performingQuestsList: ${performedQuestsList},
invitedQuestsList: ${invitedQuestsList},
mapListChecker: ${mapListChecker}
    ''';
  }
}
