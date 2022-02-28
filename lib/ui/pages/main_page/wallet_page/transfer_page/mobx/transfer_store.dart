import 'dart:io';
import 'dart:math';
import 'package:app/base_store/i_store.dart';
import 'package:app/web3/contractEnums.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:app/web3/service/client_service.dart';
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
          await ClientService().getBalance(AccountRepository().privateKey);
      final gas = await ClientService().getGas();
      switch (typeCoin) {
        case TYPE_COINS.WUSD:
          final count = balance.getValueInUnitBI(EtherUnit.ether);
          amount = (count - gas.getInEther).toString();
          break;
        case TYPE_COINS.WQT:
          final count = await ClientService().getBalanceFromContract(AddressCoins.wqt);
          amount = (count - gas.getInEther.toDouble() * 0.3).toString();
          break;
        case TYPE_COINS.wETH:
          final count = await ClientService().getBalanceFromContract(AddressCoins.wEth);
          amount = (count - gas.getInEther.toDouble() * 0.3).toString();
          break;
        case TYPE_COINS.wBNB:
          final count = await ClientService().getBalanceFromContract(AddressCoins.wBnb);
          amount = (count - gas.getInEther.toDouble() * 0.3).toString();
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
      final gas = await ClientService().getGas();
      fee = (gas.getInWei.toInt() / pow(10, 18)).toStringAsFixed(17);
    } on SocketException catch (_) {
      onError("Lost connection to server");
    }
  }
}
