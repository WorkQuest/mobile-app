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

  final _$employmentAtom = Atom(name: 'FilterQuestsStoreBase.employment');

  @override
  ObservableList<bool> get employment {
    _$employmentAtom.reportRead();
    return super.employment;
  }

  @override
  set employment(ObservableList<bool> value) {
    _$employmentAtom.reportWrite(value, super.employment, () {
      super.employment = value;
    });
  }

  final _$workplaceAtom = Atom(name: 'FilterQuestsStoreBase.workplace');

  @override
  ObservableList<bool> get workplace {
    _$workplaceAtom.reportRead();
    return super.workplace;
  }

  @override
  set workplace(ObservableList<bool> value) {
    _$workplaceAtom.reportWrite(value, super.workplace, () {
      super.workplace = value;
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

  final _$employmentValueAtom =
      Atom(name: 'FilterQuestsStoreBase.employmentValue');

  @override
  ObservableList<String> get employmentValue {
    _$employmentValueAtom.reportRead();
    return super.employmentValue;
  }

  @override
  set employmentValue(ObservableList<String> value) {
    _$employmentValueAtom.reportWrite(value, super.employmentValue, () {
      super.employmentValue = value;
    });
  }

  final _$workplaceValueAtom =
      Atom(name: 'FilterQuestsStoreBase.workplaceValue');

  @override
  ObservableList<String> get workplaceValue {
    _$workplaceValueAtom.reportRead();
    return super.workplaceValue;
  }

  @override
  set workplaceValue(ObservableList<String> value) {
    _$workplaceValueAtom.reportWrite(value, super.workplaceValue, () {
      super.workplaceValue = value;
    });
  }

  final _$priorityValueAtom = Atom(name: 'FilterQuestsStoreBase.priorityValue');

  @override
  ObservableList<int> get priorityValue {
    _$priorityValueAtom.reportRead();
    return super.priorityValue;
  }

  @override
  set priorityValue(ObservableList<int> value) {
    _$priorityValueAtom.reportWrite(value, super.priorityValue, () {
      super.priorityValue = value;
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

  final _$selectPriorityAtom =
      Atom(name: 'FilterQuestsStoreBase.selectPriority');

  @override
  ObservableList<bool> get selectPriority {
    _$selectPriorityAtom.reportRead();
    return super.selectPriority;
  }

  @override
  set selectPriority(ObservableList<bool> value) {
    _$selectPriorityAtom.reportWrite(value, super.selectPriority, () {
      super.selectPriority = value;
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
  List<String> getEmploymentValue() {
    final _$actionInfo = _$FilterQuestsStoreBaseActionController.startAction(
        name: 'FilterQuestsStoreBase.getEmploymentValue');
    try {
      return super.getEmploymentValue();
    } finally {
      _$FilterQuestsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  List<int> getPriorityValue() {
    final _$actionInfo = _$FilterQuestsStoreBaseActionController.startAction(
        name: 'FilterQuestsStoreBase.getPriorityValue');
    try {
      return super.getPriorityValue();
    } finally {
      _$FilterQuestsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  List<String> getWorkplaceValue() {
    final _$actionInfo = _$FilterQuestsStoreBaseActionController.startAction(
        name: 'FilterQuestsStoreBase.getWorkplaceValue');
    try {
      return super.getWorkplaceValue();
    } finally {
      _$FilterQuestsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

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
employment: ${employment},
workplace: ${workplace},
priority: ${priority},
employmentValue: ${employmentValue},
workplaceValue: ${workplaceValue},
priorityValue: ${priorityValue},
sortBy: ${sortBy},
selectSortBy: ${selectSortBy},
sortByQuestDelivery: ${sortByQuestDelivery},
selectQuestDelivery: ${selectQuestDelivery},
sortByEmployment: ${sortByEmployment},
selectEmployment: ${selectEmployment},
sortByPriority: ${sortByPriority},
selectPriority: ${selectPriority},
sortByEmployeeRating: ${sortByEmployeeRating},
selectEmployeeRating: ${selectEmployeeRating},
sortByWorkplace: ${sortByWorkplace},
selectWorkplace: ${selectWorkplace},
allSelected: ${allSelected}
    ''';
  }
}
