import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:app/web3/repository/account_repository.dart';
import 'package:hex/hex.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import '../contractEnums.dart';
import 'address_service.dart';

abstract class ClientServiceI {
  Future<List<BalanceItem>> getBalanceFromList(List<EtherUnit> units, String privateKey);

  Future<num> getBalanceInUnit(EtherUnit unit, String privateKey);

  Future<List<BalanceItem>> getAllBalance(String privateKey);

  Future<EthPrivateKey> getCredentials(String privateKey);

  Future<double> getBalanceFromContract(String address);

  Future<EtherAmount> getBalance(String privateKey);

  Future<String> getSignature(String privateKey);

  Future<EtherAmount> getGas();

  Future<String> getNetwork();

  Future sendTransaction({
    required String privateKey,
    required String address,
    required String amount,
    required TYPE_COINS coin,
  });
}

class ClientService implements ClientServiceI {
  final apiUrl = "https://dev-node-nyc3.workquest.co";
  final wsUrl = "wss://dev-node-nyc3.workquest.co";

  Web3Client? ethClient;

  ClientService() {
    ethClient = Web3Client(apiUrl, Client());
  }

  @override
  Future<EthPrivateKey> getCredentials(String privateKey) async {
    return EthPrivateKey.fromHex(privateKey);
    //return await ethClient!.credentialsFromPrivateKey(privateKey);
  }

  @override
  Future sendTransaction({
    required String privateKey,
    required String address,
    required String amount,
    required TYPE_COINS coin,
  }) async {
    print('client sendTransaction');
    print('TYPE_COINS $TYPE_COINS');
    address = address.toLowerCase();
    String? hash;
    final bigInt = BigInt.from(double.parse(amount) * pow(10, 18));
    final credentials = await getCredentials(privateKey);
    final myAddress = await AddressService().getPublicAddress(privateKey);

    if (coin == TYPE_COINS.wusd) {
      hash = await ethClient!.sendTransaction(
        credentials,
        Transaction(
          to: EthereumAddress.fromHex(address),
          from: myAddress,
          value: EtherAmount.fromUnitAndValue(
            EtherUnit.wei,
            bigInt,
          ),
        ),
        chainId: 20220112,
      );
    } else if (coin == TYPE_COINS.wqt) {
      print('send wqt');
      final contract = Erc20(
          address: EthereumAddress.fromHex('0x917dc1a9E858deB0A5bDCb44C7601F655F728DfE'),
          client: ethClient!);
      hash = await contract.transfer(
        EthereumAddress.fromHex(address),
        BigInt.from(double.parse(amount) * pow(10, 18)),
        credentials: credentials,
      );
      print('wqt hash - $hash');
    }

    int attempts = 0;
    TransactionReceipt? result;
    while (result == null) {
      result = await ethClient!.getTransactionReceipt(hash!);
      if (result != null) {
        print('result - ${result.blockNumber}');
      }
      await Future.delayed(const Duration(seconds: 3));
      attempts++;
      if (attempts == 5) {
        throw Exception("The waiting time is over. Expect a balance update.");
      }
    }
  }

  @override
  Future<double> getBalanceFromContract(String address) async {
    try {
      address = address.toLowerCase();
      final contract =
          Erc20(address: EthereumAddress.fromHex(address), client: ethClient!);
      final balance = await contract.balanceOf(
          EthereumAddress.fromHex(AccountRepository().userAddresses!.first.address!));
      return balance.toDouble() * pow(10, -18);
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<String> getSignature(String privateKey) async {
    final credentials = await getCredentials(privateKey);
    final address = await credentials.extractAddress();
    final result = await credentials.signPersonalMessage(
      Uint8List.fromList(address.addressBytes),
    );
    return HEX.encode(result.toList());
  }

  @override
  Future<EtherAmount> getGas() async {
    return ethClient!.getGasPrice();
  }

  @override
  Future<EtherAmount> getBalance(String privateKey) async {
    final credentials = await getCredentials(privateKey);
    return ethClient!.getBalance(credentials.address);
  }

  @override
  Future<List<BalanceItem>> getBalanceFromList(
      List<EtherUnit> units, String privateKey) async {
    if (units.isEmpty) {
      throw Exception("List units is empty");
    }

    final list = await Stream.fromIterable(units).asyncMap((unit) async {
      final balance = await getBalanceInUnit(unit, privateKey);
      return BalanceItem(unit.name, balance.toString());
    }).toList();

    return list;
  }

  @override
  Future<List<BalanceItem>> getAllBalance(String privateKey) async {
    final list = await Stream.fromIterable(EtherUnit.values).asyncMap((unit) async {
      final balance = await getBalanceInUnit(unit, privateKey);
      return BalanceItem(unit.name, balance.toString());
    }).toList();
    return list;
  }

  @override
  Future<num> getBalanceInUnit(EtherUnit unit, String privateKey) async {
    final balance = await getBalance(privateKey);
    return balance.getValueInUnit(unit);
  }

  @override
  Future<String> getNetwork() async {
    try {
      final index = await ethClient!.getNetworkId();
      switch (index) {
        case 1:
          return "Ethereum Mainnet";
        case 2:
          return "Morden Testnet (deprecated)";
        case 3:
          return "Ropsten Testnet";
        case 4:
          return "Rinkeby Testnet";
        case 42:
          return "Kovan Testnet";
        default:
          return "Unknown network";
      }
    } catch (e) {
      return "Network could not be identified";
    }
  }
}
