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

  final _$countSkillsAtom =
      Atom(name: 'SkillSpecializationStoreBase.countSkills');

  @override
  bool get countSkills {
    _$countSkillsAtom.reportRead();
    return super.countSkills;
  }

  @override
  set countSkills(bool value) {
    _$countSkillsAtom.reportWrite(value, super.countSkills, () {
      super.countSkills = value;
    });
  }

  final _$allSpicesAtom = Atom(name: 'SkillSpecializationStoreBase.allSpices');

  @override
  List<Specialization> get allSpices {
    _$allSpicesAtom.reportRead();
    return super.allSpices;
  }

  @override
  set allSpices(List<Specialization> value) {
    _$allSpicesAtom.reportWrite(value, super.allSpices, () {
      super.allSpices = value;
    });
  }

  final _$selectedSpicesAtom =
      Atom(name: 'SkillSpecializationStoreBase.selectedSpices');

  @override
  Map<int, Specialization> get selectedSpices {
    _$selectedSpicesAtom.reportRead();
    return super.selectedSpices;
  }

  @override
  set selectedSpices(Map<int, Specialization> value) {
    _$selectedSpicesAtom.reportWrite(value, super.selectedSpices, () {
      super.selectedSpices = value;
    });
  }

  final _$selectedSkillsAtom =
      Atom(name: 'SkillSpecializationStoreBase.selectedSkills');

  @override
  Map<int, List<String>> get selectedSkills {
    _$selectedSkillsAtom.reportRead();
    return super.selectedSkills;
  }

  @override
  set selectedSkills(Map<int, List<String>> value) {
    _$selectedSkillsAtom.reportWrite(value, super.selectedSkills, () {
      super.selectedSkills = value;
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
countSkills: ${countSkills},
allSpices: ${allSpices},
selectedSpices: ${selectedSpices},
selectedSkills: ${selectedSkills}
    ''';
  }
}
