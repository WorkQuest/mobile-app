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
  File? get media {
    _$mediaAtom.reportRead();
    return super.media;
  }

  @override
  set media(File? value) {
    _$mediaAtom.reportWrite(value, super.media, () {
      super.media = value;
    });
  }

  final _$addressAtom = Atom(name: 'ChangeProfileStoreBase.address');

  @override
  String get address {
    _$addressAtom.reportRead();
    return super.address;
  }

  @override
  set address(String value) {
    _$addressAtom.reportWrite(value, super.address, () {
      super.address = value;
    });
  }

  final _$phoneNumberAtom = Atom(name: 'ChangeProfileStoreBase.phoneNumber');

  @override
  PhoneNumber? get phoneNumber {
    _$phoneNumberAtom.reportRead();
    return super.phoneNumber;
  }

  @override
  set phoneNumber(PhoneNumber? value) {
    _$phoneNumberAtom.reportWrite(value, super.phoneNumber, () {
      super.phoneNumber = value;
    });
  }

  final _$secondPhoneNumberAtom =
      Atom(name: 'ChangeProfileStoreBase.secondPhoneNumber');

  @override
  PhoneNumber? get secondPhoneNumber {
    _$secondPhoneNumberAtom.reportRead();
    return super.secondPhoneNumber;
  }

  @override
  set secondPhoneNumber(PhoneNumber? value) {
    _$secondPhoneNumberAtom.reportWrite(value, super.secondPhoneNumber, () {
      super.secondPhoneNumber = value;
    });
  }

  final _$oldPhoneNumberAtom =
      Atom(name: 'ChangeProfileStoreBase.oldPhoneNumber');

  @override
  PhoneNumber? get oldPhoneNumber {
    _$oldPhoneNumberAtom.reportRead();
    return super.oldPhoneNumber;
  }

  @override
  set oldPhoneNumber(PhoneNumber? value) {
    _$oldPhoneNumberAtom.reportWrite(value, super.oldPhoneNumber, () {
      super.oldPhoneNumber = value;
    });
  }

  final _$getPredictionAsyncAction =
      AsyncAction('ChangeProfileStoreBase.getPrediction');

  @override
  Future<Null> getPrediction(BuildContext context) {
    return _$getPredictionAsyncAction.run(() => super.getPrediction(context));
  }

  final _$getInitCodeAsyncAction =
      AsyncAction('ChangeProfileStoreBase.getInitCode');

  @override
  Future<void> getInitCode(Phone firstPhone, Phone? secondPhone) {
    return _$getInitCodeAsyncAction
        .run(() => super.getInitCode(firstPhone, secondPhone));
  }

  final _$displayPredictionAsyncAction =
      AsyncAction('ChangeProfileStoreBase.displayPrediction');

  @override
  Future<Null> displayPrediction(String? p) {
    return _$displayPredictionAsyncAction.run(() => super.displayPrediction(p));
  }

  final _$ChangeProfileStoreBaseActionController =
      ActionController(name: 'ChangeProfileStoreBase');

  @override
  dynamic setUserData(ProfileMeResponse value) {
    final _$actionInfo = _$ChangeProfileStoreBaseActionController.startAction(
        name: 'ChangeProfileStoreBase.setUserData');
    try {
      return super.setUserData(value);
    } finally {
      _$ChangeProfileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setPhoneNumber(PhoneNumber phone) {
    final _$actionInfo = _$ChangeProfileStoreBaseActionController.startAction(
        name: 'ChangeProfileStoreBase.setPhoneNumber');
    try {
      return super.setPhoneNumber(phone);
    } finally {
      _$ChangeProfileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setSecondPhoneNumber(PhoneNumber phone) {
    final _$actionInfo = _$ChangeProfileStoreBaseActionController.startAction(
        name: 'ChangeProfileStoreBase.setSecondPhoneNumber');
    try {
      return super.setSecondPhoneNumber(phone);
    } finally {
      _$ChangeProfileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
userData: ${userData},
media: ${media},
address: ${address},
phoneNumber: ${phoneNumber},
secondPhoneNumber: ${secondPhoneNumber},
oldPhoneNumber: ${oldPhoneNumber}
    ''';
  }
}
