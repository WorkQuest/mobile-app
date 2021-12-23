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

  @override
  String toString() {
    return '''
userQuest: ${userQuest}
    ''';
  }
}
