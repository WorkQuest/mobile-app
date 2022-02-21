// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_quests_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FilterQuestsStore on FilterQuestsStoreBase, Store {
  Computed<bool>? _$allSelectedComputed;

  @override
  bool get allSelected =>
      (_$allSelectedComputed ??= Computed<bool>(() => super.allSelected,
              name: 'FilterQuestsStoreBase.allSelected'))
          .value;

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

  final _$priorityAtom = Atom(name: 'FilterQuestsStoreBase.priority');

  @override
  ObservableList<bool> get priority {
    _$priorityAtom.reportRead();
    return super.priority;
  }

  @override
  set priority(ObservableList<bool> value) {
    _$priorityAtom.reportWrite(value, super.priority, () {
      super.priority = value;
    });
  }

  final _$selectedSkillFiltersAtom =
      Atom(name: 'FilterQuestsStoreBase.selectedSkillFilters');

  @override
  ObservableMap<int, ObservableList<bool>> get selectedSkillFilters {
    _$selectedSkillFiltersAtom.reportRead();
    return super.selectedSkillFilters;
  }

  @override
  set selectedSkillFilters(ObservableMap<int, ObservableList<bool>> value) {
    _$selectedSkillFiltersAtom.reportWrite(value, super.selectedSkillFilters,
        () {
      super.selectedSkillFilters = value;
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

  final _$selectRatingAtom = Atom(name: 'FilterQuestsStoreBase.selectRating');

  @override
  ObservableList<bool> get selectRating {
    _$selectRatingAtom.reportRead();
    return super.selectRating;
  }

  @override
  set selectRating(ObservableList<bool> value) {
    _$selectRatingAtom.reportWrite(value, super.selectRating, () {
      super.selectRating = value;
    });
  }

  final _$sortByPriorityAtom =
      Atom(name: 'FilterQuestsStoreBase.sortByPriority');

  @override
  ObservableList<String> get sortByPriority {
    _$sortByPriorityAtom.reportRead();
    return super.sortByPriority;
  }

  @override
  set sortByPriority(ObservableList<String> value) {
    _$sortByPriorityAtom.reportWrite(value, super.sortByPriority, () {
      super.sortByPriority = value;
    });
  }

  final _$sortByEmployeeRatingAtom =
      Atom(name: 'FilterQuestsStoreBase.sortByEmployeeRating');

  @override
  ObservableList<String> get sortByEmployeeRating {
    _$sortByEmployeeRatingAtom.reportRead();
    return super.sortByEmployeeRating;
  }

  @override
  set sortByEmployeeRating(ObservableList<String> value) {
    _$sortByEmployeeRatingAtom.reportWrite(value, super.sortByEmployeeRating,
        () {
      super.sortByEmployeeRating = value;
    });
  }

  final _$selectEmployeeRatingAtom =
      Atom(name: 'FilterQuestsStoreBase.selectEmployeeRating');

  @override
  ObservableList<bool> get selectEmployeeRating {
    _$selectEmployeeRatingAtom.reportRead();
    return super.selectEmployeeRating;
  }

  @override
  set selectEmployeeRating(ObservableList<bool> value) {
    _$selectEmployeeRatingAtom.reportWrite(value, super.selectEmployeeRating,
        () {
      super.selectEmployeeRating = value;
    });
  }

  final _$sortByWorkplaceAtom =
      Atom(name: 'FilterQuestsStoreBase.sortByWorkplace');

  @override
  ObservableList<String> get sortByWorkplace {
    _$sortByWorkplaceAtom.reportRead();
    return super.sortByWorkplace;
  }

  @override
  set sortByWorkplace(ObservableList<String> value) {
    _$sortByWorkplaceAtom.reportWrite(value, super.sortByWorkplace, () {
      super.sortByWorkplace = value;
    });
  }

  final _$selectWorkplaceAtom =
      Atom(name: 'FilterQuestsStoreBase.selectWorkplace');

  @override
  ObservableList<bool> get selectWorkplace {
    _$selectWorkplaceAtom.reportRead();
    return super.selectWorkplace;
  }

  @override
  set selectWorkplace(ObservableList<bool> value) {
    _$selectWorkplaceAtom.reportWrite(value, super.selectWorkplace, () {
      super.selectWorkplace = value;
    });
  }

  final _$FilterQuestsStoreBaseActionController =
      ActionController(name: 'FilterQuestsStoreBase');

  @override
  void setSelectedWorkplace(bool? value, int index) {
    final _$actionInfo = _$FilterQuestsStoreBaseActionController.startAction(
        name: 'FilterQuestsStoreBase.setSelectedWorkplace');
    try {
      return super.setSelectedWorkplace(value, index);
    } finally {
      _$FilterQuestsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedPriority(bool? value, int index) {
    final _$actionInfo = _$FilterQuestsStoreBaseActionController.startAction(
        name: 'FilterQuestsStoreBase.setSelectedPriority');
    try {
      return super.setSelectedPriority(value, index);
    } finally {
      _$FilterQuestsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedEmployeeRating(bool? value, int index) {
    final _$actionInfo = _$FilterQuestsStoreBaseActionController.startAction(
        name: 'FilterQuestsStoreBase.setSelectedEmployeeRating');
    try {
      return super.setSelectedEmployeeRating(value, index);
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
  void initEmployments(List<String> value) {
    final _$actionInfo = _$FilterQuestsStoreBaseActionController.startAction(
        name: 'FilterQuestsStoreBase.initEmployments');
    try {
      return super.initEmployments(value);
    } finally {
      _$FilterQuestsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void initRating(List<String> value) {
    final _$actionInfo = _$FilterQuestsStoreBaseActionController.startAction(
        name: 'FilterQuestsStoreBase.initRating');
    try {
      return super.initRating(value);
    } finally {
      _$FilterQuestsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void initWorkplace(List<String> value) {
    final _$actionInfo = _$FilterQuestsStoreBaseActionController.startAction(
        name: 'FilterQuestsStoreBase.initWorkplace');
    try {
      return super.initWorkplace(value);
    } finally {
      _$FilterQuestsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void initPriority(List<int> value) {
    final _$actionInfo = _$FilterQuestsStoreBaseActionController.startAction(
        name: 'FilterQuestsStoreBase.initPriority');
    try {
      return super.initPriority(value);
    } finally {
      _$FilterQuestsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void initSort(String value) {
    final _$actionInfo = _$FilterQuestsStoreBaseActionController.startAction(
        name: 'FilterQuestsStoreBase.initSort');
    try {
      return super.initSort(value);
    } finally {
      _$FilterQuestsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void initSkillFilters(List<String> value) {
    final _$actionInfo = _$FilterQuestsStoreBaseActionController.startAction(
        name: 'FilterQuestsStoreBase.initSkillFilters');
    try {
      return super.initSkillFilters(value);
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
priority: ${priority},
selectedSkillFilters: ${selectedSkillFilters},
sortBy: ${sortBy},
selectSortBy: ${selectSortBy},
sortByEmployment: ${sortByEmployment},
selectEmployment: ${selectEmployment},
selectRating: ${selectRating},
sortByPriority: ${sortByPriority},
sortByEmployeeRating: ${sortByEmployeeRating},
selectEmployeeRating: ${selectEmployeeRating},
sortByWorkplace: ${sortByWorkplace},
selectWorkplace: ${selectWorkplace},
allSelected: ${allSelected}
    ''';
  }
}
