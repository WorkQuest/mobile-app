import 'dart:math';

import 'package:app/web3/repository/account_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/base_store/i_store.dart';

import '../../../../../constants.dart';

part 'wallet_store.g.dart';

@singleton
class WalletStore extends _WalletStore with _$WalletStore {
  WalletStore();
}

abstract class _WalletStore extends IStore<bool> with Store {
  @observable
  TokenSymbols type = TokenSymbols.WQT;

  @observable
  ObservableList<_CoinEntity> coins = ObservableList.of([]);

  @observable
  bool isLoadingTest = false;

  @observable
  String errorTest = '';

  @action
  setType(TokenSymbols value) => type = value;

  @action
  getCoins({bool isForce = true}) async {
    if (isForce) {
      onLoading();
    }
    try {
      final _tokens = Configs.configsNetwork[AccountRepository().networkName.value]!.dataCoins;
      final _listCoinsEntity = await _getCoinEntities(_tokens);
      if (isForce) {
        coins.clear();
      }
      _setCoins(_listCoinsEntity);
      if (isForce) {
        onSuccess(true);
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  _setCoins(List<_CoinEntity> listCoins) {
    if (coins.isNotEmpty) {
      coins.map((element) {
        element.amount = listCoins.firstWhere((element) => element.symbol == element.symbol).amount;
      }).toList();
    } else {
      coins.addAll(listCoins);
    }
  }

  Future<List<_CoinEntity>> _getCoinEntities(List<DataCoins> coins) async {
    List<_CoinEntity> _result = [];
    final _client = AccountRepository().getClient();
    await Stream.fromIterable(coins).asyncMap((coin) async {
      if (coin.addressToken == null) {
        final _balance = await _client.getBalance(AccountRepository().privateKey);
        final _amount = (_balance.getInWei.toDouble() * pow(10, -18)).toStringAsFixed(8);
        _result.add(_CoinEntity(coin.symbolToken, _amount));
      } else {
        final _amount =
            await _client.getBalanceFromContract(coin.addressToken!, isUSDT: coin.symbolToken == TokenSymbols.USDT);
        _result.add(_CoinEntity(coin.symbolToken, _amount.toString()));
      }
    }).toList();

    return _result;
  }

  @action
  clearData() {
    coins.clear();
    type = TokenSymbols.WQT;
  }
}

class _CoinEntity {
  final TokenSymbols symbol;
  String? amount;

  _CoinEntity(this.symbol, [this.amount]);
}
