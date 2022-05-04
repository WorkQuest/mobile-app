import 'package:app/http/api_provider.dart';
import 'package:app/web3/contractEnums.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:app/web3/service/client_service.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/base_store/i_store.dart';

import '../../../../../constants.dart';

part 'wallet_store.g.dart';

@singleton
class WalletStore extends _WalletStore with _$WalletStore {
  WalletStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _WalletStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _WalletStore(this._apiProvider);

  @observable
  TYPE_COINS type = TYPE_COINS.WUSD;

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
          await ClientService().getAllBalance(AccountRepository().privateKey);
      print(list);
      final wqt = list.firstWhere((element) => element.title == 'ether');
      final wUsd =
          await ClientService().getBalanceFromContract(AddressCoins.wUsd);
      final wEth =
          await ClientService().getBalanceFromContract(AddressCoins.wEth);
      final wBnb =
          await ClientService().getBalanceFromContract(AddressCoins.wBnb);
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
        ]);
      }

      if (isForce) {
        onSuccess(true);
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  @action
  getTestCoinsWUSD() async {
    errorTest = '';
    try {
      isLoadingTest = true;
      // await Future.delayed(const Duration(seconds: 2));
      await _apiProvider.getTestCoinsWUSD();
    } catch (e) {
      errorTest = e.toString();
    }
    isLoadingTest = false;
  }

  @action
  getTestCoinsWQT() async {
    errorTest = '';
    try {
      isLoadingTest = true;
      // await Future.delayed(const Duration(seconds: 2));
      await _apiProvider.getTestCoinsWQT();
    } catch (e) {
      errorTest = e.toString();
    }
    isLoadingTest = false;
  }
}
