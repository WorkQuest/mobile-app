// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_me_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProfileMeStore on _ProfileMeStore, Store {
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

  @override
  String toString() {
    return '''
priorityValue: ${priorityValue},
distantWork: ${distantWork},
wagePerHour: ${wagePerHour}
    ''';
  }
}
