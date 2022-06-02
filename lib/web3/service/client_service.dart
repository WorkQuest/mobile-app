import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:app/web3/repository/account_repository.dart';
import 'package:flutter/services.dart';
import 'package:hex/hex.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:web_socket_channel/io.dart';
import '../../constants.dart';
import '../contractEnums.dart';
import 'address_service.dart';

abstract class ClientServiceI {
  Future<List<BalanceItem>> getBalanceFromList(
      List<EtherUnit> units, String privateKey);

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
  // static final apiUrl = "https://dev-node-ams3.workquest.co/";

  // static final wsUrl = "wss://wss-dev-node-nyc3.workquest.co/json-rpc ";
  final int _chainId = 20220112;
  final abiFactoryAddress = '0x455Fc7ac84ee418F4bD414ab92c9c27b18B7B066';

  ///ADDRESS WUSD_TOKEN
  final abiBridgeAddress = "0x0Ed13A696Fa29151F3064077aCb2a281e68df2aa";
  final abiPromotionAddress = "0xB778e471833102dBe266DE2747D72b91489568c2";
  String addressNewContract = "";

  Web3Client? client;

  ClientService(ConfigNetwork config, {String? customRpc}) {
    try {
      if (customRpc != null) {
        client = Web3Client(customRpc, Client());
        return;
      }
      client = Web3Client(config.rpc, Client(), socketConnector: () {
        return IOWebSocketChannel.connect(config.wss).cast<String>();
      });
    } catch (e, trace) {
      print('e -> $e\ntrace -> $trace');
      throw Exception(e.toString());
    }
  }

  // ClientService() {
  //   client = Web3Client(
  //     apiUrl,
  //     Client(),
  //   );
  // }

  @override
  Future<EthPrivateKey> getCredentials(String privateKey) async {
    return EthPrivateKey.fromHex(privateKey);
    //return await client!.credentialsFromPrivateKey(privateKey);
  }

