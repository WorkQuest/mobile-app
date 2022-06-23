import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:app/utils/web3_utils.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:flutter/services.dart';
import 'package:hex/hex.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:web_socket_channel/io.dart';
import '../../constants.dart';
import '../contractEnums.dart';

abstract class ClientServiceI {
  Future<num> getBalanceInUnit(EtherUnit unit, String privateKey);

  Future<EthPrivateKey> getCredentials(String privateKey);

  Future<double> getBalanceFromContract(String address);

  Future<EtherAmount> getBalance(String privateKey);

  Future<String> getSignature(String privateKey);

  Future<EtherAmount> getGas();

  Future<BigInt> getEstimateGas(Transaction transaction);

  Future<double> getEstimateGasCallContract({
    required DeployedContract contract,
    required ContractFunction function,
    required List<dynamic> params,
  });

  Future sendTransaction({
    required bool isToken,
    required String address,
    required String amount,
    required TokenSymbols coin,
  });
}

class ClientService implements ClientServiceI {
  final int _chainId = 1991;

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

  @override
  Future<EthPrivateKey> getCredentials(String privateKey) async {
    return EthPrivateKey.fromHex(privateKey);
  }

  @override
  Future sendTransaction({
    required bool isToken,
    required String address,
    required String amount,
    required TokenSymbols coin,
  }) async {
    String? hash;
    final _privateKey = AccountRepository().privateKey;
    final _credentials = await getCredentials(_privateKey);
    if (!isToken) {
      final _value = EtherAmount.fromUnitAndValue(
        EtherUnit.wei,
        BigInt.from(double.parse(amount) * pow(10, 18)),
      );
      final _to = EthereumAddress.fromHex(address);
      final _from = EthereumAddress.fromHex(AccountRepository().userAddress);
      hash = await client!.sendTransaction(
        _credentials,
        Transaction(
          to: _to,
          from: _from,
          value: _value,
        ),
        chainId: _chainId,
      );
    } else {
      String _addressToken = Web3Utils.getAddressToken(coin);
      final _degree = Web3Utils.getDegreeToken(coin);
      final contract = Erc20(address: EthereumAddress.fromHex(_addressToken), client: client!);
      hash = await contract.transfer(
        EthereumAddress.fromHex(address),
        BigInt.from(double.parse(amount) * pow(10, _degree)),
        credentials: _credentials,
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
  Future<double> getBalanceFromContract(String address, {bool otherNetwork = false, bool isUSDT = false}) async {
    try {
      address = address.toLowerCase();
      final contract = Erc20(address: EthereumAddress.fromHex(address), client: client!);
      final balance = await contract.balanceOf(EthereumAddress.fromHex(AccountRepository().userWallet!.address!));
      if (otherNetwork || isUSDT) {
        return balance.toDouble() * pow(10, -6);
      }

      return balance.toDouble() * pow(10, -18);
    } catch (e, trace) {
      print('e: $e\ntrace: $trace');
      throw FormatException("Error connection to network");
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
  Future<num> getBalanceInUnit(EtherUnit unit, String privateKey) async {
    final balance = await getBalance(privateKey);
    return balance.getValueInUnit(unit);
  }

  @override
  Future<BigInt> getEstimateGas(Transaction transaction) async {
    return await client!.estimateGas(
        sender: transaction.from,
        to: transaction.to,
        gasPrice: transaction.gasPrice,
        value: transaction.value,
        data: transaction.data,
        amountOfGas: transaction.gasPrice?.getInWei);
  }

  @override
  Future<double> getEstimateGasCallContract(
      {required DeployedContract contract, required ContractFunction function, required List params}) async {
    final _gas = await getGas();
    final _estimateGas = await getEstimateGas(Transaction.callContract(
      contract: contract,
      function: function,
      parameters: params,
      from: EthereumAddress.fromHex(AccountRepository().userAddress),
    ));
    return (_estimateGas * _gas.getInWei).toDouble() * pow(10, -18);
  }

  Future<double> getEstimateGasForApprove(BigInt price) async {
    final _addressWUSD = Configs.configsNetwork[ConfigNameNetwork.testnet]!.dataCoins
        .firstWhere((element) => element.symbolToken == TokenSymbols.WUSD)
        .addressToken;
    print('_addressWUSD: $_addressWUSD');
    final _contractApprove = await getDeployedContract("WQBridgeToken", _addressWUSD!);
    final _gasForApprove = await getEstimateGasCallContract(
      contract: _contractApprove,
      function: _contractApprove.function(WQBridgeTokenFunctions.approve.name),
      params: [
        EthereumAddress.fromHex(Constants.worknetWQFactory),
        price,
      ],
    );
    return _gasForApprove;
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
    required BigInt price,
    required String deadline,
    required String nonce,
  }) async {
    print('createNewContract');
    final credentials = await getCredentials(AccountRepository().privateKey);
    final contract = await getDeployedContract("WorkQuestFactory", Constants.worknetWQFactory);
    final ethFunction = contract.function(WQFContractFunctions.newWorkQuest.name);
    final fromAddress = await credentials.extractAddress();
    await handleContract(
      contract: contract,
      function: ethFunction,
      params: [
        stringToBytes32(jobHash),
        price,
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
      final _abiJson = await rootBundle.loadString("assets/contracts/$contractName.json");
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
    required BigInt price,
  }) async {
    final credentials = await getCredentials(AccountRepository().privateKey);
    final _addressWUSD = Configs.configsNetwork[ConfigNameNetwork.testnet]!.dataCoins
        .firstWhere((element) => element.symbolToken == TokenSymbols.WUSD)
        .addressToken;
    final contract = await getDeployedContract("WQBridgeToken", _addressWUSD!);
    final ethFunction = contract.function(WQBridgeTokenFunctions.approve.name);
    final fromAddress = await credentials.extractAddress();
    print('fromAddress: $fromAddress');
    print('chainID: ${await client!.getChainId()}');
    final result = await handleContract(
      contract: contract,
      function: ethFunction,
      from: fromAddress,
      params: [
        EthereumAddress.fromHex(Constants.worknetWQFactory),
        price,
      ],
    );
    print('result.status: ${result.status}');
    if (result.status ?? false)
      return true;
    else
      return false;
  }

  Future<BigInt> allowanceCoin() async {
    print("Allowance coin");
    final _addressWUSD = Configs.configsNetwork[ConfigNameNetwork.testnet]!.dataCoins
        .firstWhere((element) => element.symbolToken == TokenSymbols.WUSD)
        .addressToken;

    final _contract = Erc20(address: EthereumAddress.fromHex(_addressWUSD!), client: client!);
    final _result = await _contract.allowance(
      EthereumAddress.fromHex(AccountRepository().userAddress),
      EthereumAddress.fromHex(Constants.worknetWQFactory),
    );
    return _result;
  }
}

extension CheckFunction on ClientService {
  void checkFunction() async {
    try {
      final contract = await getDeployedContract("WQBridgeToken", "0xD92E713d051C37EbB2561803a3b5FBAbc4962431");
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
      final contract = await getDeployedContract("WorkQuestFactory", Constants.worknetWQFactory);
      final ethFunction = contract.function(WQFContractFunctions.getWorkQuests.name);
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
    final contract = await getDeployedContract("WQPromotion", Constants.worknetPromotion);
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
  }) async {
    print('tariff: $tariff');
    print('period: $period');
    final contract = await getDeployedContract("WQPromotion", Constants.worknetPromotion);
    final function = contract.function(WQPromotionFunctions.promoteUser.name);
    final _credentials = await getCredentials(AccountRepository().privateKey);
    final _gasPrice = await client!.getGasPrice();
    final _fromAddress = await _credentials.extractAddress();
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

extension Custom on EtherAmount {}
