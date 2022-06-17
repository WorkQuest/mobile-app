// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swap_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SwapStore on SwapStoreBase, Store {
  final _$networkAtom = Atom(name: 'SwapStoreBase.network');

  @override
  SwapNetworks? get network {
    _$networkAtom.reportRead();
    return super.network;
  }

  @override
  set network(SwapNetworks? value) {
    _$networkAtom.reportWrite(value, super.network, () {
      super.network = value;
    });
  }

  final _$tokenAtom = Atom(name: 'SwapStoreBase.token');

  @override
  SwapToken get token {
    _$tokenAtom.reportRead();
    return super.token;
  }

  @override
  set token(SwapToken value) {
    _$tokenAtom.reportWrite(value, super.token, () {
      super.token = value;
    });
  }

  final _$amountAtom = Atom(name: 'SwapStoreBase.amount');

  @override
  double get amount {
    _$amountAtom.reportRead();
    return super.amount;
  }

  @override
  set amount(double value) {
    _$amountAtom.reportWrite(value, super.amount, () {
      super.amount = value;
    });
  }

  final _$maxAmountAtom = Atom(name: 'SwapStoreBase.maxAmount');

  @override
  double? get maxAmount {
    _$maxAmountAtom.reportRead();
    return super.maxAmount;
  }

  @override
  set maxAmount(double? value) {
    _$maxAmountAtom.reportWrite(value, super.maxAmount, () {
      super.maxAmount = value;
    });
  }

  final _$isConnectAtom = Atom(name: 'SwapStoreBase.isConnect');

  @override
  bool get isConnect {
    _$isConnectAtom.reportRead();
    return super.isConnect;
  }

  @override
  set isConnect(bool value) {
    _$isConnectAtom.reportWrite(value, super.isConnect, () {
      super.isConnect = value;
    });
  }

  final _$convertWQTAtom = Atom(name: 'SwapStoreBase.convertWQT');

  @override
  double? get convertWQT {
    _$convertWQTAtom.reportRead();
    return super.convertWQT;
  }

  @override
  set convertWQT(double? value) {
    _$convertWQTAtom.reportWrite(value, super.convertWQT, () {
      super.convertWQT = value;
    });
  }

  final _$isLoadingCourseAtom = Atom(name: 'SwapStoreBase.isLoadingCourse');

  @override
  bool get isLoadingCourse {
    _$isLoadingCourseAtom.reportRead();
    return super.isLoadingCourse;
  }

  @override
  set isLoadingCourse(bool value) {
    _$isLoadingCourseAtom.reportWrite(value, super.isLoadingCourse, () {
      super.isLoadingCourse = value;
    });
  }

  final _$isSuccessCourseAtom = Atom(name: 'SwapStoreBase.isSuccessCourse');

  @override
  bool get isSuccessCourse {
    _$isSuccessCourseAtom.reportRead();
    return super.isSuccessCourse;
  }

  @override
  set isSuccessCourse(bool value) {
    _$isSuccessCourseAtom.reportWrite(value, super.isSuccessCourse, () {
      super.isSuccessCourse = value;
    });
  }

  final _$setNetworkAsyncAction = AsyncAction('SwapStoreBase.setNetwork');

  @override
  Future setNetwork(SwapNetworks value) {
    return _$setNetworkAsyncAction.run(() => super.setNetwork(value));
  }

  final _$getMaxBalanceAsyncAction = AsyncAction('SwapStoreBase.getMaxBalance');

  @override
  Future getMaxBalance() {
    return _$getMaxBalanceAsyncAction.run(() => super.getMaxBalance());
  }

  final _$getCourseWQTAsyncAction = AsyncAction('SwapStoreBase.getCourseWQT');

  @override
  Future getCourseWQT({bool isForce = false}) {
    return _$getCourseWQTAsyncAction
        .run(() => super.getCourseWQT(isForce: isForce));
  }

  final _$createSwapAsyncAction = AsyncAction('SwapStoreBase.createSwap');

  @override
  Future createSwap(String address) {
    return _$createSwapAsyncAction.run(() => super.createSwap(address));
  }

  final _$SwapStoreBaseActionController =
      ActionController(name: 'SwapStoreBase');

  @override
  dynamic setToken(SwapToken value) {
    final _$actionInfo = _$SwapStoreBaseActionController.startAction(
        name: 'SwapStoreBase.setToken');
    try {
      return super.setToken(value);
    } finally {
      _$SwapStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setAmount(double value) {
    final _$actionInfo = _$SwapStoreBaseActionController.startAction(
        name: 'SwapStoreBase.setAmount');
    try {
      return super.setAmount(value);
    } finally {
      _$SwapStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
network: ${network},
token: ${token},
amount: ${amount},
maxAmount: ${maxAmount},
isConnect: ${isConnect},
convertWQT: ${convertWQT},
isLoadingCourse: ${isLoadingCourse},
isSuccessCourse: ${isSuccessCourse}
    ''';
  }
}
