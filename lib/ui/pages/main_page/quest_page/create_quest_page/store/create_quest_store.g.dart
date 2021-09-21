// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_quest_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CreateQuestStore on _CreateQuestStore, Store {
  Computed<String>? _$dateStringComputed;

  @override
  String get dateString =>
      (_$dateStringComputed ??= Computed<String>(() => super.dateString,
              name: '_CreateQuestStore.dateString'))
          .value;
  Computed<bool>? _$canCreateQuestComputed;

  @override
  bool get canCreateQuest =>
      (_$canCreateQuestComputed ??= Computed<bool>(() => super.canCreateQuest,
              name: '_CreateQuestStore.canCreateQuest'))
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

  final _$distantWorkAtom = Atom(name: '_CreateQuestStore.distantWork');

  @override
  String get workplace {
    _$distantWorkAtom.reportRead();
    return super.workplace;
  }

  @override
  set workplace(String value) {
    _$distantWorkAtom.reportWrite(value, super.workplace, () {
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

  final _$hasRuntimeAtom = Atom(name: '_CreateQuestStore.hasRuntime');

  @override
  bool get hasRuntime {
    _$hasRuntimeAtom.reportRead();
    return super.hasRuntime;
  }

  @override
  set hasRuntime(bool value) {
    _$hasRuntimeAtom.reportWrite(value, super.hasRuntime, () {
      super.hasRuntime = value;
    });
  }

  final _$runtimeValueAtom = Atom(name: '_CreateQuestStore.runtimeValue');

  @override
  DateTime get runtimeValue {
    _$runtimeValueAtom.reportRead();
    return super.runtimeValue;
  }

  @override
  set runtimeValue(DateTime value) {
    _$runtimeValueAtom.reportWrite(value, super.runtimeValue, () {
      super.runtimeValue = value;
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

  final _$mediaAtom = Atom(name: '_CreateQuestStore.media');

  @override
  ObservableList<DrishyaEntity> get media {
    _$mediaAtom.reportRead();
    return super.media;
  }

  @override
  set media(ObservableList<DrishyaEntity> value) {
    _$mediaAtom.reportWrite(value, super.media, () {
      super.media = value;
    });
  }

  final _$createQuestAsyncAction = AsyncAction('_CreateQuestStore.createQuest');

  @override
  Future<dynamic> createQuest() {
    return _$createQuestAsyncAction.run(() => super.createQuest());
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
  void setRuntime(bool? value) {
    final _$actionInfo = _$_CreateQuestStoreActionController.startAction(
        name: '_CreateQuestStore.setRuntime');
    try {
      return super.setRuntime(value);
    } finally {
      _$_CreateQuestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDateTime(DateTime value) {
    final _$actionInfo = _$_CreateQuestStoreActionController.startAction(
        name: '_CreateQuestStore.setDateTime');
    try {
      return super.setDateTime(value);
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
  void changedCategory(String selectedCategory) {
    final _$actionInfo = _$_CreateQuestStoreActionController.startAction(
        name: '_CreateQuestStore.changedCategory');
    try {
      return super.changedCategory(selectedCategory);
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
  String toString() {
    return '''
employment: ${employment},
distantWork: ${workplace},
category: ${category},
categoryValue: ${categoryValue},
priority: ${priority},
hasRuntime: ${hasRuntime},
runtimeValue: ${runtimeValue},
dateTime: ${dateTime},
longitude: ${longitude},
latitude: ${latitude},
questTitle: ${questTitle},
description: ${description},
price: ${price},
adType: ${adType},
media: ${media},
dateString: ${dateString},
canCreateQuest: ${canCreateQuest}
    ''';
  }
}
