// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'choose_quest_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChooseQuestStore on _ChooseQuestStore, Store {
  final _$questsAtom = Atom(name: '_ChooseQuestStore.quests');

  @override
  ObservableList<BaseQuestResponse> get quests {
    _$questsAtom.reportRead();
    return super.quests;
  }

  @override
  set quests(ObservableList<BaseQuestResponse> value) {
    _$questsAtom.reportWrite(value, super.quests, () {
      super.quests = value;
    });
  }

  final _$questIdAtom = Atom(name: '_ChooseQuestStore.questId');

  @override
  String get questId {
    _$questIdAtom.reportRead();
    return super.questId;
  }

  @override
  set questId(String value) {
    _$questIdAtom.reportWrite(value, super.questId, () {
      super.questId = value;
    });
  }

  final _$contractAddressAtom = Atom(name: '_ChooseQuestStore.contractAddress');

  @override
  String get contractAddress {
    _$contractAddressAtom.reportRead();
    return super.contractAddress;
  }

  @override
  set contractAddress(String value) {
    _$contractAddressAtom.reportWrite(value, super.contractAddress, () {
      super.contractAddress = value;
    });
  }

  final _$getUserAsyncAction = AsyncAction('_ChooseQuestStore.getUser');

  @override
  Future<void> getUser({required String userId}) {
    return _$getUserAsyncAction.run(() => super.getUser(userId: userId));
  }

  final _$getQuestsAsyncAction = AsyncAction('_ChooseQuestStore.getQuests');

  @override
  Future<void> getQuests(
      {required String userId,
      required bool newList,
      required bool isProfileYours}) {
    return _$getQuestsAsyncAction.run(() => super.getQuests(
        userId: userId, newList: newList, isProfileYours: isProfileYours));
  }

  final _$startQuestAsyncAction = AsyncAction('_ChooseQuestStore.startQuest');

  @override
  Future<void> startQuest(
      {required String userId, required String userAddress}) {
    return _$startQuestAsyncAction
        .run(() => super.startQuest(userId: userId, userAddress: userAddress));
  }

  final _$_ChooseQuestStoreActionController =
      ActionController(name: '_ChooseQuestStore');

  @override
  void setQuest(String id, String contractAddress) {
    final _$actionInfo = _$_ChooseQuestStoreActionController.startAction(
        name: '_ChooseQuestStore.setQuest');
    try {
      return super.setQuest(id, contractAddress);
    } finally {
      _$_ChooseQuestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
quests: ${quests},
questId: ${questId},
contractAddress: ${contractAddress}
    ''';
  }
}
