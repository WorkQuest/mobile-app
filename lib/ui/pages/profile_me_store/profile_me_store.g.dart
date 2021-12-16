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

  final _$priorityValueAtom = Atom(name: '_ProfileMeStore.priorityValue');

  @override
  String get priorityValue {
    _$priorityValueAtom.reportRead();
    return super.priorityValue;
  }

  @override
  set priorityValue(String value) {
    _$priorityValueAtom.reportWrite(value, super.priorityValue, () {
      super.priorityValue = value;
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

  final _$wagePerHourAtom = Atom(name: '_ProfileMeStore.wagePerHour');

  @override
  String get wagePerHour {
    _$wagePerHourAtom.reportRead();
    return super.wagePerHour;
  }

  @override
  set wagePerHour(String value) {
    _$wagePerHourAtom.reportWrite(value, super.wagePerHour, () {
      super.wagePerHour = value;
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

  final _$getQuestHolderAsyncAction =
      AsyncAction('_ProfileMeStore.getQuestHolder');

  @override
  Future<dynamic> getQuestHolder(String userId) {
    return _$getQuestHolderAsyncAction.run(() => super.getQuestHolder(userId));
  }

  final _$getAssignedWorkerAsyncAction =
      AsyncAction('_ProfileMeStore.getAssignedWorker');

  @override
  Future<dynamic> getAssignedWorker(String userId) {
    return _$getAssignedWorkerAsyncAction
        .run(() => super.getAssignedWorker(userId));
  }

  final _$changeProfileAsyncAction =
      AsyncAction('_ProfileMeStore.changeProfile');

  @override
  Future changeProfile(ProfileMeResponse userData, {File? media}) {
    return _$changeProfileAsyncAction
        .run(() => super.changeProfile(userData, media: media));
  }

  final _$_ProfileMeStoreActionController =
      ActionController(name: '_ProfileMeStore');

  @override
  void priorityToValue() {
    final _$actionInfo = _$_ProfileMeStoreActionController.startAction(
        name: '_ProfileMeStore.priorityToValue');
    try {
      return super.priorityToValue();
    } finally {
      _$_ProfileMeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPriorityValue(String text) {
    final _$actionInfo = _$_ProfileMeStoreActionController.startAction(
        name: '_ProfileMeStore.setPriorityValue');
    try {
      return super.setPriorityValue(text);
    } finally {
      _$_ProfileMeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void workplaceToValue() {
    final _$actionInfo = _$_ProfileMeStoreActionController.startAction(
        name: '_ProfileMeStore.workplaceToValue');
    try {
      return super.workplaceToValue();
    } finally {
      _$_ProfileMeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setWorkplaceValue(String text) {
    final _$actionInfo = _$_ProfileMeStoreActionController.startAction(
        name: '_ProfileMeStore.setWorkplaceValue');
    try {
      return super.setWorkplaceValue(text);
    } finally {
      _$_ProfileMeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setWorkplace(String value) {
    final _$actionInfo = _$_ProfileMeStoreActionController.startAction(
        name: '_ProfileMeStore.setWorkplace');
    try {
      return super.setWorkplace(value);
    } finally {
      _$_ProfileMeStoreActionController.endAction(_$actionInfo);
    }
  }

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
  String toString() {
    return '''
twoFAStatus: ${twoFAStatus},
priorityValue: ${priorityValue},
distantWork: ${distantWork},
wagePerHour: ${wagePerHour}
    ''';
  }
}
