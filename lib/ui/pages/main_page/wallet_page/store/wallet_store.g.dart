// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$WalletStore on _WalletStore, Store {
  final _$typeAtom = Atom(name: '_WalletStore.type');

  @override
  TYPE_COINS get type {
    _$typeAtom.reportRead();
    return super.type;
  }

  @override
  set type(TYPE_COINS value) {
    _$typeAtom.reportWrite(value, super.type, () {
      super.type = value;
    });
  }

  final _$coinsAtom = Atom(name: '_WalletStore.coins');

  @override
  ObservableList<BalanceItem> get coins {
    _$coinsAtom.reportRead();
    return super.coins;
  }

  @override
  set coins(ObservableList<BalanceItem> value) {
    _$coinsAtom.reportWrite(value, super.coins, () {
      super.coins = value;
    });
  }

  final _$getCoinsAsyncAction = AsyncAction('_WalletStore.getCoins');

  @override
  Future getCoins({bool isForce = true}) {
    return _$getCoinsAsyncAction.run(() => super.getCoins(isForce: isForce));
  }

  final _$_WalletStoreActionController = ActionController(name: '_WalletStore');

  @override
  dynamic setType(TYPE_COINS value) {
    final _$actionInfo = _$_WalletStoreActionController.startAction(
        name: '_WalletStore.setType');
    try {
      return super.setType(value);
    } finally {
      _$_WalletStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
type: ${type},
coins: ${coins}
    ''';
  }
}