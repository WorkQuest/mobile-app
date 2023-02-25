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

  @action
  getCoins({bool isForce = true}) async {
    if (isForce) {
      onLoading();
    }
    try {
      final list =
          await ClientService().getAllBalance(AccountRepository().privateKey);
      print(list);
      final ether = list.firstWhere((element) => element.title == 'ether');
      print('address: ${AccountRepository().userAddresses!.first.address!}');
      final wqt = await ClientService()
          .getBalanceFromContract(AddressCoins.wqt);
      final wEth = await ClientService()
          .getBalanceFromContract(AddressCoins.wEth);
      final wBnb = await ClientService()
          .getBalanceFromContract(AddressCoins.wBnb);
      print('wqt: $wqt');
      print('wEth: $wEth');
      print('wBnb: $wBnb');
      if (coins.isNotEmpty) {
        coins[0].amount = ether.amount;
        coins[1].amount = wqt.toString();
        coins[2].amount = wBnb.toString();
        coins[3].amount =  wEth.toString();
      } else {
        coins.addAll([
          BalanceItem(
            "WUSD",
            ether.amount,
          ),
          BalanceItem(
            "WQT",
            wqt.toString(),
          ),
          BalanceItem(
            "BNB",
            wBnb.toString(),
          ),
          BalanceItem(
            "ETH",
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

}
