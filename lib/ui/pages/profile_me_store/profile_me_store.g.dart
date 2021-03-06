// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_me_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProfileMeStore on _ProfileMeStore, Store {
  final _$questHolderAtom = Atom(name: '_ProfileMeStore.questHolder');

  @override
  ProfileMeResponse? get questHolder {
    _$questHolderAtom.reportRead();
    return super.questHolder;
  }

  @override
  set questHolder(ProfileMeResponse? value) {
    _$questHolderAtom.reportWrite(value, super.questHolder, () {
      super.questHolder = value;
    });
  }

  final _$reviewAtom = Atom(name: '_ProfileMeStore.review');

  @override
  bool get review {
    _$reviewAtom.reportRead();
    return super.review;
  }

  @override
  set review(bool value) {
    _$reviewAtom.reportWrite(value, super.review, () {
      super.review = value;
    });
  }

  final _$priorityValueAtom = Atom(name: '_ProfileMeStore.priorityValue');

  @override
  QuestPriority get priorityValue {
    _$priorityValueAtom.reportRead();
    return super.priorityValue;
  }

  @override
  set priorityValue(QuestPriority value) {
    _$priorityValueAtom.reportWrite(value, super.priorityValue, () {
      super.priorityValue = value;
    });
  }

  final _$questsAtom = Atom(name: '_ProfileMeStore.quests');

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

  @override
  String toString() {
    return '''
questHolder: ${questHolder},
review: ${review},
priorityValue: ${priorityValue},
quests: ${quests},
distantWork: ${distantWork},
wagePerHour: ${wagePerHour}
    ''';
  }
}
