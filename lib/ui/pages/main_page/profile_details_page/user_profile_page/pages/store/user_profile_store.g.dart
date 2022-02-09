// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserProfileStore on _UserProfileStore, Store {
  final _$questsAtom = Atom(name: '_UserProfileStore.quests');

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

  final _$questIdAtom = Atom(name: '_UserProfileStore.questId');

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

  final _$_UserProfileStoreActionController =
      ActionController(name: '_UserProfileStore');

  @override
  void setQuest(String? index, String id) {
    final _$actionInfo = _$_UserProfileStoreActionController.startAction(
        name: '_UserProfileStore.setQuest');
    try {
      return super.setQuest(index, id);
    } finally {
      _$_UserProfileStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
quests: ${quests},
questId: ${questId}
    ''';
  }
}
