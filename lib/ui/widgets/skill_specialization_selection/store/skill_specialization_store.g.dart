// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill_specialization_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SkillSpecializationStore on SkillSpecializationStoreBase, Store {
  final _$numberOfSpicesAtom =
      Atom(name: 'SkillSpecializationStoreBase.numberOfSpices');

  @override
  int get numberOfSpices {
    _$numberOfSpicesAtom.reportRead();
    return super.numberOfSpices;
  }

  @override
  set numberOfSpices(int value) {
    _$numberOfSpicesAtom.reportWrite(value, super.numberOfSpices, () {
      super.numberOfSpices = value;
    });
  }

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
  List<Specialization> get specialization {
    _$specializationAtom.reportRead();
    return super.specialization;
  }

  @override
  set specialization(List<Specialization> value) {
    _$specializationAtom.reportWrite(value, super.specialization, () {
      super.specialization = value;
    });
  }

  final _$selectSpecializationsAtom =
      Atom(name: 'SkillSpecializationStoreBase.selectSpecializations');

  @override
  Map<int, Specialization> get selectSpecializations {
    _$selectSpecializationsAtom.reportRead();
    return super.selectSpecializations;
  }

  @override
  set selectSpecializations(Map<int, Specialization> value) {
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

  final _$readSpecializationAsyncAction =
      AsyncAction('SkillSpecializationStoreBase.readSpecialization');

  @override
  Future<dynamic> readSpecialization() {
    return _$readSpecializationAsyncAction
        .run(() => super.readSpecialization());
  }

  final _$SkillSpecializationStoreBaseActionController =
      ActionController(name: 'SkillSpecializationStoreBase');

  @override
  dynamic addSpices() {
    final _$actionInfo = _$SkillSpecializationStoreBaseActionController
        .startAction(name: 'SkillSpecializationStoreBase.addSpices');
    try {
      return super.addSpices();
    } finally {
      _$SkillSpecializationStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic deleteSpices() {
    final _$actionInfo = _$SkillSpecializationStoreBaseActionController
        .startAction(name: 'SkillSpecializationStoreBase.deleteSpices');
    try {
      return super.deleteSpices();
    } finally {
      _$SkillSpecializationStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
numberOfSpices: ${numberOfSpices},
isLoading: ${isLoading},
specialization: ${specialization},
selectSpecializations: ${selectSpecializations},
selectSkills: ${selectSkills}
    ''';
  }
}
