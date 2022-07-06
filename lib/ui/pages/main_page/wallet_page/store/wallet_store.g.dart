// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$WalletStore on _WalletStore, Store {
  final _$typeAtom = Atom(name: '_WalletStore.type');

  @override
  TokenSymbols get type {
    _$typeAtom.reportRead();
    return super.type;
  }

  @override
  set type(TokenSymbols value) {
    _$typeAtom.reportWrite(value, super.type, () {
      super.type = value;
    });
  }

  final _$coinsAtom = Atom(name: '_WalletStore.coins');

  @override
  ObservableList<_CoinEntity> get coins {
    _$coinsAtom.reportRead();
    return super.coins;
  }

  @override
  set coins(ObservableList<_CoinEntity> value) {
    _$coinsAtom.reportWrite(value, super.coins, () {
      super.coins = value;
    });
  }

  final _$isLoadingTestAtom = Atom(name: '_WalletStore.isLoadingTest');

  @override
  bool get isLoadingTest {
    _$isLoadingTestAtom.reportRead();
    return super.isLoadingTest;
  }

  @override
  set isLoadingTest(bool value) {
    _$isLoadingTestAtom.reportWrite(value, super.isLoadingTest, () {
      super.isLoadingTest = value;
    });
  }

  final _$errorTestAtom = Atom(name: '_WalletStore.errorTest');

  @override
  String get errorTest {
    _$errorTestAtom.reportRead();
    return super.errorTest;
  }

  @override
  set errorTest(String value) {
    _$errorTestAtom.reportWrite(value, super.errorTest, () {
      super.errorTest = value;
    });
  }

  final _$getCoinsAsyncAction = AsyncAction('_WalletStore.getCoins');

  @override
  Future getCoins({bool isForce = true}) {
    return _$getCoinsAsyncAction.run(() => super.getCoins(isForce: isForce));
  }

  final _$_WalletStoreActionController = ActionController(name: '_WalletStore');

  @override
  dynamic setType(TokenSymbols value) {
    final _$actionInfo = _$_WalletStoreActionController.startAction(
        name: '_WalletStore.setType');
    try {
      return super.setType(value);
    } finally {
      _$_WalletStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic clearData() {
    final _$actionInfo = _$_WalletStoreActionController.startAction(
        name: '_WalletStore.clearData');
    try {
      return super.clearData();
    } finally {
      _$_WalletStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
type: ${type},
coins: ${coins},
isLoadingTest: ${isLoadingTest},
errorTest: ${errorTest}
    ''';
  }
}
