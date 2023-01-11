// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_worker_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserProfileWorkerStore on _UserProfileWorkerStore, Store {
  final _$allSpicesAtom = Atom(name: '_UserProfileWorkerStore.allSpices');

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

  final _$expandedSkillsAtom =
      Atom(name: '_UserProfileWorkerStore.expandedSkills');

  @override
  bool get expandedSkills {
    _$expandedSkillsAtom.reportRead();
    return super.expandedSkills;
  }

  @override
  set expandedSkills(bool value) {
    _$expandedSkillsAtom.reportWrite(value, super.expandedSkills, () {
      super.expandedSkills = value;
    });
  }

  final _$expandedDescriptionAtom =
      Atom(name: '_UserProfileWorkerStore.expandedDescription');

  @override
  bool get expandedDescription {
    _$expandedDescriptionAtom.reportRead();
    return super.expandedDescription;
  }

  @override
  set expandedDescription(bool value) {
    _$expandedDescriptionAtom.reportWrite(value, super.expandedDescription, () {
      super.expandedDescription = value;
    });
  }

  final _$_UserProfileWorkerStoreActionController =
      ActionController(name: '_UserProfileWorkerStore');

  @override
  dynamic setExpandedSkills(bool value) {
    final _$actionInfo = _$_UserProfileWorkerStoreActionController.startAction(
        name: '_UserProfileWorkerStore.setExpandedSkills');
    try {
      return super.setExpandedSkills(value);
    } finally {
      _$_UserProfileWorkerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setExpandedDescription(bool value) {
    final _$actionInfo = _$_UserProfileWorkerStoreActionController.startAction(
        name: '_UserProfileWorkerStore.setExpandedDescription');
    try {
      return super.setExpandedDescription(value);
    } finally {
      _$_UserProfileWorkerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  List<String> parser(List<String> skills) {
    final _$actionInfo = _$_UserProfileWorkerStoreActionController.startAction(
        name: '_UserProfileWorkerStore.parser');
    try {
      return super.parser(skills);
    } finally {
      _$_UserProfileWorkerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
allSpices: ${allSpices},
expandedSkills: ${expandedSkills},
expandedDescription: ${expandedDescription}
    ''';
  }
}
