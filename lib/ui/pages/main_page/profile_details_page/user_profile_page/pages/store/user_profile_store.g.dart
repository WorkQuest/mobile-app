// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserProfileStore on _UserProfileStore, Store {
  final _$userQuestAtom = Atom(name: '_UserProfileStore.userQuest');

  @override
  ObservableList<BaseQuestResponse> get userQuest {
    _$userQuestAtom.reportRead();
    return super.userQuest;
  }

  @override
  set userQuest(ObservableList<BaseQuestResponse> value) {
    _$userQuestAtom.reportWrite(value, super.userQuest, () {
      super.userQuest = value;
    });
  }

  final _$questForWorkerAtom = Atom(name: '_UserProfileStore.questForWorker');

  @override
  ObservableList<BaseQuestResponse> get questForWorker {
    _$questForWorkerAtom.reportRead();
    return super.questForWorker;
  }

  @override
  set questForWorker(ObservableList<BaseQuestResponse> value) {
    _$questForWorkerAtom.reportWrite(value, super.questForWorker, () {
      super.questForWorker = value;
    });
  }

  final _$questNameAtom = Atom(name: '_UserProfileStore.questName');

  @override
  String get questName {
    _$questNameAtom.reportRead();
    return super.questName;
  }

  @override
  set questName(String value) {
    _$questNameAtom.reportWrite(value, super.questName, () {
      super.questName = value;
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
userQuest: ${userQuest},
questForWorker: ${questForWorker},
questName: ${questName}
    ''';
  }
}
