// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_me_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProfileMeStore on _ProfileMeStore, Store {
  final _$questsListAtom = Atom(name: '_ProfileMeStore.questsList');

  @override
  List<QuestsResponse>? get questsList {
    _$questsListAtom.reportRead();
    return super.questsList;
  }

  @override
  set questsList(List<QuestsResponse>? value) {
    _$questsListAtom.reportWrite(value, super.questsList, () {
      super.questsList = value;
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
questsList: ${questsList}
    ''';
  }
}
