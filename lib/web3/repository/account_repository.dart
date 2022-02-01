import 'package:app/web3/service/client_service.dart';

import '../wallet.dart';

class AccountRepository {
  static final AccountRepository _instance = AccountRepository._internal();

  factory AccountRepository() => _instance;

  AccountRepository._internal() {
    client = ClientService();
  }

  ClientService? client;
  String? userAddress;
  List<Wallet>? userAddresses;

  String get privateKey => userAddresses!.first.privateKey!;

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
    userAddresses!.clear();
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
