import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:app/web3/contractEnums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // Web3().checkStatus();
//   // Web3().checkAdders("0x35850a45704ed980fa2267c328a575e982c4fa38");
//   // Web3().handleEvent(WQContractFunctions.assignJob, [
//   //   EthereumAddress.fromHex("0x35850a45704ed980fa2267c328a575e982c4fa38")
//   // ]);
//   // Web3().createNewQuestContract(
//   //   jobHash: "qwe",
//   //   cost: "1",
//   //   deadline: "0",
//   //   nonce: "qwe ",
//   // );
// }

@singleton
class Web3 {
  //Inject store to get contract details and user address
  static final _url = "https://dev-node-nyc3.workquest.co";
  final int _chainId = 20220112;
  final _abiAddress = '0xF38E33e7DD7e1a91c772aF51A366cd126e4552BB';

  final Web3Client _client = Web3Client(
    _url,
    Client(),
  );

  //void createNewQuestContract({String jobHash, String cost, String deadline, String nonce}) {}
}

extension CreateQuestContract on Web3 {
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
      final credentials = await _client.credentialsFromPrivateKey(
          "private key");
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
        TransactionReceipt transactionReceipt =
            await _client.getTransactionReceipt(transactionHash);

        print("Logs:");
        transactionReceipt.logs.forEach((element) {
          print(element);
        });
        checkStatus();
      });
      return [];
    } catch (e, tr) {
      print("ERROR: $e \n trace: $tr");
      throw Exception("Unable to call");
    }
  }
}

extension CreateContract on Web3 {
  Future<void> createNewContract({
    required String jobHash,
    required String cost,
    required String deadline,
    required String nonce,
  }) async {
    final credentials = await _client.credentialsFromPrivateKey(
        "private key");
    final contract = await getDeployedContract("WorkQuestFactory", _abiAddress);
    final ethFunction =
        contract.function(WQFContractFunctions.newWorkQuest.name);
    final fromAddress = await credentials.extractAddress();
    final depositAmount = (double.parse(cost) * 1.01) * pow(10, 18);
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
  }
}

extension HandleEvent on Web3 {
  Future<void> handleEvent(
    WQContractFunctions function, [
    List<dynamic> params = const [],
  ]) async {
    final contract = await getDeployedContract(
        "WorkQuest", "contract address");
    final ethFunction = contract.function(function.name);
    handleContract(
      contract: contract,
      function: ethFunction,
      params: params,
    );
  }
}

extension GetContract on Web3 {
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

extension CheckAddres on Web3 {
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

extension CheckStatus on Web3 {
  Future<List<dynamic>> checkStatus() async {
    try {
      final contract = await getDeployedContract(
          "WorkQuest", "0x29872f1b96d6ed0c118c93df23c8281de70cde04");
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

// extension WorkQuestEvent on Web3 {
//   Future<void> handleEvent(
//     WQContractFunctions function, [
//     List<dynamic>? input,
//   ]) async {
//     try {
//       final contract = await getDeployedContract(
//           "WorkQuest", "0x2e4ea468eed8a4f637655f142619e8f29ea9fe31");
//       final ethFunction = contract.function(function.name);
//       final result = await _client.call(
//         contract: contract,
//         function: ethFunction,
//         params: input ?? [],
//       );
//       result.forEach((element) {
//         print(element);
//       });
//     } catch (e, tr) {
//       print("Error: $e \n Trace: $tr");
//       throw Exception("Error handling event");
//     }
//   }
// }

// extension MakeTransaction on Web3 {
//   Future<EthereumAddress> getPublicAddress(String privateKey) async {
//     try {
//       final address = await EthPrivateKey.fromHex(privateKey).extractAddress();
//       return address;
//     } catch (e) {
//       print(e);
//       throw Exception("Error getting address");
//     }
//   }
// }
