// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_visibility_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProfileVisibilityStore on _ProfileVisibilityStore, Store {
  final _$mySearchAtom = Atom(name: '_ProfileVisibilityStore.mySearch');

  @override
  ObservableMap<VisibilityTypes, bool> get mySearch {
    _$mySearchAtom.reportRead();
    return super.mySearch;
  }

  @override
  set mySearch(ObservableMap<VisibilityTypes, bool> value) {
    _$mySearchAtom.reportWrite(value, super.mySearch, () {
      super.mySearch = value;
    });
  }

  final _$canRespondOrInviteToQuestAtom =
      Atom(name: '_ProfileVisibilityStore.canRespondOrInviteToQuest');

  @override
  ObservableMap<VisibilityTypes, bool> get canRespondOrInviteToQuest {
    _$canRespondOrInviteToQuestAtom.reportRead();
    return super.canRespondOrInviteToQuest;
  }

  @override
  set canRespondOrInviteToQuest(ObservableMap<VisibilityTypes, bool> value) {
    _$canRespondOrInviteToQuestAtom
        .reportWrite(value, super.canRespondOrInviteToQuest, () {
      super.canRespondOrInviteToQuest = value;
    });
  }

  final _$_ProfileVisibilityStoreActionController =
      ActionController(name: '_ProfileVisibilityStore');

  @override
  dynamic setMySearch(VisibilityTypes type, bool value) {
    final _$actionInfo = _$_ProfileVisibilityStoreActionController.startAction(
        name: '_ProfileVisibilityStore.setMySearch');
    try {
      return super.setMySearch(type, value);
    } finally {
      _$_ProfileVisibilityStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCanRespondOrInviteToQuest(VisibilityTypes type, bool value) {
    final _$actionInfo = _$_ProfileVisibilityStoreActionController.startAction(
        name: '_ProfileVisibilityStore.setCanRespondOrInviteToQuest');
    try {
      return super.setCanRespondOrInviteToQuest(type, value);
    } finally {
      _$_ProfileVisibilityStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
mySearch: ${mySearch},
canRespondOrInviteToQuest: ${canRespondOrInviteToQuest}
    ''';
  }
}
