import 'dart:io';
import 'package:app/ui/pages/main_page/wallet_page/store/wallet_store.dart';
import 'package:app/web3/contractEnums.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:app/base_store/i_store.dart';

part 'confirm_transfer_store.g.dart';

class ConfirmTransferStore = ConfirmTransferStoreBase
    with _$ConfirmTransferStore;

abstract class ConfirmTransferStoreBase extends IStore<bool> with Store {
  @action
  sendTransaction(String addressTo, String amount, String titleCoin) async {
    onLoading();
    try {
      print("privatekey: ${AccountRepository().privateKey}");
      await AccountRepository().client!.sendTransaction(
            privateKey: AccountRepository().privateKey,
            address: addressTo,
            amount: amount,
            coin: _getType(titleCoin),
          );
      GetIt.I.get<WalletStore>().getCoins();
      GetIt.I.get<WalletStore>().getTransactions(isForce: true);
      onSuccess(true);
    } on SocketException catch (_) {
      onError("Lost connection to server");
    } catch (e) {
      onError(e.toString());
    }
  }

  TYPE_COINS _getType(String title) {
    switch (title) {
      case "WUSD":
        return TYPE_COINS.wusd;
      case "WQT":
        return TYPE_COINS.wqt;
      default:
        return TYPE_COINS.wqt;
    }
  }
}
