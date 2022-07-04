import 'package:app/ui/pages/main_page/wallet_page/transactions/store/transactions_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/transfer_page/mobx/transfer_store.dart';
import 'package:app/utils/web3_utils.dart';
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

  factory AccountRepository() => _instance;

  AccountRepository._internal();

  Wallet? userWallet;
  ClientService? client;

  ValueNotifier<NetworkName?> networkName = ValueNotifier<NetworkName?>(null);

  ValueNotifier<Network> notifierNetwork = ValueNotifier<Network>(Network.mainnet);

  String get userAddress => userWallet!.address!;

  String get privateKey => userWallet!.privateKey!;

  ClientService getClient() {
    return client!;
  }

  connectClient() {
    final config = Configs.configsNetwork[networkName.value!];
    client = ClientService(config!);
  }

  setNetwork(NetworkName networkName) {
    this.networkName.value = networkName;
    final _network = Web3Utils.getNetwork(networkName);
    notifierNetwork.value = _network;
  }

  changeNetwork(NetworkName networkName) {
    _saveNetwork(networkName);
    _disconnectWeb3Client();
    WebSocket().reconnectWalletSocket();
    connectClient();
    GetIt.I.get<TransactionsStore>().getTransactions();
    GetIt.I.get<WalletStore>().getCoins();
    GetIt.I.get<TransferStore>().setCoin(null);
    final _swapNetwork = Web3Utils.getSwapNetworksFromNetworkName(networkName);
  }

  setWallet(Wallet wallet) {
    userWallet = wallet;
  }

  clearData() {
    userWallet = null;
    networkName.value = null;
    notifierNetwork.value = Network.mainnet;
    _disconnectWeb3Client();
    GetIt.I.get<TransactionsStore>().clearData();
    GetIt.I.get<WalletStore>().clearData();
    GetIt.I.get<TransferStore>().clearData();
    Storage.deleteAllFromSecureStorage();
  }

  ConfigNetwork getConfigNetwork() {
    return Configs.configsNetwork[networkName.value!]!;
  }

  _saveNetwork(NetworkName networkName) {
    this.networkName.value = networkName;
    Storage.write(StorageKeys.networkName.toString(), networkName.name);
  }

  _disconnectWeb3Client() {
    if (client?.client != null) {
      client!.client!.dispose();
      client!.client = null;
    }
  }

  ClientService getClientWorkNet(){
    if (notifierNetwork.value == Network.mainnet) {
      return ClientService(Configs.configsNetwork[NetworkName.workNetMainnet]!);
    } else if (notifierNetwork.value == Network.testnet) {
      return ClientService(Configs.configsNetwork[NetworkName.workNetTestnet]!);
    } else {
      throw FormatException('Error getting client WorkNet');
    }
  }

  bool get isOtherNetwork =>
      networkName.value != NetworkName.workNetTestnet &&
          networkName.value != NetworkName.workNetMainnet;
}
