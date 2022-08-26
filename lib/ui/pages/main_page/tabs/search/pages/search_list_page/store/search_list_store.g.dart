// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_list_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SearchListStore on _SearchListStore, Store {
  Computed<bool>? _$emptySearchComputed;

  @override
  bool get emptySearch =>
      (_$emptySearchComputed ??= Computed<bool>(() => super.emptySearch,
              name: '_SearchListStore.emptySearch'))
          .value;

  final _$isLoadingMoreAtom = Atom(name: '_SearchListStore.isLoadingMore');

  @override
  bool get isLoadingMore {
    _$isLoadingMoreAtom.reportRead();
    return super.isLoadingMore;
  }

  @override
  set isLoadingMore(bool value) {
    _$isLoadingMoreAtom.reportWrite(value, super.isLoadingMore, () {
      super.isLoadingMore = value;
    });
  }

  final _$searchWordAtom = Atom(name: '_SearchListStore.searchWord');

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

  final _$questsListAtom = Atom(name: '_SearchListStore.questsList');

  @override
  ObservableList<BaseQuestResponse> get questsList {
    _$questsListAtom.reportRead();
    return super.questsList;
  }

  @override
  set questsList(ObservableList<BaseQuestResponse> value) {
    _$questsListAtom.reportWrite(value, super.questsList, () {
      super.questsList = value;
    });
  }

  final _$workersListAtom = Atom(name: '_SearchListStore.workersList');

  @override
  ObservableList<ProfileMeResponse> get workersList {
    _$workersListAtom.reportRead();
    return super.workersList;
  }

  @override
  set workersList(ObservableList<ProfileMeResponse> value) {
    _$workersListAtom.reportWrite(value, super.workersList, () {
      super.workersList = value;
    });
  }

  final _$_SearchListStoreActionController =
      ActionController(name: '_SearchListStore');

  @override
  dynamic search(
      {required UserRole role, String searchLine = '', bool isForce = true}) {
    final _$actionInfo = _$_SearchListStoreActionController.startAction(
        name: '_SearchListStore.search');
    try {
      return super.search(role: role, searchLine: searchLine, isForce: isForce);
    } finally {
      _$_SearchListStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setStar(String questId, bool star) {
    final _$actionInfo = _$_SearchListStoreActionController.startAction(
        name: '_SearchListStore.setStar');
    try {
      return super.setStar(questId, star);
    } finally {
      _$_SearchListStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic clearData() {
    final _$actionInfo = _$_SearchListStoreActionController.startAction(
        name: '_SearchListStore.clearData');
    try {
      return super.clearData();
    } finally {
      _$_SearchListStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoadingMore: ${isLoadingMore},
searchWord: ${searchWord},
questsList: ${questsList},
workersList: ${workersList},
emptySearch: ${emptySearch}
    ''';
  }
}
