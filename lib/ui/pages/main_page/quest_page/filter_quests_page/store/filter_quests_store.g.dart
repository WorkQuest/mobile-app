// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_quests_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FilterQuestsStore on FilterQuestsStoreBase, Store {
  final _$isLoadingAtom = Atom(name: 'FilterQuestsStoreBase.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$filtersAtom = Atom(name: 'FilterQuestsStoreBase.filters');

  @override
  List<FilterItem> get filters {
    _$filtersAtom.reportRead();
    return super.filters;
  }

  @override
  set filters(List<FilterItem> value) {
    _$filtersAtom.reportWrite(value, super.filters, () {
      super.filters = value;
    });
  }

  final _$sortByAtom = Atom(name: 'FilterQuestsStoreBase.sortBy');

  @override
  List<String> get sortBy {
    _$sortByAtom.reportRead();
    return super.sortBy;
  }

  @override
  set sortBy(List<String> value) {
    _$sortByAtom.reportWrite(value, super.sortBy, () {
      super.sortBy = value;
    });
  }

  final _$selectSortByAtom = Atom(name: 'FilterQuestsStoreBase.selectSortBy');

  @override
  String get selectSortBy {
    _$selectSortByAtom.reportRead();
    return super.selectSortBy;
  }

  @override
  set selectSortBy(String value) {
    _$selectSortByAtom.reportWrite(value, super.selectSortBy, () {
      super.selectSortBy = value;
    });
  }

  final _$sortByQuestAtom = Atom(name: 'FilterQuestsStoreBase.sortByQuest');

  @override
  List<String> get sortByQuest {
    _$sortByQuestAtom.reportRead();
    return super.sortByQuest;
  }

  @override
  set sortByQuest(List<String> value) {
    _$sortByQuestAtom.reportWrite(value, super.sortByQuest, () {
      super.sortByQuest = value;
    });
  }

  final _$selectQuestAtom = Atom(name: 'FilterQuestsStoreBase.selectQuest');

  @override
  ObservableList<bool> get selectQuest {
    _$selectQuestAtom.reportRead();
    return super.selectQuest;
  }

  @override
  set selectQuest(ObservableList<bool> value) {
    _$selectQuestAtom.reportWrite(value, super.selectQuest, () {
      super.selectQuest = value;
    });
  }

  final _$sortByQuestDeliveryAtom =
      Atom(name: 'FilterQuestsStoreBase.sortByQuestDelivery');

  @override
  List<String> get sortByQuestDelivery {
    _$sortByQuestDeliveryAtom.reportRead();
    return super.sortByQuestDelivery;
  }

  @override
  set sortByQuestDelivery(List<String> value) {
    _$sortByQuestDeliveryAtom.reportWrite(value, super.sortByQuestDelivery, () {
      super.sortByQuestDelivery = value;
    });
  }

  final _$selectQuestDeliveryAtom =
      Atom(name: 'FilterQuestsStoreBase.selectQuestDelivery');

  @override
  ObservableList<bool> get selectQuestDelivery {
    _$selectQuestDeliveryAtom.reportRead();
    return super.selectQuestDelivery;
  }

  @override
  set selectQuestDelivery(ObservableList<bool> value) {
    _$selectQuestDeliveryAtom.reportWrite(value, super.selectQuestDelivery, () {
      super.selectQuestDelivery = value;
    });
  }

  final _$sortByEmploymentAtom =
      Atom(name: 'FilterQuestsStoreBase.sortByEmployment');

  @override
  ObservableList<String> get sortByEmployment {
    _$sortByEmploymentAtom.reportRead();
    return super.sortByEmployment;
  }

  @override
  set sortByEmployment(ObservableList<String> value) {
    _$sortByEmploymentAtom.reportWrite(value, super.sortByEmployment, () {
      super.sortByEmployment = value;
    });
  }

  final _$selectEmploymentAtom =
      Atom(name: 'FilterQuestsStoreBase.selectEmployment');

  @override
  ObservableList<bool> get selectEmployment {
    _$selectEmploymentAtom.reportRead();
    return super.selectEmployment;
  }

  @override
  set selectEmployment(ObservableList<bool> value) {
    _$selectEmploymentAtom.reportWrite(value, super.selectEmployment, () {
      super.selectEmployment = value;
    });
  }

  final _$readFiltersAsyncAction =
      AsyncAction('FilterQuestsStoreBase.readFilters');

  @override
  Future<dynamic> readFilters() {
    return _$readFiltersAsyncAction.run(() => super.readFilters());
  }

  final _$FilterQuestsStoreBaseActionController =
      ActionController(name: 'FilterQuestsStoreBase');

  @override
  void setSelectedQuest(bool? value, int index) {
    final _$actionInfo = _$FilterQuestsStoreBaseActionController.startAction(
        name: 'FilterQuestsStoreBase.setSelectedQuest');
    try {
      return super.setSelectedQuest(value, index);
    } finally {
      _$FilterQuestsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedQuestDelivery(bool? value, int index) {
    final _$actionInfo = _$FilterQuestsStoreBaseActionController.startAction(
        name: 'FilterQuestsStoreBase.setSelectedQuestDelivery');
    try {
      return super.setSelectedQuestDelivery(value, index);
    } finally {
      _$FilterQuestsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedEmployment(bool? value, int index) {
    final _$actionInfo = _$FilterQuestsStoreBaseActionController.startAction(
        name: 'FilterQuestsStoreBase.setSelectedEmployment');
    try {
      return super.setSelectedEmployment(value, index);
    } finally {
      _$FilterQuestsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSortBy(String? index) {
    final _$actionInfo = _$FilterQuestsStoreBaseActionController.startAction(
        name: 'FilterQuestsStoreBase.setSortBy');
    try {
      return super.setSortBy(index);
    } finally {
      _$FilterQuestsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
filters: ${filters},
sortBy: ${sortBy},
selectSortBy: ${selectSortBy},
sortByQuest: ${sortByQuest},
selectQuest: ${selectQuest},
sortByQuestDelivery: ${sortByQuestDelivery},
selectQuestDelivery: ${selectQuestDelivery},
sortByEmployment: ${sortByEmployment},
selectEmployment: ${selectEmployment}
    ''';
  }
}
