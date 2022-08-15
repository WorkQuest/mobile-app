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

  final _$isLoadingMoreAtom = Atom(name: '_QuestsStore.isLoadingMore');

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
  String get sort {
    _$sortAtom.reportRead();
    return super.sort;
  }

  @override
  set sort(String value) {
    _$sortAtom.reportWrite(value, super.sort, () {
      super.sort = value;
    });
  }

  final _$fromPriceAtom = Atom(name: '_QuestsStore.fromPrice');

  @override
  String get fromPrice {
    _$fromPriceAtom.reportRead();
    return super.fromPrice;
  }

  @override
  set fromPrice(String value) {
    _$fromPriceAtom.reportWrite(value, super.fromPrice, () {
      super.fromPrice = value;
    });
  }

  final _$toPriceAtom = Atom(name: '_QuestsStore.toPrice');

  @override
  String get toPrice {
    _$toPriceAtom.reportRead();
    return super.toPrice;
  }

  @override
  set toPrice(String value) {
    _$toPriceAtom.reportWrite(value, super.toPrice, () {
      super.toPrice = value;
    });
  }

  final _$questsListAtom = Atom(name: '_QuestsStore.questsList');

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

  final _$workersListAtom = Atom(name: '_QuestsStore.workersList');

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

  final _$latitudeAtom = Atom(name: '_QuestsStore.latitude');

  @override
  double? get latitude {
    _$latitudeAtom.reportRead();
    return super.latitude;
  }

  @override
  set latitude(double? value) {
    _$latitudeAtom.reportWrite(value, super.latitude, () {
      super.latitude = value;
    });
  }

  final _$longitudeAtom = Atom(name: '_QuestsStore.longitude');

  @override
  double? get longitude {
    _$longitudeAtom.reportRead();
    return super.longitude;
  }

  @override
  set longitude(double? value) {
    _$longitudeAtom.reportWrite(value, super.longitude, () {
      super.longitude = value;
    });
  }

  final _$locationPlaceNameAtom = Atom(name: '_QuestsStore.locationPlaceName');

  @override
  String get locationPlaceName {
    _$locationPlaceNameAtom.reportRead();
    return super.locationPlaceName;
  }

  @override
  set locationPlaceName(String value) {
    _$locationPlaceNameAtom.reportWrite(value, super.locationPlaceName, () {
      super.locationPlaceName = value;
    });
  }

  final _$getSearchedQuestsAsyncAction =
      AsyncAction('_QuestsStore.getSearchedQuests');

  @override
  Future<dynamic> getSearchedQuests(bool newList) {
    return _$getSearchedQuestsAsyncAction
        .run(() => super.getSearchedQuests(newList));
  }

  final _$getSearchedWorkersAsyncAction =
      AsyncAction('_QuestsStore.getSearchedWorkers');

  @override
  Future<dynamic> getSearchedWorkers(bool newList) {
    return _$getSearchedWorkersAsyncAction
        .run(() => super.getSearchedWorkers(newList));
  }

  final _$getQuestsAsyncAction = AsyncAction('_QuestsStore.getQuests');

  @override
  Future<dynamic> getQuests(bool newList) {
    return _$getQuestsAsyncAction.run(() => super.getQuests(newList));
  }

  final _$getWorkersAsyncAction = AsyncAction('_QuestsStore.getWorkers');

  @override
  Future<dynamic> getWorkers(bool newList) {
    return _$getWorkersAsyncAction.run(() => super.getWorkers(newList));
  }

  final _$_QuestsStoreActionController = ActionController(name: '_QuestsStore');

  @override
  void setPrice(String from, String to) {
    final _$actionInfo = _$_QuestsStoreActionController.startAction(
        name: '_QuestsStore.setPrice');
    try {
      return super.setPrice(from, to);
    } finally {
      _$_QuestsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  List<String> parser(List<String> skills) {
    final _$actionInfo =
        _$_QuestsStoreActionController.startAction(name: '_QuestsStore.parser');
    try {
      return super.parser(skills);
    } finally {
      _$_QuestsStoreActionController.endAction(_$actionInfo);
    }
  }

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
  dynamic setStar(String questId, bool star) {
    final _$actionInfo = _$_QuestsStoreActionController.startAction(
        name: '_QuestsStore.setStar');
    try {
      return super.setStar(questId, star);
    } finally {
      _$_QuestsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic clearData() {
    final _$actionInfo = _$_QuestsStoreActionController.startAction(
        name: '_QuestsStore.clearData');
    try {
      return super.clearData();
    } finally {
      _$_QuestsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoadingMore: ${isLoadingMore},
searchWord: ${searchWord},
sort: ${sort},
fromPrice: ${fromPrice},
toPrice: ${toPrice},
questsList: ${questsList},
workersList: ${workersList},
latitude: ${latitude},
longitude: ${longitude},
locationPlaceName: ${locationPlaceName},
emptySearch: ${emptySearch}
    ''';
  }
}
