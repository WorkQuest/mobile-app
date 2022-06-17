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
      ValueNotifier<ConfigNameNetwork?>(ConfigNameNetwork.devnet);

  factory AccountRepository() => _instance;

  AccountRepository._internal();

  ClientService? service;
  ConfigNameNetwork? configName;

  Wallet? userWallet;

  String get userAddress => userWallet!.address!;

  String get privateKey => userWallet!.privateKey!;

  setWallet(Wallet wallet) {
    userWallet = wallet;
  }

  connectClient() {
    final config = Configs.configsNetwork[configName];
    service = ClientService(config!);
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
    GetIt.I.get<WalletStore>().getCoins();
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
    if (service?.client != null) {
      service!.client?.dispose();
      service = null;
    }
  }

  ConfigNetwork getConfigNetwork() =>
      Configs.configsNetwork[configName ?? ConfigNameNetwork.devnet]!;

  ConfigNameNetwork _getNetworkNameKey(String name) {
    switch (name) {
      case 'devnet':
        return ConfigNameNetwork.devnet;
      case 'testnet':
        return ConfigNameNetwork.testnet;
      default:
        throw Exception('Unknown name network');
    }
  }
}
