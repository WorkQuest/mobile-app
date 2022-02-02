import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:app/web3/repository/account_repository.dart';
import 'package:flutter/services.dart';
import 'package:hex/hex.dart';
import 'package:injectable/injectable.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:web_socket_channel/io.dart';
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

@singleton
class ClientService implements ClientServiceI {
  static final apiUrl = "https://dev-node-nyc3.workquest.co";
  static final wsUrl = "wss://dev-node-nyc3.workquest.co";
  final int _chainId = 20220112;
  final _abiAddress = '0xF38E33e7DD7e1a91c772aF51A366cd126e4552BB';
  String addressNewContract = "";

  final Web3Client _client = Web3Client(
    apiUrl,
    Client(),
    socketConnector: () => IOWebSocketChannel.connect(wsUrl).cast<String>(),
  );

  @override
  Future<EthPrivateKey> getCredentials(String privateKey) async {
    return EthPrivateKey.fromHex(privateKey);
    //return await _client.credentialsFromPrivateKey(privateKey);
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
      hash = await _client.sendTransaction(
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
    } else if (coin == TYPE_COINS.wqt) {
      print('send wqt');
      final contract = Erc20(
        address: EthereumAddress.fromHex(
            '0x917dc1a9E858deB0A5bDCb44C7601F655F728DfE'),
        client: _client,
      );
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
      result = await _client.getTransactionReceipt(hash!);
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
          Erc20(address: EthereumAddress.fromHex(address), client: _client);
      final balance = await contract.balanceOf(EthereumAddress.fromHex(
          AccountRepository().userAddresses!.first.address!));
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
    return _client.getGasPrice();
  }

  @override
  Future<EtherAmount> getBalance(String privateKey) async {
    final credentials = await getCredentials(privateKey);
    print("balaance${_client.getBalance(credentials.address)}");
    return _client.getBalance(credentials.address);
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
    list.forEach(print);
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
      final index = await _client.getNetworkId();
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

  Future<List<dynamic>> handleContract({
    required DeployedContract contract,
    required ContractFunction function,
    required List<dynamic> params,
    EthereumAddress? from,
    EtherAmount? value,
  }) async {
    try {
      final credentials = await getCredentials("privateKey");
      final _gasPrice = await _client.getGasPrice();
      final transactionHash = await _client.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: function,
          gasPrice: _gasPrice,
          maxGas: 2000000,
          parameters: params,
          from: from,
          value: value,
        ),
        chainId: _chainId,
      );

      print("transactionHash: $transactionHash");

      Timer.periodic(Duration(seconds: 10), (timer) async {
        timer.cancel();
        TransactionReceipt? transactionReceipt =
            await _client.getTransactionReceipt(transactionHash);

        if (transactionReceipt != null) {
          addressNewContract = transactionReceipt.logs[0].address.toString();
          print("Logs:");
          transactionReceipt.logs.forEach((element) {
            print(element);
          });
        }
        checkStatus();
      });
      return [];
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
    final credentials = await getCredentials("privateKey");
    final contract = await getDeployedContract("WorkQuestFactory", _abiAddress);
    final ethFunction =
        contract.function(WQFContractFunctions.newWorkQuest.name);
    final fromAddress = await credentials.extractAddress();
    final depositAmount = (double.parse(cost) * 1.01) * pow(10, 18);

    final transferEvent =
        contract.event(WQFContractEvents.WorkQuestCreated.name);
    final subscription = _client
        .events(FilterOptions.events(contract: contract, event: transferEvent))
        .take(1)
        .listen((event) {
      addressNewContract = event.address.toString();
    });

    handleContract(
      contract: contract,
      function: ethFunction,
      params: [
        stringToBytes32(jobHash),
        BigInt.parse(cost),
        BigInt.parse(deadline),
        BigInt.parse("123"),
      ],
      from: fromAddress,
      value: EtherAmount.inWei(BigInt.parse(depositAmount.ceil().toString())),
    );
    await subscription.asFuture();
    await subscription.cancel();
  }
}

extension HandleEvent on ClientService {
  Future<void> handleEvent(
    WQContractFunctions function, [
    List<dynamic> params = const [],
  ]) async {
    final contract = await getDeployedContract("WorkQuest", addressNewContract);
    final ethFunction = contract.function(function.name);
    handleContract(
      contract: contract,
      function: ethFunction,
      params: params,
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
      final _contractAbi = ContractAbi.fromJson(_abiJson, contractName);
      final _contractAddress = EthereumAddress.fromHex(
        contractAddress,
      );
      final contract = DeployedContract(_contractAbi, _contractAddress);
      return contract;
    } catch (e, tr) {
      print("Error: $e \n Trace: $tr");
      throw Exception("Error Creating Contract");
    }
  }
}

extension CheckAddres on ClientService {
  Future<List<dynamic>> checkAdders(String address) async {
    try {
      final contract =
          await getDeployedContract("WorkQuestFactory", _abiAddress);
      final ethFunction =
          contract.function(WQFContractFunctions.getWorkQuests.name);
      final outputs = await _client.call(
        contract: contract,
        function: ethFunction,
        params: [EthereumAddress.fromHex(address)],
      );

      outputs.forEach((element) {
        print(element);
      });

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
      final outputs = await _client.call(
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
