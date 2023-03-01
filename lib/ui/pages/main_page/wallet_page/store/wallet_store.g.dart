// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$WalletStore on _WalletStore, Store {
  final _$currentTokenAtom = Atom(name: '_WalletStore.currentToken');

  @override
  TokenSymbols get currentToken {
    _$currentTokenAtom.reportRead();
    return super.currentToken;
  }

  @override
  set currentToken(TokenSymbols value) {
    _$currentTokenAtom.reportWrite(value, super.currentToken, () {
      super.currentToken = value;
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

  final _$getCoinsAsyncAction = AsyncAction('_WalletStore.getCoins');

  @override
  Future getCoins(
      {bool isForce = true, bool tryAgain = true, bool fromSwap = false}) {
    return _$getCoinsAsyncAction.run(() => super
        .getCoins(isForce: isForce, tryAgain: tryAgain, fromSwap: fromSwap));
  }

  final _$_WalletStoreActionController = ActionController(name: '_WalletStore');

  @override
  dynamic setCurrentToken(TokenSymbols value) {
    final _$actionInfo = _$_WalletStoreActionController.startAction(
        name: '_WalletStore.setCurrentToken');
    try {
      return super.setCurrentToken(value);
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
currentToken: ${currentToken},
coins: ${coins}
    ''';
  }
}
