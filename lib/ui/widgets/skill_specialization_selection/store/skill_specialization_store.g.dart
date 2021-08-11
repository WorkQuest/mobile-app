// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill_specialization_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SkillSpecializationStore on SkillSpecializationStoreBase, Store {
  final _$isLoadingAtom = Atom(name: 'SkillSpecializationStoreBase.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$specializationAtom =
      Atom(name: 'SkillSpecializationStoreBase.specialization');

  @override
  List<FilterItem> get specialization {
    _$specializationAtom.reportRead();
    return super.specialization;
  }

  @override
  set specialization(List<FilterItem> value) {
    _$specializationAtom.reportWrite(value, super.specialization, () {
      super.specialization = value;
    });
  }

  final _$selectSpecializationsAtom =
      Atom(name: 'SkillSpecializationStoreBase.selectSpecializations');

  @override
  Map<int, FilterItem> get selectSpecializations {
    _$selectSpecializationsAtom.reportRead();
    return super.selectSpecializations;
  }

  @override
  set selectSpecializations(Map<int, FilterItem> value) {
    _$selectSpecializationsAtom.reportWrite(value, super.selectSpecializations,
        () {
      super.selectSpecializations = value;
    });
  }

  final _$selectSkillsAtom =
      Atom(name: 'SkillSpecializationStoreBase.selectSkills');

  @override
  Map<int, List<String>> get selectSkills {
    _$selectSkillsAtom.reportRead();
    return super.selectSkills;
  }

  @override
  set selectSkills(Map<int, List<String>> value) {
    _$selectSkillsAtom.reportWrite(value, super.selectSkills, () {
      super.selectSkills = value;
    });
  }

  final _$readFiltersAsyncAction =
      AsyncAction('SkillSpecializationStoreBase.readFilters');

  @override
  Future<dynamic> readFilters() {
    return _$readFiltersAsyncAction.run(() => super.readFilters());
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
specialization: ${specialization},
selectSpecializations: ${selectSpecializations},
selectSkills: ${selectSkills}
    ''';
  }
}
