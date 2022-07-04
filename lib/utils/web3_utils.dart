import 'dart:math';

import 'package:app/constants.dart';
import 'package:easy_localization/easy_localization.dart';
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

    final _client = isMain ? AccountRepository().getClientWorkNet() : AccountRepository().getClient();
    final _balanceWQT = await _client.getBalance(AccountRepository().privateKey);

    if (typeCoin == TokenSymbols.WQT) {
      final _balanceWQTInWei = (_balanceWQT.getValueInUnitBI(EtherUnit.wei).toDouble() * pow(10, -18)).toDouble();
      if (amount + gas > (_balanceWQTInWei.toDouble())) {
        throw FormatException('errors.notHaveEnoughTx'.tr());
      }
    } else if (typeCoin == TokenSymbols.WUSD) {
      final _balanceToken = await _client.getBalanceFromContract(getAddressToken(typeCoin, isMain: isMain));
      if (amount > _balanceToken) {
        throw FormatException('errors.notHaveEnoughTxToken'.tr(namedArgs: {'token': getTitleToken(typeCoin)}));
      }
      if (_balanceWQT.getInWei < BigInt.from(gas * pow(10, 18))) {
        throw FormatException('errors.notHaveEnoughTx'.tr());
      }
    }
  }

  static int getDegreeToken(TokenSymbols typeCoin) {
    if (typeCoin == TokenSymbols.USDT) {
      final _value = AccountRepository().networkName.value;
      final _isBSC =
          _value == NetworkName.bscTestnet || _value == NetworkName.bscMainnet;
      return _isBSC ? 18 : 6;
    } else {
      return 18;
    }
  }

  static String getAddressToken(TokenSymbols typeCoin, {bool isMain = false}) {
    try {
      if (isMain) {
        final _network = AccountRepository().notifierNetwork.value;
        if (_network == Network.mainnet) {
          final _config = Configs.configsNetwork[NetworkName.workNetMainnet];
          return _config!.dataCoins.firstWhere((element) => element.symbolToken == typeCoin).addressToken!;
        } else {
          final _config = Configs.configsNetwork[NetworkName.workNetTestnet];
          return _config!.dataCoins.firstWhere((element) => element.symbolToken == typeCoin).addressToken!;
        }
      }
      final _dataTokens = AccountRepository().getConfigNetwork().dataCoins;
      return _dataTokens
          .firstWhere((element) => element.symbolToken == typeCoin)
          .addressToken!;
    } catch (e) {
      return '';
    }
  }

  static Network getNetwork(NetworkName networkName) {
    switch (networkName) {
      case NetworkName.workNetMainnet:
        return Network.mainnet;
      case NetworkName.workNetTestnet:
        return Network.testnet;
      case NetworkName.ethereumMainnet:
        return Network.mainnet;
      case NetworkName.ethereumTestnet:
        return Network.testnet;
      case NetworkName.bscMainnet:
        return Network.mainnet;
      case NetworkName.bscTestnet:
        return Network.testnet;
      case NetworkName.polygonMainnet:
        return Network.mainnet;
      case NetworkName.polygonTestnet:
        return Network.testnet;
    }
  }

  static NetworkName getNetworkName(String name) {
    if (name == NetworkName.workNetMainnet.name) {
      return NetworkName.workNetMainnet;
    } else if (name == NetworkName.workNetTestnet.name) {
      return NetworkName.workNetTestnet;
    } else if (name == NetworkName.ethereumMainnet.name) {
      return NetworkName.ethereumMainnet;
    } else if (name == NetworkName.ethereumTestnet.name) {
      return NetworkName.ethereumTestnet;
    } else if (name == NetworkName.bscMainnet.name) {
      return NetworkName.bscMainnet;
    } else if (name == NetworkName.bscTestnet.name) {
      return NetworkName.bscTestnet;
    } else if (name == NetworkName.polygonMainnet.name) {
      return NetworkName.polygonMainnet;
    } else {
      return NetworkName.polygonTestnet;
    }
  }

  static NetworkName getNetworkNameSwap(NetworkName name) {
    switch (name) {
      case NetworkName.workNetMainnet:
        return NetworkName.workNetTestnet;
      case NetworkName.workNetTestnet:
        return NetworkName.workNetMainnet;
      case NetworkName.ethereumMainnet:
        return NetworkName.ethereumTestnet;
      case NetworkName.ethereumTestnet:
        return NetworkName.ethereumMainnet;
      case NetworkName.bscMainnet:
        return NetworkName.bscTestnet;
      case NetworkName.bscTestnet:
        return NetworkName.bscMainnet;
      case NetworkName.polygonMainnet:
        return NetworkName.polygonTestnet;
      case NetworkName.polygonTestnet:
        return NetworkName.polygonMainnet;
    }
  }

  static SwitchNetworkNames getNetworkNameForSwitch(NetworkName name) {
    switch (name) {
      case NetworkName.workNetMainnet:
        return SwitchNetworkNames.WORKNET;
      case NetworkName.workNetTestnet:
        return SwitchNetworkNames.WORKNET;
      case NetworkName.ethereumMainnet:
        return SwitchNetworkNames.ETH;
      case NetworkName.ethereumTestnet:
        return SwitchNetworkNames.ETH;
      case NetworkName.bscMainnet:
        return SwitchNetworkNames.BSC;
      case NetworkName.bscTestnet:
        return SwitchNetworkNames.BSC;
      case NetworkName.polygonMainnet:
        return SwitchNetworkNames.POLYGON;
      case NetworkName.polygonTestnet:
        return SwitchNetworkNames.POLYGON;
    }
  }

  static NetworkName getNetworkNameFromSwitchNetworkName(
      SwitchNetworkNames name, Network network) {
    switch (name) {
      case SwitchNetworkNames.WORKNET:
        return network == Network.mainnet
            ? NetworkName.workNetMainnet
            : NetworkName.workNetTestnet;
      case SwitchNetworkNames.ETH:
        return network == Network.mainnet
            ? NetworkName.ethereumMainnet
            : NetworkName.ethereumTestnet;
      case SwitchNetworkNames.BSC:
        return network == Network.mainnet
            ? NetworkName.bscMainnet
            : NetworkName.bscTestnet;
      case SwitchNetworkNames.POLYGON:
        return network == Network.mainnet
            ? NetworkName.polygonMainnet
            : NetworkName.polygonTestnet;
    }
  }

  static SwapNetworks? getSwapNetworksFromNetworkName(NetworkName name) {
    switch (name) {
      case NetworkName.workNetMainnet:
        return null;
      case NetworkName.workNetTestnet:
        return null;
      case NetworkName.ethereumMainnet:
        return SwapNetworks.ETH;
      case NetworkName.ethereumTestnet:
        return SwapNetworks.ETH;
      case NetworkName.bscMainnet:
        return SwapNetworks.BSC;
      case NetworkName.bscTestnet:
        return SwapNetworks.BSC;
      case NetworkName.polygonMainnet:
        return SwapNetworks.POLYGON;
      case NetworkName.polygonTestnet:
        return SwapNetworks.POLYGON;
    }
  }

  static String getAddressWUSD() {
    final _isMainnet = AccountRepository().notifierNetwork.value == Network.mainnet;
    if (_isMainnet) {
      return Constants.worknetMainnetWUSD;
    } else {
      return Constants.worknetTestnetWUSD;
    }
  }

  static String getAddressWorknetWQFactory() {
    final _isMainnet = AccountRepository().notifierNetwork.value == Network.mainnet;
    if (_isMainnet) {
      return Constants.worknetMainnetWQFactory;
    } else {
      return Constants.worknetTestnetWQFactory;
    }
  }

  static String getAddressWorknetWQPromotion() {
    final _isMainnet = AccountRepository().notifierNetwork.value == Network.mainnet;
    if (_isMainnet) {
      return Constants.worknetMainnetWQPromotion;
    } else {
      return Constants.worknetTestnetWQPromotion;
    }
  }

  static String getRpcNetworkForSwap(SwapNetworks network) {
    final _networkType = AccountRepository().notifierNetwork.value;
    switch (network) {
      case SwapNetworks.ETH:
        return _networkType == Network.mainnet
            ? 'https://eth-mainnet.public.blastapi.io/'
            : 'https://speedy-nodes-nyc.moralis.io/b42d7d2a9baf055b2076cc12/eth/rinkeby';
      case SwapNetworks.BSC:
        return _networkType == Network.mainnet
            ? 'https://bscrpc.com/'
            : 'https://speedy-nodes-nyc.moralis.io/b42d7d2a9baf055b2076cc12/bsc/testnet';
      case SwapNetworks.POLYGON:
        return _networkType == Network.mainnet
            ? 'https://polygon-mainnet.public.blastapi.io/'
            : 'https://speedy-nodes-nyc.moralis.io/b42d7d2a9baf055b2076cc12/polygon/mumbai';
    }
  }

  static String getTokenUSDTForSwap(SwapNetworks network) {
    final _networkType = AccountRepository().notifierNetwork.value;
    switch (network) {
      case SwapNetworks.ETH:
        return _networkType == Network.mainnet
            ? '0xdAC17F958D2ee523a2206206994597C13D831ec7'
            : '0xD92E713d051C37EbB2561803a3b5FBAbc4962431';
      case SwapNetworks.BSC:
        return _networkType == Network.mainnet
            ? '0x55d398326f99059ff775485246999027b3197955'
            : '0xC9bda0FA861Bd3F66c7d0Fd75A9A8344e6Caa94A';
      case SwapNetworks.POLYGON:
        return _networkType == Network.mainnet
            ? '0xc2132D05D31c914a87C6611C10748AEb04B58e8F'
            : '0x631E327EA88C37D4238B5c559A715332266e7Ec1';
    }
  }

  static String getAddressContractForSwap(SwapNetworks network) {
    final _networkType = AccountRepository().notifierNetwork.value;
    switch (network) {
      case SwapNetworks.ETH:
        return _networkType == Network.mainnet
            ? '0xb29b67Bf5b7675f1ccaCdf49436b38dE337b502B'
            : '0x9870a749Ae5CdbC4F96E3D0C067eB212779a8FA1';
      case SwapNetworks.BSC:
        return _networkType == Network.mainnet
            ? '0x527aC80974c66939cBf686648064846708234256'
            : '0x833d71EF0b51Aa9Fb69b1f986381132628ED10F3';
      case SwapNetworks.POLYGON:
        return _networkType == Network.mainnet
            ? '0xe89508D74579A06A65B907c91F697CF4F8D9Fac7'
            : '0xE2e7518080a0097492087E652E8dEB1f6b96B62b';
    }
  }

  static String? getTitleOtherNetwork(NetworkName name) {
    switch (name) {
      case NetworkName.workNetMainnet:
        return null;
      case NetworkName.workNetTestnet:
        return null;
      case NetworkName.ethereumMainnet:
        return 'Ethereum';
      case NetworkName.ethereumTestnet:
        return 'Ethereum';
      case NetworkName.bscMainnet:
        return 'Binance Smart Chain';
      case NetworkName.bscTestnet:
        return 'Binance Smart Chain';
      case NetworkName.polygonMainnet:
        return 'Polygon';
      case NetworkName.polygonTestnet:
        return 'Polygon';
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
}
