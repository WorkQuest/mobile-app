import 'package:app/constants.dart';
import 'package:app/keys.dart';
import 'package:app/ui/pages/main_page/tabs/wallet/pages/swap_page/store/swap_store.dart';
import 'package:app/web3/repository/wallet_repository.dart';
import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:web3dart/contracts/erc20.dart';

class Web3Exception implements Exception {
  final String message;

  Web3Exception([this.message = 'Unknown Web3 error']);

  @override
  String toString() => message;
}

class Web3Utils {
  static checkPossibilityTx({
    required TokenSymbols typeCoin,
    required double amount,
    required Decimal fee,
    bool isMain = false,
  }) async {
    final _client = isMain
        ? WalletRepository().getClientWorkNet()
        : WalletRepository().getClient();
    final _balanceNative =
        await _client.getBalance(WalletRepository().privateKey);
    final _isNativeToken = WalletRepository().isOtherNetwork
        ? typeCoin == TokenSymbols.ETH ||
            typeCoin == TokenSymbols.BNB ||
            typeCoin == TokenSymbols.MATIC
        : typeCoin == TokenSymbols.WQT;

    if (_isNativeToken) {
      final _balanceWQTInWei = (Decimal.fromBigInt(_balanceNative.getInWei) /
              Decimal.fromInt(10).pow(18))
          .toDouble();
      print('fee: $fee');
      print('_balanceWQTInWei: $_balanceWQTInWei');
      print('amount: $amount');
      if (amount > (_balanceWQTInWei.toDouble() - fee.toDouble())) {
        throw Web3Exception('errors.notHaveEnoughTx'.tr());
      }
    } else {
      final _balanceToken =
          await _client.getBalanceFromContract(getAddressToken(typeCoin));
      print('_balanceToken: $_balanceToken');
      print('amount: $amount');

      if (amount > _balanceToken.toDouble()) {
        throw Web3Exception('errors.notHaveEnoughTxToken'.tr());
      }
      fee = fee * Decimal.fromInt(10).pow(18);
      if (_balanceNative.getInWei < fee.toBigInt()) {
        throw Web3Exception('errors.notHaveEnoughTx'.tr());
      }
    }
  }

  static Future<int> getDegreeToken(Erc20 contract) async {
    final _decimals = await contract.decimals();
    return _decimals.toInt();
  }

  static String getAddressToken(TokenSymbols typeCoin, {bool isMain = false}) {
    try {
      if (isMain) {
        final _network = WalletRepository().notifierNetwork.value;
        if (_network == Network.mainnet) {
          final _config = Configs.configsNetwork[NetworkName.workNetMainnet];
          return _config!.dataCoins
              .firstWhere((element) => element.symbolToken == typeCoin)
              .addressToken!;
        } else {
          final _config = Configs.configsNetwork[NetworkName.workNetTestnet];
          return _config!.dataCoins
              .firstWhere((element) => element.symbolToken == typeCoin)
              .addressToken!;
        }
      }
      final _dataTokens = WalletRepository().getConfigNetwork().dataCoins;
      return _dataTokens
          .firstWhere((element) => element.symbolToken == typeCoin)
          .addressToken!;
    } catch (e) {
      return '';
    }
  }

  static Decimal getGas({
    required BigInt estimateGas,
    required BigInt gas,
    required int degree,
    bool isETH = false,
    bool isTransfer = false,
  }) {
    return ((Decimal.parse(estimateGas.toString()) *
                Decimal.parse(gas.toString()) *
                Decimal.parse(isETH ? (isTransfer ? '1.05' : '1.1') : '1.0')) /
            Decimal.fromInt(10).pow(18))
        .toDecimal();
  }

