import 'package:app/constants.dart';
import 'package:app/http/web_socket.dart';
import 'package:app/ui/pages/main_page/tabs/wallet/pages/transfer_page/mobx/transfer_store.dart';
import 'package:app/ui/pages/main_page/tabs/wallet/pages/wallet_page/store/wallet_store.dart';
import 'package:app/ui/pages/main_page/tabs/wallet/pages/wallet_page/widgets/list_transactions/store/transactions_store.dart';
import 'package:app/utils/storage.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:app/web3/service/client_service.dart';
import 'package:app/web3/wallet.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

class WalletRepository {
  static final WalletRepository _instance = WalletRepository._internal();

  factory WalletRepository() => _instance;

  WalletRepository._internal();

  Wallet? userWallet;
  ClientService? client;

  ValueNotifier<NetworkName?> networkName = ValueNotifier<NetworkName?>(null);
  ValueNotifier<Network> notifierNetwork =
      ValueNotifier<Network>(Network.mainnet);

  String get userAddress => userWallet!.address!;

  String get privateKey => userWallet!.privateKey!;

  bool get isOtherNetwork =>
      networkName.value != NetworkName.workNetTestnet &&
      networkName.value != NetworkName.workNetMainnet;

  ClientService getClient() {
    return client!;
  }

  ConfigNetwork getConfigNetwork() {
    return Configs.configsNetwork[networkName.value!]!;
  }

  connectClient() {
    if (WalletRepository().networkName.value == null) {
      final _networkName =
          WalletRepository().notifierNetwork.value == Network.mainnet
              ? NetworkName.workNetMainnet
              : NetworkName.workNetTestnet;
      WalletRepository().setNetwork(_networkName);
    }
    final config = Configs.configsNetwork[networkName.value!];
    client = ClientService(config!);
  }

  setWallet(Wallet wallet) {
    userWallet = wallet;
  }

  ConfigNetwork getConfigNetworkWorknet() {
    final _isTestnet = notifierNetwork.value == Network.testnet;
    return Configs.configsNetwork[
        _isTestnet ? NetworkName.workNetTestnet : NetworkName.workNetMainnet]!;
  }

  setNetwork(NetworkName networkName) {
    this.networkName.value = networkName;
    final _network = Web3Utils.getNetwork(networkName);
    notifierNetwork.value = _network;
    Storage.write(StorageKeys.networkName.name, networkName.name);
  }

  changeNetwork(NetworkName networkName, {bool updateTrxList = false}) {
    _saveNetwork(networkName);
    _disconnectWeb3Client();
    WebSocket().reconnectWalletSocket();
    connectClient();
    GetIt.I.get<WalletStore>().getCoins(isForce: true, fromSwap: updateTrxList);
    GetIt.I.get<TransferStore>().setCoin(null);
  }

  clearData() {
    userWallet = null;
    networkName.value = null;
    _disconnectWeb3Client();
    GetIt.I.get<TransactionsStore>().clearData();
    GetIt.I.get<WalletStore>().clearData();
    GetIt.I.get<TransferStore>().clearData();
    Storage.deleteAllFromSecureStorage();
  }

  _saveNetwork(NetworkName networkName) {
    this.networkName.value = networkName;
    Storage.write(StorageKeys.networkName.name, networkName.name);
  }

  _disconnectWeb3Client() {
    client?.client?.dispose();
    client?.client = null;
    client?.stream?.cancel();
  }

  ClientService getClientWorkNet() {
    if (notifierNetwork.value == Network.mainnet) {
      return ClientService(Configs.configsNetwork[NetworkName.workNetMainnet]!);
    } else if (notifierNetwork.value == Network.testnet) {
      return ClientService(Configs.configsNetwork[NetworkName.workNetTestnet]!);
    } else {
      throw FormatException('Error getting client WorkNet');
    }
  }
}
