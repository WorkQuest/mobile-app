import 'package:app/constants.dart';
import 'package:app/web3/service/client_service.dart';
import 'package:flutter/widgets.dart';

import '../wallet.dart';

class AccountRepository {
  static final AccountRepository _instance = AccountRepository._internal();

  factory AccountRepository() => _instance;

  AccountRepository._internal();

  String? userAddress;
  List<Wallet>? userAddresses;

  String get privateKey => userAddresses!.first.privateKey!;
  ValueNotifier<Network> notifierNetwork =
      ValueNotifier<Network>(Network.mainnet);

  // setNetwork(NetworkName networkName) {
  //   this.networkName.value = networkName;
  //   final _network = Web3Utils.getNetwork(networkName);
  //   notifierNetwork.value = _network;
  // }

  addWallet(Wallet wallet) {
    if (userAddresses == null || userAddresses!.isEmpty) {
      userAddresses = [];
    }
    userAddresses!.add(wallet);
  }

  getAllBalances() async {
    await ClientService().getAllBalance(userAddresses!.first.privateKey!);
  }

  clearData() {
    userAddress = null;
    userAddresses?.clear();
  }
}

class BalanceItem {
  String title;
  String amount;

  BalanceItem(this.title, this.amount);

  @override
  String toString() {
    return 'BalanceItem {title: $title, amount: $amount}';
  }
}
