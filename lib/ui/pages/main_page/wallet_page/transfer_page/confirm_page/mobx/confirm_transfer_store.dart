import 'dart:io';
import 'package:app/constants.dart';
import 'package:app/ui/pages/main_page/wallet_page/store/wallet_store.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:decimal/decimal.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/base_store/i_store.dart';
import 'package:web3dart/json_rpc.dart';

part 'confirm_transfer_store.g.dart';

@injectable
class ConfirmTransferStore = ConfirmTransferStoreBase with _$ConfirmTransferStore;

abstract class ConfirmTransferStoreBase extends IStore<bool> with Store {
  @action
  sendTransaction(String addressTo, String amount, TokenSymbols typeCoin, Decimal fee) async {
    onLoading();
    try {
      final _currentListTokens = AccountRepository().getConfigNetwork().dataCoins;
      final _isToken = typeCoin != _currentListTokens.first.symbolToken;
      await Web3Utils.checkPossibilityTx(typeCoin: typeCoin, amount: double.parse(amount), fee: fee);
      await AccountRepository().client!.sendTransaction(
        isToken: _isToken,
        addressTo: addressTo,
        amount: amount,
        coin: typeCoin,
      );
      GetIt.I.get<WalletStore>().getCoins();
      onSuccess(true);
    } on SocketException catch (_) {
      onError("Lost connection to server");
    } on RPCError catch (e) {
      onError(e.message);
    } on FormatException catch (e) {
      onError(e.message);
    } catch (e) {
      onError(e.toString());
    }
  }
}
