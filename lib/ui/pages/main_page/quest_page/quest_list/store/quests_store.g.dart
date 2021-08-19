// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quests_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$QuestsStore on _QuestsStore, Store {
  Computed<bool>? _$emptySearchComputed;

  @override
  bool get emptySearch =>
      (_$emptySearchComputed ??= Computed<bool>(() => super.emptySearch,
              name: '_QuestsStore.emptySearch'))
          .value;

  final _$searchWordAtom = Atom(name: '_QuestsStore.searchWord');

  @override
  String get searchWord {
    _$searchWordAtom.reportRead();
    return super.searchWord;
  }

  @override
  set searchWord(String value) {
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

  final _$searchResultListAtom = Atom(name: '_QuestsStore.searchResultList');

  @override
  List<BaseQuestResponse>? get searchResultList {
    _$searchResultListAtom.reportRead();
    return super.searchResultList;
  }

  @override
  set searchResultList(List<BaseQuestResponse>? value) {
    _$searchResultListAtom.reportWrite(value, super.searchResultList, () {
      super.searchResultList = value;
    });
  }

  final _$getSearchedQuestsAsyncAction =
      AsyncAction('_QuestsStore.getSearchedQuests');

  @override
  Future<dynamic> getSearchedQuests() {
    return _$getSearchedQuestsAsyncAction.run(() => super.getSearchedQuests());
  }

  final _$getQuestsAsyncAction = AsyncAction('_QuestsStore.getQuests');

  @override
  Future<dynamic> getQuests(String userId) {
    return _$getQuestsAsyncAction.run(() => super.getQuests(userId));
  }

  final _$_QuestsStoreActionController = ActionController(name: '_QuestsStore');

  @override
  void setSearchWord(String value) {
    final _$actionInfo = _$_QuestsStoreActionController.startAction(
        name: '_QuestsStore.setSearchWord');
    try {
      return super.setSearchWord(value);
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
searchResultList: ${searchResultList},
emptySearch: ${emptySearch}
    ''';
  }
}