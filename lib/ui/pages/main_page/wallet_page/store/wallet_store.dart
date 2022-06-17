import 'package:app/web3/contractEnums.dart';
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
  TYPE_COINS type = TYPE_COINS.WQT;

  @action
  setType(TYPE_COINS value) => type = value;

  @observable
  ObservableList<_CoinEntity> coins = ObservableList.of([]);

  @observable
  bool isLoadingTest = false;

  @observable
  String errorTest = '';

  @action
  getCoins({bool isForce = true}) async {
    if (isForce) {
      onLoading();
    }
    try {
      final addresses = Configs.configsNetwork[AccountRepository().configName]!.addresses;

      final _balance = await AccountRepository().service!.getBalance(AccountRepository().privateKey);
      final wqt = _balance.getInEther;
      final wUsd = await AccountRepository().service!.getBalanceFromContract(addresses.wUsd);
      final wEth = await AccountRepository().service!.getBalanceFromContract(addresses.wEth);
      final wBnb = await AccountRepository().service!.getBalanceFromContract(addresses.wBnb);
      final uSdt = await AccountRepository().service!.getBalanceFromContract(addresses.uSdt);

      List<_CoinEntity> _listCoins = []
        ..add(_CoinEntity("WQT", wqt.toString()))
        ..add(_CoinEntity("WUSD", wUsd.toString()))
        ..add(_CoinEntity("wBNB", wBnb.toString()))
        ..add(_CoinEntity("wETH", wEth.toString()))
        ..add(_CoinEntity("USDT", uSdt.toString()));

      _setCoins(_listCoins);

      if (isForce) {
        onSuccess(true);
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  _setCoins(List<_CoinEntity> listCoins) {
    if (coins.isNotEmpty) {
      final _indexWQT = coins.indexWhere((coin) => coin.title == 'WQT');
      coins[_indexWQT] = listCoins.firstWhere((coin) => coin.title == 'WQT');

      final _indexWUSD = coins.indexWhere((coin) => coin.title == 'WUSD');
      coins[_indexWUSD] = listCoins.firstWhere((coin) => coin.title == 'WUSD');

      final _indexWBNB = coins.indexWhere((coin) => coin.title == 'wBNB');
      coins[_indexWBNB] = listCoins.firstWhere((coin) => coin.title == 'wBNB');

      final _indexWETH = coins.indexWhere((coin) => coin.title == 'wETH');
      coins[_indexWETH] = listCoins.firstWhere((coin) => coin.title == 'wETH');

      final _indexUSDT = coins.indexWhere((coin) => coin.title == 'USDT');
      coins[_indexUSDT] = listCoins.firstWhere((coin) => coin.title == 'USDT');
    } else {
      coins.addAll(listCoins);
    }
  }

// @action
// getTestCoinsWUSD() async {
//   errorTest = '';
//   try {
//     isLoadingTest = true;
//     // await Future.delayed(const Duration(seconds: 2));
//     await _apiProvider.getTestCoinsWUSD();
//   } catch (e) {
//     errorTest = e.toString();
//   }
//   isLoadingTest = false;
// }
//
// @action
// getTestCoinsWQT() async {
//   errorTest = '';
//   try {
//     isLoadingTest = true;
//     // await Future.delayed(const Duration(seconds: 2));
//     await _apiProvider.getTestCoinsWQT();
//   } catch (e) {
//     errorTest = e.toString();
//   }
//   isLoadingTest = false;
// }
}

class _CoinEntity {
  final String title;
  final String amount;

  const _CoinEntity(this.title, this.amount);
}
