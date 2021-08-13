// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_profile_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChangeProfileStore on ChangeProfileStoreBase, Store {
  final _$userDataAtom = Atom(name: 'ChangeProfileStoreBase.userData');

  @override
  ProfileMeResponse get userData {
    _$userDataAtom.reportRead();
    return super.userData;
  }

  @override
  set userData(ProfileMeResponse value) {
    _$userDataAtom.reportWrite(value, super.userData, () {
      super.userData = value;
    });
  }

  final _$mediaAtom = Atom(name: 'ChangeProfileStoreBase.media');

  @override
  DrishyaEntity? get media {
    _$mediaAtom.reportRead();
    return super.media;
  }

  @override
  set media(DrishyaEntity? value) {
    _$mediaAtom.reportWrite(value, super.media, () {
      super.media = value;
    });
  }

  @override
  String toString() {
    return '''
userData: ${userData},
media: ${media}
    ''';
  }
}