  static BigInt getAmountBigInt({
    required String amount,
    required int degree,
  }) {
    return (Decimal.tryParse(amount) ??
            Decimal.zero * Decimal.fromInt(10).pow(degree))
        .toBigInt();
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

  static NetworkName getNetworkNameFromSwapNetworks(SwapNetworks name) {
    final _isMainnet =
        WalletRepository().notifierNetwork.value == Network.mainnet;
    switch (name) {
      case SwapNetworks.ETH:
        return _isMainnet
            ? NetworkName.ethereumMainnet
            : NetworkName.ethereumTestnet;
      case SwapNetworks.BSC:
        return _isMainnet ? NetworkName.bscMainnet : NetworkName.bscTestnet;
      case SwapNetworks.POLYGON:
        return _isMainnet
            ? NetworkName.polygonMainnet
            : NetworkName.polygonTestnet;
    }
  }

  static String getLinkToExplorer(SwapNetworks name, String tx) {
    final _isMainnet =
        WalletRepository().notifierNetwork.value == Network.mainnet;
    switch (name) {
      case SwapNetworks.ETH:
        return _isMainnet
            ? 'https://etherscan.io/tx/$tx'
            : 'https://rinkeby.etherscan.io/tx/$tx';
      case SwapNetworks.BSC:
        return _isMainnet
            ? 'https://bscscan.com/tx/$tx'
            : 'https://testnet.bscscan.com/tx/$tx';
      case SwapNetworks.POLYGON:
        return _isMainnet
            ? 'https://polygonscan.com/tx/$tx'
            : 'https://mumbai.polygonscan.com/tx/$tx';
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
    final _isMainnet =
        WalletRepository().notifierNetwork.value == Network.mainnet;
    if (_isMainnet) {
      return Constants.worknetMainnetWUSD;
    } else {
      return Constants.worknetTestnetWUSD;
    }
  }

  static bool isETH() {
    return WalletRepository().networkName.value ==
            NetworkName.ethereumMainnet ||
        WalletRepository().networkName.value == NetworkName.ethereumTestnet;
  }

  static String getAddressWorknetWQFactory() {
    final _isMainnet =
        WalletRepository().notifierNetwork.value == Network.mainnet;
    if (_isMainnet) {
      return Constants.worknetMainnetWQFactory;
    } else {
      return Constants.worknetTestnetWQFactory;
    }
  }

  static String getAddressWorknetWQPromotion() {
    final _isMainnet =
        WalletRepository().notifierNetwork.value == Network.mainnet;
    if (_isMainnet) {
      return Constants.worknetMainnetWQPromotion;
    } else {
      return Constants.worknetTestnetWQPromotion;
    }
  }

  static String getNativeToken() {
    final _networkName =
        WalletRepository().networkName.value ?? NetworkName.workNetMainnet;
    switch (_networkName) {
      case NetworkName.workNetMainnet:
        return 'WQT';
      case NetworkName.workNetTestnet:
        return 'WQT';
      case NetworkName.ethereumMainnet:
        return 'ETH';
      case NetworkName.ethereumTestnet:
        return 'ETH';
      case NetworkName.bscMainnet:
        return 'BNB';
      case NetworkName.bscTestnet:
        return 'BNB';
      case NetworkName.polygonMainnet:
        return 'MATIC';
      case NetworkName.polygonTestnet:
        return 'MATIC';
    }
  }

  static String getRpcNetworkForSwap(SwapNetworks network) {
    final _networkType = WalletRepository().notifierNetwork.value;
    switch (network) {
      case SwapNetworks.ETH:
        return _networkType == Network.mainnet
            ? 'https://eth-mainnet.public.blastapi.io/'
            : 'https://speedy-nodes-nyc.moralis.io/${Keys.moralicKey}/eth/rinkeby';
      case SwapNetworks.BSC:
        return _networkType == Network.mainnet
            ? 'https://bscrpc.com/'
            : 'https://speedy-nodes-nyc.moralis.io/${Keys.moralicKey}/bsc/testnet';
      case SwapNetworks.POLYGON:
        return _networkType == Network.mainnet
            ? 'https://polygon-mainnet.public.blastapi.io/'
            : 'https://speedy-nodes-nyc.moralis.io/${Keys.moralicKey}/polygon/mumbai';
    }
  }

  static String getTokenUSDTForSwap(SwapNetworks network) {
    final _networkType = WalletRepository().notifierNetwork.value;
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

  static bool isNativeToken(TokenSymbols token) {
    if (token == TokenSymbols.WQT ||
        token == TokenSymbols.ETH ||
        token == TokenSymbols.BNB ||
        token == TokenSymbols.MATIC) {
      return true;
    }
    return false;
  }

  static String getAddressContractForSwap(SwapNetworks network) {
    final _networkType = WalletRepository().notifierNetwork.value;
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

  static TokenSymbols? getTokenSymbol(String token) {
    if (token == "WQT") {
      return TokenSymbols.WQT;
    } else if (token == "BNB") {
      return TokenSymbols.wBNB;
    } else if (token == "USDT") {
      return TokenSymbols.USDT;
    } else if (token == "ETH") {
      return TokenSymbols.wETH;
    } else {
      return null;
    }
  }

  static String getPathIcon(TokenSymbols token) {
    switch (token) {
      case TokenSymbols.WUSD:
        return 'assets/wusd_coin_icon.svg';
      case TokenSymbols.WQT:
        return 'assets/wqt_coin_icon.svg';
      case TokenSymbols.wBNB:
        return 'assets/bsc_logo.svg';
      case TokenSymbols.wETH:
        return 'assets/eth_coin_icon.svg';
      case TokenSymbols.USDT:
        return 'assets/tusdt_coin_icon.svg';
      case TokenSymbols.BNB:
        return 'assets/bsc_logo.svg';
      case TokenSymbols.ETH:
        return 'assets/eth_coin_icon.svg';
      case TokenSymbols.MATIC:
        return 'assets/matic_coin_icon.svg';
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
