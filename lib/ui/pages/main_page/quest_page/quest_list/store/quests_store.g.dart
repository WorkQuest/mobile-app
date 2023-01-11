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

  final _$offsetWorkersAtom = Atom(name: '_QuestsStore.offsetWorkers');

  @override
  int get offsetWorkers {
    _$offsetWorkersAtom.reportRead();
    return super.offsetWorkers;
  }

  @override
  set offsetWorkers(int value) {
    _$offsetWorkersAtom.reportWrite(value, super.offsetWorkers, () {
      super.offsetWorkers = value;
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

  final _$searchResultListAtom = Atom(name: '_QuestsStore.searchResultList');

  @override
  ObservableList<BaseQuestResponse> get searchResultList {
    _$searchResultListAtom.reportRead();
    return super.searchResultList;
  }

  @override
  set searchResultList(ObservableList<BaseQuestResponse> value) {
    _$searchResultListAtom.reportWrite(value, super.searchResultList, () {
      super.searchResultList = value;
    });
  }

  final _$searchWorkersListAtom = Atom(name: '_QuestsStore.searchWorkersList');

  @override
  ObservableList<ProfileMeResponse> get searchWorkersList {
    _$searchWorkersListAtom.reportRead();
    return super.searchWorkersList;
  }

  @override
  set searchWorkersList(ObservableList<ProfileMeResponse> value) {
    _$searchWorkersListAtom.reportWrite(value, super.searchWorkersList, () {
      super.searchWorkersList = value;
    });
  }

  final _$loadQuestsListAtom = Atom(name: '_QuestsStore.loadQuestsList');

  @override
  ObservableList<BaseQuestResponse> get loadQuestsList {
    _$loadQuestsListAtom.reportRead();
    return super.loadQuestsList;
  }

  @override
  set loadQuestsList(ObservableList<BaseQuestResponse> value) {
    _$loadQuestsListAtom.reportWrite(value, super.loadQuestsList, () {
      super.loadQuestsList = value;
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

  final _$getPredictionAsyncAction = AsyncAction('_QuestsStore.getPrediction');

  @override
  Future<Null> getPrediction(BuildContext context, UserRole role) {
    return _$getPredictionAsyncAction
        .run(() => super.getPrediction(context, role));
  }

  final _$displayPredictionAsyncAction =
      AsyncAction('_QuestsStore.displayPrediction');

  @override
  Future<Null> displayPrediction(String? p) {
    return _$displayPredictionAsyncAction.run(() => super.displayPrediction(p));
  }

  final _$getSearchedQuestsAsyncAction =
      AsyncAction('_QuestsStore.getSearchedQuests');

  @override
  Future<dynamic> getSearchedQuests() {
    return _$getSearchedQuestsAsyncAction.run(() => super.getSearchedQuests());
  }

  final _$getSearchedWorkersAsyncAction =
      AsyncAction('_QuestsStore.getSearchedWorkers');

  @override
  Future<dynamic> getSearchedWorkers() {
    return _$getSearchedWorkersAsyncAction
        .run(() => super.getSearchedWorkers());
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
  String toString() {
    return '''
searchWord: ${searchWord},
sort: ${sort},
fromPrice: ${fromPrice},
toPrice: ${toPrice},
offset: ${offset},
offsetWorkers: ${offsetWorkers},
limit: ${limit},
status: ${status},
questsList: ${questsList},
workersList: ${workersList},
searchResultList: ${searchResultList},
searchWorkersList: ${searchWorkersList},
loadQuestsList: ${loadQuestsList},
latitude: ${latitude},
longitude: ${longitude},
locationPlaceName: ${locationPlaceName},
emptySearch: ${emptySearch}
    ''';
  }
}
