// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_quest_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CreateQuestStore on _CreateQuestStore, Store {
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

  final _$priorityAtom = Atom(name: '_CreateQuestStore.priority');

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

  final _$titleAtom = Atom(name: '_CreateQuestStore.title');

  @override
  String get title {
    _$titleAtom.reportRead();
    return super.title;
  }

  @override
  set title(String value) {
    _$titleAtom.reportWrite(value, super.title, () {
      super.title = value;
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

  final _$_CreateQuestStoreActionController =
      ActionController(name: '_CreateQuestStore');

  @override
  void changedDropDownItem(String selectedCategory) {
    final _$actionInfo = _$_CreateQuestStoreActionController.startAction(
        name: '_CreateQuestStore.changedDropDownItem');
    try {
      return super.changedDropDownItem(selectedCategory);
    } finally {
      _$_CreateQuestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
category: ${category},
priority: ${priority},
longitude: ${longitude},
latitude: ${latitude},
title: ${title},
description: ${description},
price: ${price},
adType: ${adType}
    ''';
  }
}
