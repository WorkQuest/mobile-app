import 'package:app/web3/service/client_service.dart';

import '../../utils/storage.dart';
import '../wallet.dart';

class AccountRepository {
  static final AccountRepository _instance = AccountRepository._internal();

  factory AccountRepository() => _instance;

  AccountRepository._internal();

  ClientService? service;

  Wallet? userWallet;

  String get userAddress => userWallet!.address!;
  String get privateKey => userWallet!.privateKey!;

  setWallet(Wallet wallet) {
    userWallet = wallet;
  }

  connectClient() {
    service = ClientService();
  }

  clearData() {
    userWallet = null;
    Storage.deleteAllFromSecureStorage();
    _disconnectWeb3Client();
  }

  _disconnectWeb3Client() {
    if (service?.client != null) {
      service!.client?.dispose();
      service = null;
    }
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
