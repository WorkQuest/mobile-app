import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:app/web3/contractEnums.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   Web3().createNewQuestContract([
//     intToBytes(BigInt.one),
//   ]);
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
}

extension CreateQuestContract on Web3 {
  Uint8List stringToBytes32(String text) {
    Uint8List bytes32 = Uint8List.fromList(
      utf8.encode(text.padRight(32).substring(0, 32)),
    );
    return bytes32;
  }

  ///Create New Quest Contract
  Future<List<dynamic>> createNewQuestContract({
    required String jobHash,
    required String cost,
    required String deadline,
    required String nonce,
  }) async {
    try {
      final credentials = await _client.credentialsFromPrivateKey(
          "9ebd61de03a9407ee584dc8895afb5778164860d4ec07657dee113d805cae494");
      final _gasPrice = await _client.getGasPrice();
      final contract =
          await getDeployedContract("WorkQuestFactory", _abiAddress);
      final ethFunction =
          contract.function(WQFContractFunctions.newWorkQuest.name);
      final fromAddress = await credentials.extractAddress();
      final depositAmount = (double.parse(cost) * 1.01) * pow(10, 18);

      final transactionHash = await _client.sendTransaction(
        credentials,
        Transaction.callContract(
          value: EtherAmount.inWei(
            BigInt.parse(depositAmount.ceil().toString()),
          ),
          contract: contract,
          from: fromAddress,
          gasPrice: _gasPrice,
          function: ethFunction,
          maxGas: 2000000,
          parameters: [
            stringToBytes32(jobHash),
            BigInt.parse(cost),
            BigInt.parse(deadline),
            BigInt.parse(nonce),
          ],
        ),
        chainId: _chainId,
      );

      print("transactionHash: $transactionHash");
      TransactionReceipt? error;

      Timer.periodic(Duration(seconds: 10), (timer) async {
        timer.cancel();
        error = await _client.getTransactionReceipt(transactionHash);

        print("getTransactionReceipt: ${error!.logs[0].address}");
      });
      return [];
    } catch (e, tr) {
      print("ERROR TEXT $e trace$tr");
      throw Exception("Unable to call");
    }
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
      print("Error$e Trace$tr");
      throw Exception("Error Creating Contract");
    }
  }
}

extension WorkQuestEvent on Web3 {
  Future<void> handleEvent(
    WQContractFunctions function, [
    List<dynamic> input = const [],
  ]) async {
    try {
      final contract = await getDeployedContract("WorkQuest", "");
      final ethFunction = contract.function(function.name);
      await _client.call(
        contract: contract,
        function: ethFunction,
        params: input,
      );
    } catch (e, tr) {
      print("Error$e Trace$tr");
      throw Exception("Error handling event");
    }
  }
}

extension MakeTransaction on Web3 {
  Future<EthereumAddress> getPublicAddress(String privateKey) async {
    try {
      final address = await EthPrivateKey.fromHex(privateKey).extractAddress();
      return address;
    } catch (e) {
      print(e);
      throw Exception("Error getting address");
    }
  }
}
