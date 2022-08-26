// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_quests_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProfileQuestsStore on _ProfileQuestsStore, Store {
  final _$questsAtom = Atom(name: '_ProfileQuestsStore.quests');

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

  final _$getQuestsAsyncAction = AsyncAction('_ProfileQuestsStore.getQuests');

  @override
  Future getQuests(
      {required UserRole userRole,
      required String userId,
      required bool isProfileYours,
      required ProfileQuestsType typeQuests,
      bool isForce = false}) {
    return _$getQuestsAsyncAction.run(() => super.getQuests(
        userRole: userRole,
        userId: userId,
        isProfileYours: isProfileYours,
        typeQuests: typeQuests,
        isForce: isForce));
  }

  @override
  String toString() {
    return '''
quests: ${quests}
    ''';
  }
}
