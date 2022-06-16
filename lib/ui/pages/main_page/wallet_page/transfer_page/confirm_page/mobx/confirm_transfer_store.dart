import 'dart:io';
import 'dart:math';
import 'package:app/ui/pages/main_page/wallet_page/store/wallet_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/transactions/store/transactions_store.dart';
import 'package:app/web3/contractEnums.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/base_store/i_store.dart';
import 'package:web3dart/web3dart.dart';

part 'confirm_transfer_store.g.dart';

@injectable
class ConfirmTransferStore = ConfirmTransferStoreBase with _$ConfirmTransferStore;

abstract class ConfirmTransferStoreBase extends IStore<bool> with Store {
  @action
  sendTransaction(String addressTo, String amount, TYPE_COINS typeCoin) async {
    onLoading();
    try {
      await _checkPossibilityTx(typeCoin, double.parse(amount));
      await AccountRepository().service!.sendTransaction(
            privateKey: AccountRepository().privateKey,
            address: addressTo,
            amount: amount,
            coin: typeCoin,
          );
      GetIt.I.get<WalletStore>().getCoins();
      Future.delayed(const Duration(seconds: 2)).then((value) {
        GetIt.I.get<TransactionsStore>().getTransactions(isForce: true);
      });
      onSuccess(true);
    } on SocketException catch (_) {
      onError("Lost connection to server");
    } on FormatException catch (e) {
      onError(e.message);
    } catch (e) {
      onError(e.toString());
    }
  }

  _checkPossibilityTx(TYPE_COINS typeCoin, double amount) async {
    final _balanceWQT = await AccountRepository().service!.getBalance(AccountRepository().privateKey);
    final _gasTx = await AccountRepository().service!.getGas();

    if (typeCoin == TYPE_COINS.WQT) {
      final _gas = (_gasTx.getInWei.toDouble() * pow(10, -16) * 250);
      final _balanceWQTInWei = (_balanceWQT.getValueInUnitBI(EtherUnit.wei).toDouble() * pow(10, -18)).toDouble();
      if (amount > (_balanceWQTInWei.toDouble() - _gas)) {
        throw FormatException('Not have enough WQT for the transaction');
      }
    } else {
      if (_balanceWQT.getInWei < _gasTx.getInWei) {
        throw FormatException('Not have enough WQT for the transaction');
      }
    }
  }
}
