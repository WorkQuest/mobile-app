// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_details_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$QuestDetailsStore on _QuestDetailsStore, Store {
  final _$questInfoAtom = Atom(name: '_QuestDetailsStore.questInfo');

  @override
  BaseQuestResponse? get questInfo {
    _$questInfoAtom.reportRead();
    return super.questInfo;
  }

  @override
  set questInfo(BaseQuestResponse? value) {
    _$questInfoAtom.reportWrite(value, super.questInfo, () {
      super.questInfo = value;
    });
  }

  final _$questIdAtom = Atom(name: '_QuestDetailsStore.questId');

  @override
  String? get questId {
    _$questIdAtom.reportRead();
    return super.questId;
  }

  @override
  set questId(String? value) {
    _$questIdAtom.reportWrite(value, super.questId, () {
      super.questId = value;
    });
  }

  final _$updateQuestAsyncAction =
      AsyncAction('_QuestDetailsStore.updateQuest');

  @override
  Future updateQuest() {
    return _$updateQuestAsyncAction.run(() => super.updateQuest());
  }

  final _$_QuestDetailsStoreActionController =
      ActionController(name: '_QuestDetailsStore');

  @override
  dynamic initQuest(BaseQuestResponse quest) {
    final _$actionInfo = _$_QuestDetailsStoreActionController.startAction(
        name: '_QuestDetailsStore.initQuest');
    try {
      return super.initQuest(quest);
    } finally {
      _$_QuestDetailsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic initQuestId(String value) {
    final _$actionInfo = _$_QuestDetailsStoreActionController.startAction(
        name: '_QuestDetailsStore.initQuestId');
    try {
      return super.initQuestId(value);
    } finally {
      _$_QuestDetailsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
questInfo: ${questInfo},
questId: ${questId}
    ''';
  }
}
