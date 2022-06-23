import 'dart:math';

import 'package:app/constants.dart';
import 'package:web3dart/web3dart.dart';

import '../ui/pages/main_page/wallet_page/swap_page/store/swap_store.dart';
import '../web3/repository/account_repository.dart';

class Web3Utils {
  static checkPossibilityTx({
    required TokenSymbols typeCoin,
    required double gas,
    required double amount,
    bool isMain = false,
  }) async {
    final _client = AccountRepository().getClient();
    final _balanceWQT = await _client.getBalance(AccountRepository().privateKey);

    if (typeCoin == TokenSymbols.WQT) {
      final _balanceWQTInWei = (_balanceWQT.getValueInUnitBI(EtherUnit.wei).toDouble() * pow(10, -18)).toDouble();
      if (amount + gas > (_balanceWQTInWei.toDouble())) {
        throw FormatException('Not have enough WQT for the transaction');
      }
    } else if (typeCoin == TokenSymbols.WUSD) {
      final _balanceToken = await _client.getBalanceFromContract(getAddressToken(typeCoin, isMain: isMain));
      if (amount > _balanceToken) {
        throw FormatException('Not have enough ${getTitleToken(typeCoin)} for the transaction');
      }
      if (_balanceWQT.getInWei < BigInt.from(gas * pow(10, 18))) {
        throw FormatException('Not have enough WQT for the transaction');
      }
    }
  }

  static int getDegreeToken(TokenSymbols typeCoin) {
    if (typeCoin == TokenSymbols.USDT) {
      return 6;
    } else {
      return 18;
    }
  }

  static String getAddressToken(TokenSymbols typeCoin, {bool isMain = false}) {
    try {
      if (isMain) {
        final _dataTokens = Configs.configsNetwork[ConfigNameNetwork.testnet]!.dataCoins;
        return _dataTokens.firstWhere((element) => element.symbolToken == typeCoin).addressToken!;
      } else {
        final _dataTokens = AccountRepository().getConfigNetwork().dataCoins;
        return _dataTokens.firstWhere((element) => element.symbolToken == typeCoin).addressToken!;
      }
    } catch (e) {
      return '';
    }
  }

  static String getTitleToken(TokenSymbols typeCoin) {
    if (typeCoin == TokenSymbols.WQT) {
      return 'WQT';
    } else if (typeCoin == TokenSymbols.WUSD) {
      return 'WUSD';
    } else if (typeCoin == TokenSymbols.wETH) {
      return 'wETH';
    } else if (typeCoin == TokenSymbols.wBNB) {
      return 'wBNB';
    } else {
      return 'USDT';
    }
  }

  static String getAddressContractBridge(SwapNetworks network) {
    switch (network) {
      case SwapNetworks.ethereum:
        return '0x9870a749Ae5CdbC4F96E3D0C067eB212779a8FA1';
      case SwapNetworks.binance:
        return '0x833d71EF0b51Aa9Fb69b1f986381132628ED10F3';
      case SwapNetworks.matic:
        return '0xE2e7518080a0097492087E652E8dEB1f6b96B62b';
    }
  }

  static String getRpcNetwork(SwapNetworks network) {
    switch (network) {
      case SwapNetworks.ethereum:
        return 'https://rinkeby.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161';
      case SwapNetworks.binance:
        return 'https://data-seed-prebsc-1-s1.binance.org:8545/';
      case SwapNetworks.matic:
        return 'https://rpc-mumbai.matic.today';
    }
  }

  static String getTokenUSDT(SwapNetworks network) {
    switch (network) {
      case SwapNetworks.ethereum:
        return '0xD92E713d051C37EbB2561803a3b5FBAbc4962431';
      case SwapNetworks.binance:
        return '0xC9bda0FA861Bd3F66c7d0Fd75A9A8344e6Caa94A';
      case SwapNetworks.matic:
        return '0x631E327EA88C37D4238B5c559A715332266e7Ec1';
    }
  }
}
