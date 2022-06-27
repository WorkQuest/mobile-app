import 'package:app/ui/pages/main_page/wallet_page/transactions/store/transactions_store.dart';
import 'package:app/web3/service/client_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../../constants.dart';
import '../../ui/pages/main_page/wallet_page/store/wallet_store.dart';
import '../../utils/storage.dart';
import '../../utils/web_socket.dart';
import '../wallet.dart';

class AccountRepository {
  static final AccountRepository _instance = AccountRepository._internal();
  ValueNotifier<ConfigNameNetwork?> notifier =
      ValueNotifier<ConfigNameNetwork?>(ConfigNameNetwork.testnet);

  factory AccountRepository() => _instance;

  AccountRepository._internal();

  ClientService? workNetClient;
  ClientService? otherClient;

  ClientService getClient({other = false}) {
    if (other) {
      return otherClient!;
    } else {
      return workNetClient!;
    }
  }

  ConfigNameNetwork? configName;

  Wallet? userWallet;

  String get userAddress => userWallet!.address!;

  String get privateKey => userWallet!.privateKey!;

  setWallet(Wallet wallet) {
    userWallet = wallet;
  }

  connectClient() {
    final config = Configs.configsNetwork[configName]!;
    workNetClient =
        ClientService(Configs.configsNetwork[ConfigNameNetwork.testnet]!);
    otherClient = ClientService(config);
  }

  clearData() {
    userWallet = null;
    Storage.deleteAllFromSecureStorage();
    _disconnectWeb3Client();
  }

  changeNetwork(ConfigNameNetwork configName) {
    _saveNetwork(configName);
    _disconnectWeb3Client();
    WebSocket().reconnectWalletSocket();
    connectClient();
    GetIt.I.get<TransactionsStore>().getTransactions();
    GetIt.I.get<WalletStore>().getCoins(isForce: true);
  }

  setNetwork(String name) {
    final configName = _getNetworkNameKey(name);
    this.configName = configName;
    notifier.value = configName;
  }

  _saveNetwork(ConfigNameNetwork configName) {
    this.configName = configName;
    notifier.value = configName;
    Storage.writeConfig(configName.name);
  }

  _disconnectWeb3Client() {
    if (workNetClient?.client != null) {
      workNetClient!.client?.dispose();
      workNetClient = null;
    }
    if (otherClient?.client != null) {
      otherClient!.client?.dispose();
      otherClient = null;
    }
  }

  bool get isConfigTestnet => configName == ConfigNameNetwork.testnet;

  ConfigNetwork getConfigNetwork() =>
      Configs.configsNetwork[configName ?? ConfigNameNetwork.testnet]!;

  ConfigNameNetwork _getNetworkNameKey(String name) {
    switch (name) {
      case 'testnet':
        return ConfigNameNetwork.testnet;
      case 'rinkeby':
        return ConfigNameNetwork.rinkeby;
      case 'polygon':
        return ConfigNameNetwork.polygon;
      case 'binance':
        return ConfigNameNetwork.binance;
      default:
        throw Exception('Unknown name network');
    }
  }
}
