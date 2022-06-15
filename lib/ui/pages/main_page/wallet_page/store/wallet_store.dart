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
  ObservableList<BalanceItem> coins = ObservableList.of([]);

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
      final list =
      await AccountRepository().service!.getAllBalance(AccountRepository().privateKey);
      print(list);
      final addresses = Configs.configsNetwork[AccountRepository().configName]!.addresses;

      final wqt = list.firstWhere((element) => element.title == 'ether');
      final wUsd = await AccountRepository().service!.getBalanceFromContract(addresses.wUsd);
      final wEth = await AccountRepository().service!.getBalanceFromContract(addresses.wEth);
      final wBnb = await AccountRepository().service!.getBalanceFromContract(addresses.wBnb);
      final uSdt = await AccountRepository().service!.getBalanceFromContract(addresses.uSdt);
      if (coins.isNotEmpty) {
        coins[0] = BalanceItem(
          "WQT",
          wqt.amount,
        );
        coins[1] = BalanceItem(
          "WUSD",
          wUsd.toString(),
        );
        coins[2] = BalanceItem(
          "wBNB",
          wBnb.toString(),
        );
        coins[3] = BalanceItem(
          "wETH",
          wEth.toString(),
        );
        coins[4] = BalanceItem(
          "USDT",
          uSdt.toString(),
        );
      } else {
        coins.addAll([
          BalanceItem(
            "WQT",
            wqt.amount,
          ),
          BalanceItem(
            "WUSD",
            wUsd.toString(),
          ),
          BalanceItem(
            "wBNB",
            wBnb.toString(),
          ),
          BalanceItem(
            "wETH",
            wEth.toString(),
          ),
          BalanceItem(
            "USDT",
            uSdt.toString(),
          ),
        ]);
      }

      if (isForce) {
        onSuccess(true);
      }
    } catch (e) {
      onError(e.toString());
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
