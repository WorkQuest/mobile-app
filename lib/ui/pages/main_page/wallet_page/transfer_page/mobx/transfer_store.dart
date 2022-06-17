import 'dart:io';
import 'dart:math';
import 'package:app/base_store/i_store.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:app/web3/contractEnums.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'transfer_store.g.dart';

@singleton
class TransferStore = TransferStoreBase with _$TransferStore;

abstract class TransferStoreBase extends IStore<bool> with Store {
  double? maxAmount;

  @observable
  TYPE_COINS? typeCoin;

  @observable
  String addressTo = '';

  @observable
  String amount = '';

  @observable
  String fee = '';

  @computed
  bool get statusButtonTransfer => typeCoin != null && addressTo.isNotEmpty && amount.isNotEmpty;

  @action
  setAddressTo(String value) => addressTo = value;

  @action
  setAmount(String value) => amount = value;

  @action
  setTitleSelectedCoin(TYPE_COINS? value) async {
    maxAmount = null;
    typeCoin = value;
    if (typeCoin == TYPE_COINS.WQT) {
      final _balance = await AccountRepository().service!.getBalance(AccountRepository().privateKey);
      final _balanceInWei = _balance.getInWei;
      final _gasInWei = await AccountRepository().service!.getGas();
      maxAmount = ((_balanceInWei - _gasInWei.getInWei).toDouble() * pow(10, -18)).toDouble();
    } else {
      final _balance = await _getBalanceToken(Web3Utils.getAddressToken(typeCoin!));
      maxAmount = _balance.toDouble();
    }
  }

  @action
  getMaxAmount() async {
    this.onLoading();
    try {
      if (typeCoin == TYPE_COINS.WQT) {
        final _balance = await AccountRepository().service!.getBalance(AccountRepository().privateKey);
        final _balanceInWei = _balance.getInWei;
        final _gasInWei = await AccountRepository().service!.getGas();
        amount = ((_balanceInWei - _gasInWei.getInWei).toDouble() * pow(10, -18)).toStringAsFixed(18);
      } else {
        final _balance = await _getBalanceToken(Web3Utils.getAddressToken(typeCoin!));
        amount = _balance.toStringAsFixed(18);
      }
      this.onSuccess(true);
    } on SocketException catch (_) {
      this.onError("Lost connection to server");
    } on FormatException catch (e) {
      this.onError(e.message);
    } catch (e, trace) {
      print("ERROR: $e");
      print("ERROR: $trace");
      onError(e.toString());
    }
  }

  @action
  getFee() async {
    try {
      final gas = await AccountRepository().service!.getGas();
      fee = (gas.getInWei.toDouble() * pow(10, -18)).toStringAsFixed(18);
      print('fee: $fee');
    } on SocketException catch (_) {
      onError("Lost connection to server");
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<double> _getBalanceToken(String addressToken) async {
    final _balance = await AccountRepository().service!.getBalanceFromContract(addressToken);
    return _balance;
  }

}
