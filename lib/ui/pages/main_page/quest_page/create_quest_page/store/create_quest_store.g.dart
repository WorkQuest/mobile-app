// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_quest_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CreateQuestStore on _CreateQuestStore, Store {
  Computed<bool>? _$canCreateQuestComputed;

  @override
  bool get canCreateQuest =>
      (_$canCreateQuestComputed ??= Computed<bool>(() => super.canCreateQuest,
              name: '_CreateQuestStore.canCreateQuest'))
          .value;
  Computed<bool>? _$canSubmitEditQuestComputed;

  @override
  bool get canSubmitEditQuest => (_$canSubmitEditQuestComputed ??=
          Computed<bool>(() => super.canSubmitEditQuest,
              name: '_CreateQuestStore.canSubmitEditQuest'))
      .value;

  final _$employmentAtom = Atom(name: '_CreateQuestStore.employment');

  @override
  String get employment {
    _$employmentAtom.reportRead();
    return super.employment;
  }

  @override
  set employment(String value) {
    _$employmentAtom.reportWrite(value, super.employment, () {
      super.employment = value;
    });
  }

  final _$employmentValueAtom = Atom(name: '_CreateQuestStore.employmentValue');

  @override
  String get employmentValue {
    _$employmentValueAtom.reportRead();
    return super.employmentValue;
  }

  @override
  set employmentValue(String value) {
    _$employmentValueAtom.reportWrite(value, super.employmentValue, () {
      super.employmentValue = value;
    });
  }

  final _$workplaceValueAtom = Atom(name: '_CreateQuestStore.workplaceValue');

  @override
  String get workplaceValue {
    _$workplaceValueAtom.reportRead();
    return super.workplaceValue;
  }

  @override
  set workplaceValue(String value) {
    _$workplaceValueAtom.reportWrite(value, super.workplaceValue, () {
      super.workplaceValue = value;
    });
  }

  final _$workplaceAtom = Atom(name: '_CreateQuestStore.workplace');

  @override
  String get workplace {
    _$workplaceAtom.reportRead();
    return super.workplace;
  }

  @override
  set workplace(String value) {
    _$workplaceAtom.reportWrite(value, super.workplace, () {
      super.workplace = value;
    });
  }

  final _$categoryAtom = Atom(name: '_CreateQuestStore.category');

  @override
  String get category {
    _$categoryAtom.reportRead();
    return super.category;
  }

  @override
  set category(String value) {
    _$categoryAtom.reportWrite(value, super.category, () {
      super.category = value;
    });
  }

  final _$categoryValueAtom = Atom(name: '_CreateQuestStore.categoryValue');

  @override
  String get categoryValue {
    _$categoryValueAtom.reportRead();
    return super.categoryValue;
  }

  @override
  set categoryValue(String value) {
    _$categoryValueAtom.reportWrite(value, super.categoryValue, () {
      super.categoryValue = value;
    });
  }

  final _$priorityAtom = Atom(name: '_CreateQuestStore.priority');

  @override
  String get priority {
    _$priorityAtom.reportRead();
    return super.priority;
  }

  @override
  set priority(String value) {
    _$priorityAtom.reportWrite(value, super.priority, () {
      super.priority = value;
    });
  }

  final _$dateTimeAtom = Atom(name: '_CreateQuestStore.dateTime');

  @override
  String get dateTime {
    _$dateTimeAtom.reportRead();
    return super.dateTime;
  }

  @override
  set dateTime(String value) {
    _$dateTimeAtom.reportWrite(value, super.dateTime, () {
      super.dateTime = value;
    });
  }

  final _$longitudeAtom = Atom(name: '_CreateQuestStore.longitude');

  @override
  double get longitude {
    _$longitudeAtom.reportRead();
    return super.longitude;
  }

  @override
  set longitude(double value) {
    _$longitudeAtom.reportWrite(value, super.longitude, () {
      super.longitude = value;
    });
  }

  final _$latitudeAtom = Atom(name: '_CreateQuestStore.latitude');

  @override
  double get latitude {
    _$latitudeAtom.reportRead();
    return super.latitude;
  }

  @override
  set latitude(double value) {
    _$latitudeAtom.reportWrite(value, super.latitude, () {
      super.latitude = value;
    });
  }

  final _$questTitleAtom = Atom(name: '_CreateQuestStore.questTitle');

  @override
  String get questTitle {
    _$questTitleAtom.reportRead();
    return super.questTitle;
  }

  @override
  set questTitle(String value) {
    _$questTitleAtom.reportWrite(value, super.questTitle, () {
      super.questTitle = value;
    });
  }

  final _$descriptionAtom = Atom(name: '_CreateQuestStore.description');

  @override
  String get description {
    _$descriptionAtom.reportRead();
    return super.description;
  }

  @override
  set description(String value) {
    _$descriptionAtom.reportWrite(value, super.description, () {
      super.description = value;
    });
  }

  final _$priceAtom = Atom(name: '_CreateQuestStore.price');

  @override
  String get price {
    _$priceAtom.reportRead();
    return super.price;
  }

  @override
  set price(String value) {
    _$priceAtom.reportWrite(value, super.price, () {
      super.price = value;
    });
  }

  final _$adTypeAtom = Atom(name: '_CreateQuestStore.adType');

  @override
  int get adType {
    _$adTypeAtom.reportRead();
    return super.adType;
  }

  @override
  set adType(int value) {
    _$adTypeAtom.reportWrite(value, super.adType, () {
      super.adType = value;
    });
  }

  final _$mediaFileAtom = Atom(name: '_CreateQuestStore.mediaFile');

  @override
  ObservableList<File> get mediaFile {
    _$mediaFileAtom.reportRead();
    return super.mediaFile;
  }

  @override
  set mediaFile(ObservableList<File> value) {
    _$mediaFileAtom.reportWrite(value, super.mediaFile, () {
      super.mediaFile = value;
    });
  }

  final _$mediaIdsAtom = Atom(name: '_CreateQuestStore.mediaIds');

  @override
  ObservableList<Media> get mediaIds {
    _$mediaIdsAtom.reportRead();
    return super.mediaIds;
  }

  @override
  set mediaIds(ObservableList<Media> value) {
    _$mediaIdsAtom.reportWrite(value, super.mediaIds, () {
      super.mediaIds = value;
    });
  }

  final _$locationPlaceNameAtom =
      Atom(name: '_CreateQuestStore.locationPlaceName');

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

  final _$skillFiltersAtom = Atom(name: '_CreateQuestStore.skillFilters');

  @override
  List<String> get skillFilters {
    _$skillFiltersAtom.reportRead();
    return super.skillFilters;
  }

  @override
  set skillFilters(List<String> value) {
    _$skillFiltersAtom.reportWrite(value, super.skillFilters, () {
      super.skillFilters = value;
    });
  }

  final _$getPredictionAsyncAction =
      AsyncAction('_CreateQuestStore.getPrediction');

  @override
  Future<Null> getPrediction(BuildContext context) {
    return _$getPredictionAsyncAction.run(() => super.getPrediction(context));
  }

  final _$displayPredictionAsyncAction =
      AsyncAction('_CreateQuestStore.displayPrediction');

  @override
  Future<Null> displayPrediction(String? p) {
    return _$displayPredictionAsyncAction.run(() => super.displayPrediction(p));
  }

  final _$createQuestAsyncAction = AsyncAction('_CreateQuestStore.createQuest');

  @override
  Future<void> createQuest({bool isEdit = false, String questId = ""}) {
    return _$createQuestAsyncAction
        .run(() => super.createQuest(isEdit: isEdit, questId: questId));
  }

  final _$_CreateQuestStoreActionController =
      ActionController(name: '_CreateQuestStore');

  @override
  void setQuestTitle(String value) {
    final _$actionInfo = _$_CreateQuestStoreActionController.startAction(
        name: '_CreateQuestStore.setQuestTitle');
    try {
      return super.setQuestTitle(value);
    } finally {
      _$_CreateQuestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAboutQuest(String value) {
    final _$actionInfo = _$_CreateQuestStoreActionController.startAction(
        name: '_CreateQuestStore.setAboutQuest');
    try {
      return super.setAboutQuest(value);
    } finally {
      _$_CreateQuestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPrice(String value) {
    final _$actionInfo = _$_CreateQuestStoreActionController.startAction(
        name: '_CreateQuestStore.setPrice');
    try {
      return super.setPrice(value);
    } finally {
      _$_CreateQuestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changedPriority(String selectedPriority) {
    final _$actionInfo = _$_CreateQuestStoreActionController.startAction(
        name: '_CreateQuestStore.changedPriority');
    try {
      return super.changedPriority(selectedPriority);
    } finally {
      _$_CreateQuestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changedEmployment(String selectedEmployment) {
    final _$actionInfo = _$_CreateQuestStoreActionController.startAction(
        name: '_CreateQuestStore.changedEmployment');
    try {
      return super.changedEmployment(selectedEmployment);
    } finally {
      _$_CreateQuestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changedDistantWork(String selectedEmployment) {
    final _$actionInfo = _$_CreateQuestStoreActionController.startAction(
        name: '_CreateQuestStore.changedDistantWork');
    try {
      return super.changedDistantWork(selectedEmployment);
    } finally {
      _$_CreateQuestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void emptyField(BuildContext context) {
    final _$actionInfo = _$_CreateQuestStoreActionController.startAction(
        name: '_CreateQuestStore.emptyField');
    try {
      return super.emptyField(context);
    } finally {
      _$_CreateQuestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
employment: ${employment},
employmentValue: ${employmentValue},
workplaceValue: ${workplaceValue},
workplace: ${workplace},
category: ${category},
categoryValue: ${categoryValue},
priority: ${priority},
dateTime: ${dateTime},
longitude: ${longitude},
latitude: ${latitude},
questTitle: ${questTitle},
description: ${description},
price: ${price},
adType: ${adType},
mediaFile: ${mediaFile},
mediaIds: ${mediaIds},
locationPlaceName: ${locationPlaceName},
skillFilters: ${skillFilters},
canCreateQuest: ${canCreateQuest},
canSubmitEditQuest: ${canSubmitEditQuest}
    ''';
  }
}
