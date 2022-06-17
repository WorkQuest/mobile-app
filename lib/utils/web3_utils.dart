import 'dart:math';

import 'package:web3dart/web3dart.dart';

import '../web3/contractEnums.dart';
import '../web3/repository/account_repository.dart';

class Web3Utils {
  static checkPossibilityTx(TYPE_COINS typeCoin, double amount) async {
    final _client = AccountRepository().service!;
    final _balanceWQT = await _client.getBalance(AccountRepository().privateKey);
    final _gasTx = await _client.getGas();

    if (typeCoin == TYPE_COINS.WQT) {
      final _gas = (_gasTx.getInWei.toDouble() * pow(10, -16) * 250);
      final _balanceWQTInWei = (_balanceWQT.getValueInUnitBI(EtherUnit.wei).toDouble() * pow(10, -18)).toDouble();
      if (amount > (_balanceWQTInWei.toDouble() - _gas)) {
        throw FormatException('Not have enough WQT for the transaction');
      }
    } else if (typeCoin == TYPE_COINS.WUSD) {
      final _balanceToken = await _client.getBalanceFromContract(getAddressToken(typeCoin));
      if (amount > _balanceToken) {
        throw FormatException('Not have enough ${getTitleToken(typeCoin)} for the transaction');
      }
      if (_balanceWQT.getInWei < _gasTx.getInWei) {
        throw FormatException('Not have enough WQT for the transaction');
      }
    }
  }

  static String getAddressToken(TYPE_COINS typeCoin) {
    if (typeCoin == TYPE_COINS.WUSD) {
      return AccountRepository().getConfigNetwork().addresses.wUsd;
    } else if (typeCoin == TYPE_COINS.wETH) {
      return AccountRepository().getConfigNetwork().addresses.wEth;
    } else if (typeCoin == TYPE_COINS.wBNB) {
      return AccountRepository().getConfigNetwork().addresses.wBnb;
    } else {
      return AccountRepository().getConfigNetwork().addresses.uSdt;
    }
  }

  static String getTitleToken(TYPE_COINS typeCoin) {
    if (typeCoin == TYPE_COINS.WQT) {
      return 'WQT';
    } else if (typeCoin == TYPE_COINS.WUSD) {
      return 'WUSD';
    } else if (typeCoin == TYPE_COINS.wETH) {
      return 'wETH';
    } else if (typeCoin == TYPE_COINS.wBNB) {
      return 'wBNB';
    } else {
      return 'USDT';
    }
  }
}
