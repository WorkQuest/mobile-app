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

  final _$contractAddressAtom = Atom(name: '_UserProfileStore.contractAddress');

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

  final _$getProfileAsyncAction = AsyncAction('_UserProfileStore.getProfile');

  @override
  Future<void> getProfile({required String userId}) {
    return _$getProfileAsyncAction.run(() => super.getProfile(userId: userId));
  }

  final _$startQuestAsyncAction = AsyncAction('_UserProfileStore.startQuest');

  @override
  Future<void> startQuest(
      {required String userId, required String userAddress}) {
    return _$startQuestAsyncAction
        .run(() => super.startQuest(userId: userId, userAddress: userAddress));
  }

  final _$_UserProfileStoreActionController =
      ActionController(name: '_UserProfileStore');

  @override
  void setQuest(String id, String contractAddress) {
    final _$actionInfo = _$_UserProfileStoreActionController.startAction(
        name: '_UserProfileStore.setQuest');
    try {
      return super.setQuest(id, contractAddress);
    } finally {
      _$_UserProfileStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
userData: ${userData},
quests: ${quests},
questId: ${questId},
contractAddress: ${contractAddress}
    ''';
  }
}
