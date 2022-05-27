import 'dart:io';
import 'dart:math';
import 'package:app/base_store/i_store.dart';
import 'package:app/web3/contractEnums.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:web3dart/web3dart.dart';

import '../../../../../../constants.dart';

part 'transfer_store.g.dart';

@singleton
class TransferStore = TransferStoreBase with _$TransferStore;

abstract class TransferStoreBase extends IStore<bool> with Store {
  @observable
  TYPE_COINS? typeCoin;

  @observable
  String addressTo = '';

  @observable
  String amount = '';

  @observable
  String fee = '';

  @computed
  bool get statusButtonTransfer =>
      typeCoin!=null && addressTo.isNotEmpty && amount.isNotEmpty;

  @action
  setAddressTo(String value) => addressTo = value;

  @action
  setAmount(String value) => amount = value;

  @action
  setTitleSelectedCoin(TYPE_COINS? value) => typeCoin = value;

  @action
  getMaxAmount() async {
    this.onLoading();
    try {
      final balance =
      await AccountRepository().service!.getBalance(AccountRepository().privateKey);
      final gas = await AccountRepository().service!.getGas();
      switch (typeCoin) {
        case TYPE_COINS.WQT:
          final count = (balance.getValueInUnitBI(EtherUnit.wei).toDouble() * pow(10, -18)).toDouble();
          final _gas = (gas.getInWei.toDouble() * pow(10, -16) * 250);
          amount = (count.toDouble() - _gas).toString();
          break;
        case TYPE_COINS.WUSD:
          final count = await AccountRepository().service!.getBalanceFromContract(AddressCoins.wUsd);
          final _gas = (gas.getInWei.toDouble() * pow(10, -16) * 10);
          amount = (count.toDouble() - _gas).toStringAsFixed(18);
          break;
        case TYPE_COINS.wETH:
          final count = await AccountRepository().service!.getBalanceFromContract(AddressCoins.wEth);
          final _gas = (gas.getInWei.toDouble() * pow(10, -16) * 10);
          amount = (count.toDouble() - _gas).toStringAsFixed(18);
          break;
        case TYPE_COINS.wBNB:
          final count = await AccountRepository().service!.getBalanceFromContract(AddressCoins.wBnb);
          final _gas = (gas.getInWei.toDouble() * pow(10, -16) * 10);
          amount = (count.toDouble() - _gas).toStringAsFixed(18);
          break;
        case TYPE_COINS.USDT:
          final count = await AccountRepository().service!.getBalanceFromContract(AddressCoins.uSdt);
          final _gas = (gas.getInWei.toDouble() * pow(10, -16) * 10);
          amount = (count.toDouble() - _gas).toStringAsFixed(18);
          break;
        default:
          break;
      }
      this.onSuccess(true);
    } on SocketException catch (_) {
      this.onError("Lost connection to server");
    } on FormatException catch (e) {
      print("error reached${e.message}");
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
      fee = (gas.getInWei.toInt() / pow(10, 18)).toStringAsFixed(17);
    } on SocketException catch (_) {
      onError("Lost connection to server");
    }
  }
}
