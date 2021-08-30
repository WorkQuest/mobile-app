// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DisputeStore on _DisputeStore, Store {
  final _$themeAtom = Atom(name: '_DisputeStore.theme');

  @override
  String get theme {
    _$themeAtom.reportRead();
    return super.theme;
  }

  @override
  set theme(String value) {
    _$themeAtom.reportWrite(value, super.theme, () {
      super.theme = value;
    });
  }

  final _$themeValueAtom = Atom(name: '_DisputeStore.themeValue');

  @override
  String get themeValue {
    _$themeValueAtom.reportRead();
    return super.themeValue;
  }

  @override
  set themeValue(String value) {
    _$themeValueAtom.reportWrite(value, super.themeValue, () {
      super.themeValue = value;
    });
  }

  final _$descriptionAtom = Atom(name: '_DisputeStore.description');

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

  final _$_DisputeStoreActionController =
      ActionController(name: '_DisputeStore');

  @override
  void setDescription(String value) {
    final _$actionInfo = _$_DisputeStoreActionController.startAction(
        name: '_DisputeStore.setDescription');
    try {
      return super.setDescription(value);
    } finally {
      _$_DisputeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeTheme(String selectTheme) {
    final _$actionInfo = _$_DisputeStoreActionController.startAction(
        name: '_DisputeStore.changeTheme');
    try {
      return super.changeTheme(selectTheme);
    } finally {
      _$_DisputeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
theme: ${theme},
themeValue: ${themeValue},
description: ${description}
    ''';
  }
}
