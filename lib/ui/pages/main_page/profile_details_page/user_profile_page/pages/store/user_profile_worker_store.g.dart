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

  final _$_UserProfileWorkerStoreActionController =
      ActionController(name: '_UserProfileWorkerStore');

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
allSpices: ${allSpices}
    ''';
  }
}
