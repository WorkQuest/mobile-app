// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_quest_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MyQuestStore on _MyQuestStore, Store {
  final _$questsAtom = Atom(name: '_MyQuestStore.quests');

  @override
  ObservableMap<QuestsType, ObservableList<BaseQuestResponse>> get quests {
    _$questsAtom.reportRead();
    return super.quests;
  }

  @override
  set quests(
      ObservableMap<QuestsType, ObservableList<BaseQuestResponse>> value) {
    _$questsAtom.reportWrite(value, super.quests, () {
      super.quests = value;
    });
  }

  final _$changeListsAsyncAction = AsyncAction('_MyQuestStore.changeLists');

  @override
  Future changeLists(dynamic json) {
    return _$changeListsAsyncAction.run(() => super.changeLists(json));
  }

  final _$setStarAsyncAction = AsyncAction('_MyQuestStore.setStar');

  @override
  Future<void> setStar(BaseQuestResponse quest, bool set) {
    return _$setStarAsyncAction.run(() => super.setStar(quest, set));
  }

  final _$updateListQuestAsyncAction =
      AsyncAction('_MyQuestStore.updateListQuest');

  @override
  Future<void> updateListQuest() {
    return _$updateListQuestAsyncAction.run(() => super.updateListQuest());
  }

  final _$getQuestsAsyncAction = AsyncAction('_MyQuestStore.getQuests');

  @override
  Future<void> getQuests({required QuestsType questType, bool isForce = true}) {
    return _$getQuestsAsyncAction
        .run(() => super.getQuests(questType: questType, isForce: isForce));
  }

  final _$_MyQuestStoreActionController =
      ActionController(name: '_MyQuestStore');

  @override
  void sortQuests() {
    final _$actionInfo = _$_MyQuestStoreActionController.startAction(
        name: '_MyQuestStore.sortQuests');
    try {
      return super.sortQuests();
    } finally {
      _$_MyQuestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic deleteQuestFromList(QuestsType questsType, String id) {
    final _$actionInfo = _$_MyQuestStoreActionController.startAction(
        name: '_MyQuestStore.deleteQuestFromList');
    try {
      return super.deleteQuestFromList(questsType, id);
    } finally {
      _$_MyQuestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
quests: ${quests}
    ''';
  }
}
