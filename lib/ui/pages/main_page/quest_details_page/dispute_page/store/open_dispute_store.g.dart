// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_dispute_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$OpenDisputeStore on _OpenDisputeStore, Store {
  final _$themeAtom = Atom(name: '_OpenDisputeStore.theme');

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

  final _$descriptionAtom = Atom(name: '_OpenDisputeStore.description');

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

  final _$_OpenDisputeStoreActionController =
      ActionController(name: '_OpenDisputeStore');

  @override
  void setDescription(String value) {
    final _$actionInfo = _$_OpenDisputeStoreActionController.startAction(
        name: '_OpenDisputeStore.setDescription');
    try {
      return super.setDescription(value);
    } finally {
      _$_OpenDisputeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeTheme(String selectTheme) {
    final _$actionInfo = _$_OpenDisputeStoreActionController.startAction(
        name: '_OpenDisputeStore.changeTheme');
    try {
      return super.changeTheme(selectTheme);
    } finally {
      _$_OpenDisputeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
theme: ${theme},
description: ${description}
    ''';
  }
}
