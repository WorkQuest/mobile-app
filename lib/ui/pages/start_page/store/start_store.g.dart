// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$StartStore on _StartStore, Store {
  final _$currentPosAtom = Atom(name: '_StartStore.currentPos');

  @override
  int get currentPos {
    _$currentPosAtom.reportRead();
    return super.currentPos;
  }

  @override
  set currentPos(int value) {
    _$currentPosAtom.reportWrite(value, super.currentPos, () {
      super.currentPos = value;
    });
  }

  final _$_StartStoreActionController = ActionController(name: '_StartStore');

  @override
  void setCurrentPos(int index) {
    final _$actionInfo = _$_StartStoreActionController.startAction(
        name: '_StartStore.setCurrentPos');
    try {
      return super.setCurrentPos(index);
    } finally {
      _$_StartStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentPos: ${currentPos}
    ''';
  }
}
