import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:app/model/web3/transactions_response.dart';
import 'package:app/ui/pages/main_page/tabs/wallet/pages/swap_page/store/swap_store.dart';
import 'package:app/ui/pages/main_page/tabs/wallet/pages/wallet_page/store/wallet_store.dart';
import 'package:app/ui/pages/main_page/tabs/wallet/pages/wallet_page/widgets/list_transactions/store/transactions_store.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:app/web3/repository/wallet_repository.dart';
import 'package:app/web3/service/address_service.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
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

  Future<Decimal> getBalanceFromContract(String address);

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
    required String addressTo,
    required String amount,
    required TokenSymbols coin,
  });
}

class ClientService implements ClientServiceI {
  Web3Client? client;
  StreamSubscription<String>? stream;

  ClientService(ConfigNetwork config) {
    try {
      client = Web3Client(config.rpc, Client(), socketConnector: () {
        return IOWebSocketChannel.connect(config.wss).cast<String>();
      });
      if (WalletRepository().isOtherNetwork) {
        Future.delayed(const Duration(seconds: 2)).then((value) {
          try {
            final _stream = client!.socketConnector!.call();
            _stream.sink.add("""
          {
            "jsonrpc": "2.0",
            "method": "eth_subscribe",
            "id": 1,
            "params": ["newHeads"]
          }
        """);
            stream = _stream.stream.listen((event) {
              final _walletStore = GetIt.I.get<WalletStore>();
              if (!_walletStore.isLoading) {
                print('getCoins from webSocket');
                _walletStore.getCoins(isForce: false, fromSwap: true);
              }
              final _swapStore = GetIt.I.get<SwapStore>();
              if (_swapStore.network != null && !_swapStore.isLoading) {
                _swapStore.getMaxBalance();
              }
            });
          } catch (e) {
            // print('ethClient!.socketConnector!.call | $e\n$trace');
          }
        });
      }
    } catch (e) {
      // print('e -> $e\ntrace -> $trace');
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
    required String addressTo,
    required String amount,
    required TokenSymbols coin,
  }) async {
    String? hash;
    int? degree;
    final _privateKey = WalletRepository().privateKey;
    final _credentials = await getCredentials(_privateKey);
    String _addressToken = Web3Utils.getAddressToken(coin);
    final _from = EthereumAddress.fromHex(WalletRepository().userAddress);
    final _gas = await getGas();
    final _isETH = Web3Utils.isETH();
    final _gasPrice = EtherAmount.fromUnitAndValue(
      EtherUnit.wei,
      ((Decimal.fromBigInt(_gas.getInWei) *
              Decimal.parse(_isETH ? '1.05' : '1.0'))
          .toBigInt()),
    );
    if (!isToken) {
      final _value = EtherAmount.fromUnitAndValue(
        EtherUnit.wei,
        (Decimal.parse(amount) * Decimal.fromInt(10).pow(18)).toBigInt(),
      );
      final _to = EthereumAddress.fromHex(addressTo);
      final _from = EthereumAddress.fromHex(WalletRepository().userAddress);
      final _chainId = await client!.getChainId();
      hash = await client!.sendTransaction(
        _credentials,
        Transaction(
          to: _to,
          from: _from,
          value: _value,
          gasPrice: _gasPrice,
        ),
        chainId: _chainId.toInt(),
      );
    } else {
      final contract = Erc20(
          address: EthereumAddress.fromHex(_addressToken), client: client!);
      degree = await Web3Utils.getDegreeToken(contract);
      hash = await contract.transfer(
        EthereumAddress.fromHex(addressTo),
        BigInt.from(double.parse(amount) * pow(10, degree)),
        credentials: _credentials,
        transaction: Transaction(
          from: _from,
          gasPrice: _gasPrice,
        ),
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
      if (attempts == 20) {
        throw FormatException(
            "The waiting time is over. Expect a balance update.");
      }
    }
    final _tx = Tx(
      hash: hash,
      fromAddressHash: AddressHash(
        bech32: AddressService.hexToBech32(WalletRepository().userAddress),
        hex: WalletRepository().userAddress,
      ),
      toAddressHash: AddressHash(
        bech32: AddressService.hexToBech32(isToken ? _addressToken : addressTo),
        hex: isToken ? _addressToken : addressTo,
      ),
      amount: isToken
          ? null
          : (Decimal.parse(amount) * Decimal.fromInt(10).pow(18)).toString(),
      insertedAt: DateTime.now(),
      block: Block(timestamp: DateTime.now()),
      tokenTransfers: !isToken
          ? null
          : [
              TokenTransfer(
                amount:
                    (Decimal.parse(amount) * Decimal.fromInt(10).pow(degree!))
                        .toString(),
              ),
            ],
    );
    GetIt.I.get<TransactionsStore>().addTransaction(_tx);
  }

  @override
  Future<Decimal> getBalanceFromContract(String address,
      {bool otherNetwork = false, bool isUSDT = false}) async {
    address = address.toLowerCase();
    final contract =
        Erc20(address: EthereumAddress.fromHex(address), client: client!);
    final balance = await contract.balanceOf(
        EthereumAddress.fromHex(WalletRepository().userWallet!.address!));
    final _degree = await Web3Utils.getDegreeToken(contract);
    return (Decimal.parse(balance.toString()) /
            Decimal.fromInt(10).pow(_degree))
        .toDecimal();
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
  Future<double> getEstimateGasCallContract({
    required DeployedContract contract,
    required ContractFunction function,
    required List params,
    String? value,
  }) async {
    final _gas = await getGas();
    final _estimateGas = await getEstimateGas(Transaction.callContract(
      contract: contract,
      function: function,
      parameters: params,
      from: EthereumAddress.fromHex(WalletRepository().userAddress),
      value: value != null
          ? EtherAmount.fromUnitAndValue(
              EtherUnit.wei,
              BigInt.from(double.parse(value) * pow(10, 18)),
            )
          : null,
    ));
    return (Decimal.fromBigInt(_estimateGas) *
            Decimal.fromBigInt(_gas.getInWei) /
            Decimal.fromInt(10).pow(18))
        .toDouble();
  }

  Future<double> getEstimateGasForApprove(BigInt price) async {
    final _addressWUSD = Web3Utils.getAddressWUSD();
    final _contract =
        Erc20(address: EthereumAddress.fromHex(_addressWUSD), client: client!);
    final _gasForApprove = await getEstimateGasCallContract(
      contract: _contract.self,
      function: _contract.self.function(WQBridgeTokenFunctions.approve.name),
      params: [
        EthereumAddress.fromHex(Web3Utils.getAddressWorknetWQFactory()),
        price,
      ],
    );
    return _gasForApprove;
  }
}

extension CreateQuestContract on ClientService {
  Uint8List stringToBytes32(String text) {
    final _bytes = text.padRight(32).codeUnits;
    final result = Uint8List.fromList(_bytes);
    return result;
  }

  Future<TransactionReceipt> handleContract({
    required DeployedContract contract,
    required ContractFunction function,
    required List<dynamic> params,
    EthereumAddress? from,
    EtherAmount? value,
  }) async {
    try {
      final credentials = await getCredentials(WalletRepository().privateKey);
      final _gasPrice = await client!.getGasPrice();
      final _chainId = await client!.getChainId();
      final transactionHash = await client!.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: function,
          gasPrice: _gasPrice,
          parameters: params,
          from: from,
          value: value,
        ),
        chainId: _chainId.toInt(),
      );

      print("transactionHash: $transactionHash");

      int attempts = 0;
      TransactionReceipt? result;
      while (result == null) {
        result = await client!.getTransactionReceipt(transactionHash);
        if (result != null) print('Block: ${result.blockNumber}');
        await Future.delayed(const Duration(seconds: 3));
        attempts++;
        if (attempts == 20) {
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
    final credentials = await getCredentials(WalletRepository().privateKey);
    final contract = await getDeployedContract(
        "WorkQuestFactory", Web3Utils.getAddressWorknetWQFactory());
    final ethFunction =
        contract.function(WQFContractFunctions.newWorkQuest.name);
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
    String? value,
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
    } catch (e) {
      throw Exception("Error Creating Contract");
    }
  }
}

extension ApproveCoin on ClientService {
  Future<bool> approveCoin({
    required BigInt price,
    EthereumAddress? address,
  }) async {
    final credentials = await getCredentials(WalletRepository().privateKey);
    final _addressWUSD = Web3Utils.getAddressWUSD();
    final contract =
        Erc20(address: EthereumAddress.fromHex(_addressWUSD), client: client!);
    final hashTx = await contract.approve(
      address ??
          EthereumAddress.fromHex(Web3Utils.getAddressWorknetWQFactory()),
      price,
      credentials: credentials,
    );
    int attempts = 0;
    TransactionReceipt? result;
    while (result == null) {
      result = await client!.getTransactionReceipt(hashTx);
      if (result != null) print('Block: ${result.blockNumber}');
      await Future.delayed(const Duration(seconds: 3));
      attempts++;
      if (attempts == 20) {
        throw Exception("The waiting time is over. Expect a balance update.");
      }
    }
    return true;
  }

  Future<BigInt> allowanceCoin({EthereumAddress? address}) async {
    final _address = Web3Utils.getAddressWUSD();

    final _contract =
        Erc20(address: EthereumAddress.fromHex(_address), client: client!);
    final _result = await _contract.allowance(
      EthereumAddress.fromHex(WalletRepository().userAddress),
      address ??
          EthereumAddress.fromHex(Web3Utils.getAddressWorknetWQFactory()),
    );
    return _result;
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
      final contract = await getDeployedContract(
          "WorkQuestFactory", Web3Utils.getAddressWorknetWQFactory());
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

extension Promote on ClientService {
  Future<TransactionReceipt?> promoteQuest({
    required int tariff,
    required int period,
    required String questAddress,
  }) async {
    print('tariff: $tariff');
    print('period: $period');
    print('questAddress: $questAddress');
    final contract = await getDeployedContract(
        "WQPromotion", Web3Utils.getAddressWorknetWQPromotion());
    final function = contract.function(WQPromotionFunctions.promoteQuest.name);
    final _credentials = await getCredentials(WalletRepository().privateKey);
    final _gasPrice = await client!.getGasPrice();
    final _fromAddress = await _credentials.extractAddress();
    final _chainId = await client!.getChainId();
    final _transactionHash = await client!.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: contract,
        function: function,
        maxGas: 200000,
        gasPrice: _gasPrice,
        parameters: [
          EthereumAddress.fromHex(questAddress),
          BigInt.from(tariff),
          BigInt.from(period),
        ],
        from: _fromAddress,
        value: EtherAmount.zero(),
      ),
      chainId: _chainId.toInt(),
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
      if (attempts == 20) {
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
    final contract = await getDeployedContract(
      "WQPromotion",
      Web3Utils.getAddressWorknetWQPromotion(),
    );
    final function = contract.function(WQPromotionFunctions.promoteUser.name);
    final _credentials = await getCredentials(WalletRepository().privateKey);
    final _gasPrice = await client!.getGasPrice();
    final _fromAddress = await _credentials.extractAddress();
    final _chainId = await client!.getChainId();
    final _transactionHash = await client!.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: contract,
        function: function,
        gasPrice: _gasPrice,
        parameters: [
          BigInt.from(tariff),
          BigInt.from(period),
        ],
        from: _fromAddress,
        value: EtherAmount.zero(),
      ),
      chainId: _chainId.toInt(),
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
      if (attempts == 20) {
        throw Exception("The waiting time is over. Expect a balance update.");
      }
    }
    return result;
  }

  clearData() {
    stream?.cancel();
  }
}
