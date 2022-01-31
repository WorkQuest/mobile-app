// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$WalletStore on _WalletStore, Store {
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

  final _$transactionsAtom = Atom(name: '_WalletStore.transactions');

  @override
  ObservableList<Tx> get transactions {
    _$transactionsAtom.reportRead();
    return super.transactions;
  }

  @override
  set transactions(ObservableList<Tx> value) {
    _$transactionsAtom.reportWrite(value, super.transactions, () {
      super.transactions = value;
    });
  }

  final _$isMoreLoadingAtom = Atom(name: '_WalletStore.isMoreLoading');

  @override
  bool get isMoreLoading {
    _$isMoreLoadingAtom.reportRead();
    return super.isMoreLoading;
  }

  @override
  set isMoreLoading(bool value) {
    _$isMoreLoadingAtom.reportWrite(value, super.isMoreLoading, () {
      super.isMoreLoading = value;
    });
  }

  final _$getCoinsAsyncAction = AsyncAction('_WalletStore.getCoins');

  @override
  Future getCoins() {
    return _$getCoinsAsyncAction.run(() => super.getCoins());
  }

  final _$getTransactionsAsyncAction =
      AsyncAction('_WalletStore.getTransactions');

  @override
  Future getTransactions({bool isForce = false}) {
    return _$getTransactionsAsyncAction
        .run(() => super.getTransactions(isForce: isForce));
  }

  @override
  String toString() {
    return '''
coins: ${coins},
transactions: ${transactions},
isMoreLoading: ${isMoreLoading}
    ''';
  }
}
