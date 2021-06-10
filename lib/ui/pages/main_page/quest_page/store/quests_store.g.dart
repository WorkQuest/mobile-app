// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quests_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$QuestsStore on _QuestsStore, Store {
  final _$questsListAtom = Atom(name: '_QuestsStore.questsList');

  @override
  List<BaseQuestResponse>? get questsList {
    _$questsListAtom.reportRead();
    return super.questsList;
  }

  @override
  set questsList(List<BaseQuestResponse>? value) {
    _$questsListAtom.reportWrite(value, super.questsList, () {
      super.questsList = value;
    });
  }

  final _$mapListCheckerAtom = Atom(name: '_QuestsStore.mapListChecker');

  @override
  _MapList get mapListChecker {
    _$mapListCheckerAtom.reportRead();
    return super.mapListChecker;
  }

  @override
  set mapListChecker(_MapList value) {
    _$mapListCheckerAtom.reportWrite(value, super.mapListChecker, () {
      super.mapListChecker = value;
    });
  }

  final _$getQuestsAsyncAction = AsyncAction('_QuestsStore.getQuests');

  @override
  Future<dynamic> getQuests() {
    return _$getQuestsAsyncAction.run(() => super.getQuests());
  }

  final _$_QuestsStoreActionController = ActionController(name: '_QuestsStore');

  @override
  dynamic changeValue() {
    final _$actionInfo = _$_QuestsStoreActionController.startAction(
        name: '_QuestsStore.changeValue');
    try {
      return super.changeValue();
    } finally {
      _$_QuestsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic isMapOpened() {
    final _$actionInfo = _$_QuestsStoreActionController.startAction(
        name: '_QuestsStore.isMapOpened');
    try {
      return super.isMapOpened();
    } finally {
      _$_QuestsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
questsList: ${questsList},
mapListChecker: ${mapListChecker}
    ''';
  }
}
