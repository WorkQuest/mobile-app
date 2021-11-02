// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_quest_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MyQuestStore on _MyQuestStore, Store {
  final _$sortAtom = Atom(name: '_MyQuestStore.sort');

  @override
  String? get sort {
    _$sortAtom.reportRead();
    return super.sort;
  }

  @override
  set sort(String? value) {
    _$sortAtom.reportWrite(value, super.sort, () {
      super.sort = value;
    });
  }

  final _$priorityAtom = Atom(name: '_MyQuestStore.priority');

  @override
  int get priority {
    _$priorityAtom.reportRead();
    return super.priority;
  }

  @override
  set priority(int value) {
    _$priorityAtom.reportWrite(value, super.priority, () {
      super.priority = value;
    });
  }

  final _$offsetAtom = Atom(name: '_MyQuestStore.offset');

  @override
  int get offset {
    _$offsetAtom.reportRead();
    return super.offset;
  }

  @override
  set offset(int value) {
    _$offsetAtom.reportWrite(value, super.offset, () {
      super.offset = value;
    });
  }

  final _$limitAtom = Atom(name: '_MyQuestStore.limit');

  @override
  int get limit {
    _$limitAtom.reportRead();
    return super.limit;
  }

  @override
  set limit(int value) {
    _$limitAtom.reportWrite(value, super.limit, () {
      super.limit = value;
    });
  }

  final _$statusAtom = Atom(name: '_MyQuestStore.status');

  @override
  int get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(int value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  final _$activeAtom = Atom(name: '_MyQuestStore.active');

  @override
  ObservableList<BaseQuestResponse>? get active {
    _$activeAtom.reportRead();
    return super.active;
  }

  @override
  set active(ObservableList<BaseQuestResponse>? value) {
    _$activeAtom.reportWrite(value, super.active, () {
      super.active = value;
    });
  }

  final _$starredAtom = Atom(name: '_MyQuestStore.starred');

  @override
  ObservableList<BaseQuestResponse>? get starred {
    _$starredAtom.reportRead();
    return super.starred;
  }

  @override
  set starred(ObservableList<BaseQuestResponse>? value) {
    _$starredAtom.reportWrite(value, super.starred, () {
      super.starred = value;
    });
  }

  final _$performedAtom = Atom(name: '_MyQuestStore.performed');

  @override
  ObservableList<BaseQuestResponse>? get performed {
    _$performedAtom.reportRead();
    return super.performed;
  }

  @override
  set performed(ObservableList<BaseQuestResponse>? value) {
    _$performedAtom.reportWrite(value, super.performed, () {
      super.performed = value;
    });
  }

  final _$requestedAtom = Atom(name: '_MyQuestStore.requested');

  @override
  ObservableList<BaseQuestResponse>? get requested {
    _$requestedAtom.reportRead();
    return super.requested;
  }

  @override
  set requested(ObservableList<BaseQuestResponse>? value) {
    _$requestedAtom.reportWrite(value, super.requested, () {
      super.requested = value;
    });
  }

  final _$respondedAtom = Atom(name: '_MyQuestStore.responded');

  @override
  ObservableList<Responded?>? get responded {
    _$respondedAtom.reportRead();
    return super.responded;
  }

  @override
  set responded(ObservableList<Responded?>? value) {
    _$respondedAtom.reportWrite(value, super.responded, () {
      super.responded = value;
    });
  }

  final _$invitedAtom = Atom(name: '_MyQuestStore.invited');

  @override
  ObservableList<BaseQuestResponse>? get invited {
    _$invitedAtom.reportRead();
    return super.invited;
  }

  @override
  set invited(ObservableList<BaseQuestResponse>? value) {
    _$invitedAtom.reportWrite(value, super.invited, () {
      super.invited = value;
    });
  }

  final _$iconsMarkerAtom = Atom(name: '_MyQuestStore.iconsMarker');

  @override
  List<BitmapDescriptor> get iconsMarker {
    _$iconsMarkerAtom.reportRead();
    return super.iconsMarker;
  }

  @override
  set iconsMarker(List<BitmapDescriptor> value) {
    _$iconsMarkerAtom.reportWrite(value, super.iconsMarker, () {
      super.iconsMarker = value;
    });
  }

  final _$selectQuestInfoAtom = Atom(name: '_MyQuestStore.selectQuestInfo');

  @override
  BaseQuestResponse? get selectQuestInfo {
    _$selectQuestInfoAtom.reportRead();
    return super.selectQuestInfo;
  }

  @override
  set selectQuestInfo(BaseQuestResponse? value) {
    _$selectQuestInfoAtom.reportWrite(value, super.selectQuestInfo, () {
      super.selectQuestInfo = value;
    });
  }

  final _$getQuestsAsyncAction = AsyncAction('_MyQuestStore.getQuests');

  @override
  Future<dynamic> getQuests(String userId, UserRole role) {
    return _$getQuestsAsyncAction.run(() => super.getQuests(userId, role));
  }

  @override
  String toString() {
    return '''
sort: ${sort},
priority: ${priority},
offset: ${offset},
limit: ${limit},
status: ${status},
active: ${active},
starred: ${starred},
performed: ${performed},
requested: ${requested},
responded: ${responded},
invited: ${invited},
iconsMarker: ${iconsMarker},
selectQuestInfo: ${selectQuestInfo}
    ''';
  }
}