  @override
  Future sendTransaction({
    required String privateKey,
    required String address,
    required String amount,
    required TYPE_COINS coin,
  }) async {
    address = address.toLowerCase();
    String? hash;

    final bigInt = BigInt.from(double.parse(amount) * pow(10, 18));
    final credentials = await getCredentials(privateKey);
    final myAddress = await AddressService().getPublicAddress(privateKey);

    if (coin == TYPE_COINS.WQT) {
      hash = await client!.sendTransaction(
        credentials,
        Transaction(
          to: EthereumAddress.fromHex(address),
          from: myAddress,
          value: EtherAmount.fromUnitAndValue(
            EtherUnit.wei,
            bigInt,
          ),
        ),
        chainId: _chainId,
      );
    } else {
      String addressToken = '';
      switch (coin) {
        case TYPE_COINS.WQT:
          break;
        case TYPE_COINS.WUSD:
          addressToken = AccountRepository().getConfigNetwork().addresses.wUsd;
          break;
        case TYPE_COINS.wBNB:
          addressToken = AccountRepository().getConfigNetwork().addresses.wBnb;
          break;
        case TYPE_COINS.wETH:
          addressToken = AccountRepository().getConfigNetwork().addresses.wEth;
          break;
        case TYPE_COINS.USDT:
          addressToken = AccountRepository().getConfigNetwork().addresses.uSdt;
          break;
      }
      final degree = coin == TYPE_COINS.USDT ? 6 : 18;
      final contract = Erc20(
          address: EthereumAddress.fromHex(addressToken), client: client!);
      hash = await contract.transfer(
        // myAddress,
        EthereumAddress.fromHex(address),
        BigInt.from(double.parse(amount) * pow(10, degree)),
        credentials: credentials,
      );
      print('${coin.toString()} hash - $hash');
    }

    int attempts = 0;
    TransactionReceipt? result;
    while (result == null) {
      result = await client!.getTransactionReceipt(hash);
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
          Erc20(address: EthereumAddress.fromHex(address), client: client!);
      final balance = await contract.balanceOf(
          EthereumAddress.fromHex(AccountRepository().userWallet!.address!));
      if (address == AccountRepository().getConfigNetwork().addresses.uSdt)
        return balance.toDouble() * pow(10, -6);
      else
        return balance.toDouble() * pow(10, -18);

      // switch (address) {
      //   case AddressCoins.uSdt:
      //     return balance.toDouble() * pow(10, -6);
      //   default:
      //     return balance.toDouble() * pow(10, -18);
      // }
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
    return client!.getGasPrice();
  }

  @override
  Future<EtherAmount> getBalance(String privateKey) async {
    final credentials = await getCredentials(privateKey);
    return client!.getBalance(credentials.address);
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
    final list =
        await Stream.fromIterable(EtherUnit.values).asyncMap((unit) async {
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
      final index = await client!.getNetworkId();
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

extension CreateQuestContract on ClientService {
  Uint8List stringToBytes32(String text) {
    Uint8List bytes32 = Uint8List.fromList(
      utf8.encode(text.padRight(32).substring(0, 32)),
    );
    return bytes32;
  }

  Future<TransactionReceipt> handleContract({
    required DeployedContract contract,
    required ContractFunction function,
    required List<dynamic> params,
    EthereumAddress? from,
    EtherAmount? value,
  }) async {
    try {
      final credentials = await getCredentials(AccountRepository().privateKey);
      final _gasPrice = await client!.getGasPrice();
      final transactionHash = await client!.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: function,
          gasPrice: _gasPrice,
          maxGas: 3000000,
          parameters: params,
          from: from,
          value: value,
        ),
        chainId: _chainId,
      );

      print("transactionHash: $transactionHash");

      int attempts = 0;
      TransactionReceipt? result;
      while (result == null) {
        result = await client!.getTransactionReceipt(transactionHash);
        if (result != null) print('Block: ${result.blockNumber}');
        await Future.delayed(const Duration(seconds: 3));
        attempts++;
        if (attempts == 5) {
          throw Exception("The waiting time is over. Expect a balance update.");
        }
      }
      return result;
    } catch (e, tr) {
      print("ERROR: $e \n trace: $tr");
      throw Exception("Unable to call");
    }
  }
}

extension CreateContract on ClientService {
  Future<void> createNewContract({
    required String jobHash,
    required String cost,
    required String deadline,
    required String nonce,
  }) async {
    print("Create contract");
    final credentials = await getCredentials(AccountRepository().privateKey);
    final contract =
        await getDeployedContract("WorkQuestFactory", abiFactoryAddress);
    final ethFunction =
        contract.function(WQFContractFunctions.newWorkQuest.name);
    final fromAddress = await credentials.extractAddress();
    await handleContract(
      contract: contract,
      function: ethFunction,
      params: [
        stringToBytes32(jobHash),
        //TODO Find out why a transaction with a commission does not pass
        BigInt.from(double.parse(cost)),
        BigInt.parse(deadline),
        BigInt.parse(nonce),
      ],
      from: fromAddress,
    );
  }
}

extension HandleEvent on ClientService {
  Future<void> handleEvent({
    required WQContractFunctions function,
    required String contractAddress,
    required String? value,
    List<dynamic> params = const [],
  }) async {
    final contract = await getDeployedContract("WorkQuest", contractAddress);
    final ethFunction = contract.function(function.name);
    await handleContract(
      contract: contract,
      function: ethFunction,
      params: params,
      value: value != null
          ? EtherAmount.fromUnitAndValue(
              EtherUnit.wei,
              BigInt.from(double.parse(value) * pow(10, 18)),
            )
          : null,
    );
  }
}

extension GetContract on ClientService {
  Future<DeployedContract> getDeployedContract(
    String contractName,
    String contractAddress,
  ) async {
    try {
      final _abiJson =
          await rootBundle.loadString("assets/contracts/$contractName.json");
      // dev.log(_abiJson);
      final _contractAbi = ContractAbi.fromJson(_abiJson, contractName);
      final _contractAddress = EthereumAddress.fromHex(
        contractAddress,
      );
      final contract = DeployedContract(_contractAbi, _contractAddress);
      return contract;
    } catch (e, tr) {
      print("getDeployedContract | Error: $e \n Trace: $tr");
      throw Exception("Error Creating Contract");
    }
  }
}

extension ApproveCoin on ClientService {
  Future<bool> approveCoin({
    required String cost,
  }) async {
    print("Approve coin");
    final credentials = await getCredentials(AccountRepository().privateKey);
    final contract =
        await getDeployedContract("WQBridgeToken", abiBridgeAddress);
    final ethFunction = contract.function(WQBridgeTokenFunctions.approve.name);
    final fromAddress = await credentials.extractAddress();
    final _cost = double.parse(cost) + double.parse(cost) * 0.025;
    final result = await handleContract(
      contract: contract,
      function: ethFunction,
      from: fromAddress,
      params: [
        EthereumAddress.fromHex(abiFactoryAddress),
        BigInt.from(_cost * pow(10, 18)),
      ],
    );

    if (result.status ?? false)
      return true;
    else
      return false;
  }
}

extension CheckFunction on ClientService {
  void checkFunction() async {
    try {
      final contract = await getDeployedContract(
          "WQBridgeToken", "0xD92E713d051C37EbB2561803a3b5FBAbc4962431");
      final outputs = contract.functions;
      print("Contract function:");
      outputs.forEach((element) {
        print(element.name);
      });
    } catch (e, tr) {
      print("Error: $e \n Trace: $tr");
      throw Exception("Error handling event");
    }
  }
}

extension CheckAddres on ClientService {
  Future<List<dynamic>> checkAdders(String address) async {
    try {
      final contract =
          await getDeployedContract("WorkQuestFactory", abiFactoryAddress);
      final ethFunction =
          contract.function(WQFContractFunctions.getWorkQuests.name);
      final outputs = await client!.call(
        contract: contract,
        function: ethFunction,
        params: [EthereumAddress.fromHex(address)],
      );
      return outputs;
    } catch (e, tr) {
      print("Error: $e \n Trace: $tr");
      throw Exception("Error handling event");
    }
  }
}

extension CheckStatus on ClientService {
  Future<List<dynamic>> checkStatus() async {
    try {
      final contract =
          await getDeployedContract("WorkQuest", addressNewContract);
      final ethFunction = contract.function(WQContractFunctions.status.name);
      final outputs = await client!.call(
        contract: contract,
        function: ethFunction,
        params: [],
      );

      print("Contract status: ${outputs.first}");

      return outputs;
    } catch (e, tr) {
      print("Error: $e \n Trace: $tr");
      throw Exception("Error handling event");
    }
  }
}

extension Promote on ClientService {
  Future<TransactionReceipt?> promoteQuest({
    required int tariff,
    required int period,
    required String amount,
    required String questAddress,
  }) async {
    print('tariff: $tariff');
    print('period: $period');
    print('amount: $amount');
    print('questAddress: $questAddress');
    final contract =
        await getDeployedContract("WQPromotion", abiPromotionAddress);
    final function = contract.function(WQPromotionFunctions.promoteQuest.name);
    final _credentials = await getCredentials(AccountRepository().privateKey);
    final _gasPrice = await client!.getGasPrice();
    final _fromAddress = await _credentials.extractAddress();
    final _value = EtherAmount.fromUnitAndValue(
      EtherUnit.wei,
      BigInt.from(double.parse(amount) * pow(10, 18)),
    );
    final _transactionHash = await client!.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: contract,
        function: function,
        gasPrice: _gasPrice,
        maxGas: 2000000,
        parameters: [
          EthereumAddress.fromHex(questAddress),
          BigInt.from(tariff),
          BigInt.from(period),
        ],
        from: _fromAddress,
        value: _value,
      ),
      chainId: _chainId,
    );
    int attempts = 0;
    TransactionReceipt? result;
    while (result == null) {
      result = await client!.getTransactionReceipt(_transactionHash);
      if (result != null) {
        print('result - ${result.blockNumber}');
        print("_transactionHash: $_transactionHash");
        print("result: $result");
      }
      await Future.delayed(const Duration(seconds: 3));
      attempts++;
      if (attempts == 5) {
        throw Exception("The waiting time is over. Expect a balance update.");
      }
    }
    return result;
  }

  Future<TransactionReceipt?> promoteUser({
    required int tariff,
    required int period,
    required String amount,
  }) async {
    print('tariff: $tariff');
    print('period: $period');
    print('amount: $amount');
    final contract =
        await getDeployedContract("WQPromotion", abiPromotionAddress);
    final function = contract.function(WQPromotionFunctions.promoteUser.name);
    final _credentials = await getCredentials(AccountRepository().privateKey);
    final _gasPrice = await client!.getGasPrice();
    final _fromAddress = await _credentials.extractAddress();
    final _value = EtherAmount.fromUnitAndValue(
      EtherUnit.wei,
      BigInt.from(double.parse(amount) * pow(10, 18)),
    );
    final _transactionHash = await client!.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: contract,
        function: function,
        gasPrice: _gasPrice,
        maxGas: 2000000,
        parameters: [
          BigInt.from(tariff),
          BigInt.from(period),
        ],
        from: _fromAddress,
        value: _value,
      ),
      chainId: _chainId,
    );
    int attempts = 0;
    TransactionReceipt? result;
    while (result == null) {
      result = await client!.getTransactionReceipt(_transactionHash);
      if (result != null) {
        print('result - ${result.blockNumber}');
        print("_transactionHash: $_transactionHash");
        print("result: $result");
      }
      await Future.delayed(const Duration(seconds: 3));
      attempts++;
      if (attempts == 5) {
        throw Exception("The waiting time is over. Expect a balance update.");
      }
    }
    return result;
  }
}
