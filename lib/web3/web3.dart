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
  static final url = "https://dev-node-nyc3.workquest.co";
  final _abiAddress = EthereumAddress.fromHex(
    '0xF38E33e7DD7e1a91c772aF51A366cd126e4552BB',
  );

  final Web3Client _client = Web3Client(
    url,
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
  Future<List<dynamic>> createNewQuestContract(
    List<dynamic> arguments,
  ) async {
    try {
      // makeTransaction(2000);
      final credentials = await _client.credentialsFromPrivateKey(
          "9ebd61de03a9407ee584dc8895afb5778164860d4ec07657dee113d805cae494");
      final _gasPrice = await _client.getGasPrice();
      final contract = await getDeployedContract("WorkQuestFactory");
      final ethFunction =
          contract.function(WQFContractFunctions.newWorkQuest.name);
      final from = await credentials.extractAddress();
      final depositAmount = (double.parse(arguments[1]) * 1.01) * pow(10, 18);

      final transactionHash = await _client.sendTransaction(
        credentials,
        Transaction.callContract(
          value:
              EtherAmount.inWei(BigInt.parse(depositAmount.ceil().toString())),
          //EtherAmount.fromUnitAndValue(EtherUnit.ether, depositAmount),
          contract: contract,
          from: from,
          gasPrice: _gasPrice,
          function: ethFunction,
          maxGas: 2000000,
          parameters: [
            stringToBytes32(arguments[0]),
            BigInt.parse(arguments[1]),
            BigInt.parse(arguments[2].toString()),
            BigInt.parse(arguments[3].toString()),
          ],
        ),
        chainId: 20220112,
      );

      print("transactionHash: $transactionHash");
      TransactionReceipt? error;

      Timer.periodic(Duration(seconds: 10), (timer) async {
        timer.cancel();
        error = await _client.getTransactionReceipt(transactionHash);

        print("getTransactionReceipt: ${error!.logs[0].address}");
      });
      // List<dynamic> arguments = [
      //   stringToBytes32("Work"),
      //   BigInt.parse("3000").toUnsigned(256),
      //   BigInt.parse("3000").toUnsigned(256),
      //   BigInt.parse("3000").toUnsigned(256),
      // ];
      // final contract = await getDeployedContract("WorkQuestFactory");
      // final ethFunction = contract.function(WQFContractFunctions.referral.name);
      // final result = await _client.call(
      //   contract: contract,
      //   function: ethFunction,
      //   params: [],
      // );
      //  print("qwe123 ${result.first}");
      return [];
    } catch (e, tr) {
      print("ERROR TEXT $e trace$tr");
      throw Exception("Unable to call");
    }
  }
}
extension qweqweqw on Web3 {

}

extension GetContract on Web3 {
  Future<DeployedContract> getDeployedContract(String contractName) async {
    try {
      final _abiJson =
          await rootBundle.loadString("assets/contracts/$contractName.json");
      final _contractAbi = ContractAbi.fromJson(_abiJson, contractName);
      final contract = DeployedContract(_contractAbi, _abiAddress);
      return contract;
    } catch (e, tr) {
      print("Error$e Trace$tr");
      throw Exception("Error Creating Contract");
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

// Future<void> makeTransaction(double depositAmount) async {
//   try {
//
//   } catch (e, tr) {
//     print("Error$e Trace$tr");
//     throw Exception("Transaction Error");
//   }
// }
}
