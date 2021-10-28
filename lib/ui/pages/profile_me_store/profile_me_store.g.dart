// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_me_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProfileMeStore on _ProfileMeStore, Store {
  final _$twoFAStatusAtom = Atom(name: '_ProfileMeStore.twoFAStatus');

  @override
  bool? get twoFAStatus {
    _$twoFAStatusAtom.reportRead();
    return super.twoFAStatus;
  }

  @override
  set twoFAStatus(bool? value) {
    _$twoFAStatusAtom.reportWrite(value, super.twoFAStatus, () {
      super.twoFAStatus = value;
    });
  }

  final _$priorityAtom = Atom(name: '_ProfileMeStore.priority');

  @override
  String get priority {
    _$priorityAtom.reportRead();
    return super.priority;
  }

  @override
  set priority(String value) {
    _$priorityAtom.reportWrite(value, super.priority, () {
      super.priority = value;
    });
  }

  final _$distantWorkAtom = Atom(name: '_ProfileMeStore.distantWork');

  @override
  String get distantWork {
    _$distantWorkAtom.reportRead();
    return super.distantWork;
  }

  @override
  set distantWork(String value) {
    _$distantWorkAtom.reportWrite(value, super.distantWork, () {
      super.distantWork = value;
    });
  }

  final _$getProfileMeAsyncAction = AsyncAction('_ProfileMeStore.getProfileMe');

  @override
  Future<dynamic> getProfileMe() {
    return _$getProfileMeAsyncAction.run(() => super.getProfileMe());
  }

  final _$get2FAStatusAsyncAction = AsyncAction('_ProfileMeStore.get2FAStatus');

  @override
  Future<void> get2FAStatus() {
    return _$get2FAStatusAsyncAction.run(() => super.get2FAStatus());
  }

  final _$changeProfileAsyncAction =
      AsyncAction('_ProfileMeStore.changeProfile');

  @override
  Future changeProfile(ProfileMeResponse userData, {DrishyaEntity? media}) {
    return _$changeProfileAsyncAction
        .run(() => super.changeProfile(userData, media: media));
  }

  final _$_ProfileMeStoreActionController =
      ActionController(name: '_ProfileMeStore');

  @override
  List<String> parser(List<String> skills) {
    final _$actionInfo = _$_ProfileMeStoreActionController.startAction(
        name: '_ProfileMeStore.parser');
    try {
      return super.parser(skills);
    } finally {
      _$_ProfileMeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeDistantWork(String selectedDistantWork) {
    final _$actionInfo = _$_ProfileMeStoreActionController.startAction(
        name: '_ProfileMeStore.changeDistantWork');
    try {
      return super.changeDistantWork(selectedDistantWork);
    } finally {
      _$_ProfileMeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changePriority(String selectedPriority) {
    final _$actionInfo = _$_ProfileMeStoreActionController.startAction(
        name: '_ProfileMeStore.changePriority');
    try {
      return super.changePriority(selectedPriority);
    } finally {
      _$_ProfileMeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
twoFAStatus: ${twoFAStatus},
priority: ${priority},
distantWork: ${distantWork}
    ''';
  }
}
