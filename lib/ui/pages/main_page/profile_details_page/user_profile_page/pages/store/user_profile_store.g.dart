// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserProfileStore on _UserProfileStore, Store {
  final _$userDataAtom = Atom(name: '_UserProfileStore.userData');

  @override
  ProfileMeResponse? get userData {
    _$userDataAtom.reportRead();
    return super.userData;
  }

  @override
  set userData(ProfileMeResponse? value) {
    _$userDataAtom.reportWrite(value, super.userData, () {
      super.userData = value;
    });
  }

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

  final _$getProfileAsyncAction = AsyncAction('_UserProfileStore.getProfile');

  @override
  Future getProfile({required String userId}) {
    return _$getProfileAsyncAction.run(() => super.getProfile(userId: userId));
  }

  final _$getQuestsAsyncAction = AsyncAction('_UserProfileStore.getQuests');

  @override
  Future getQuests(
      {required String userId,
      required bool newList,
      required bool isProfileYours}) {
    return _$getQuestsAsyncAction.run(() => super.getQuests(
        userId: userId, newList: newList, isProfileYours: isProfileYours));
  }

  @override
  String toString() {
    return '''
userData: ${userData},
quests: ${quests}
    ''';
  }
}
