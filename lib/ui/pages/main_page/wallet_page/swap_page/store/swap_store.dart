import 'dart:math';

import 'package:app/utils/web3_utils.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web3dart/web3dart.dart';

import '../../../../../../constants.dart';
import '../../../../../../http/web3_extension.dart';
import '../../../../../../http/api_provider.dart';
import '../../../../../../web3/repository/account_repository.dart';
import '../../../../../../web3/service/client_service.dart';
import 'package:app/base_store/i_store.dart';

part 'swap_store.g.dart';

enum SwapNetworks { ETH, BSC, POLYGON }

enum SwapToken { tusdt, usdc }

@injectable
class SwapStore extends SwapStoreBase with _$SwapStore {
  SwapStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class SwapStoreBase extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  SwapStoreBase(this._apiProvider);

  ClientService? service;

  double? courseWQT;

  @observable
  SwapNetworks? network;

  @observable
  SwapToken token = SwapToken.tusdt;

  @observable
  double amount = 0.0;

  @observable
  double? maxAmount;

  @observable
  bool isConnect = false;

  @observable
  double? convertWQT;

  @observable
  bool isLoadingCourse = false;

  @observable
  bool isSuccessCourse = false;

  @action
  setToken(SwapToken value) => token = value;

  @action
  setAmount(double value) => amount = value;

  @action
  getMaxBalance() async =>
      maxAmount = await service!.getBalanceFromContract(Web3Utils.getTokenUSDTForSwap(network!), otherNetwork: true);

  @action
  setNetwork(SwapNetworks value) async {
    try {
      onLoading();
      network = value;
      maxAmount = null;
      await _connectRpc();
      isConnect = true;
      onSuccess(false);
    } on FormatException catch (e, trace) {
      print('setNetwork | $e\n$trace');
      isConnect = false;
      onError(e.message);
    } catch (e) {
      isConnect = false;
      onError(e.toString());
    }
  }

  @action
  getCourseWQT({bool isForce = false}) async {
    isLoadingCourse = true;
    isSuccessCourse = false;
    try {
      courseWQT ??= await _apiProvider.getCourseWQT();
      if (isForce) {
        courseWQT = await _apiProvider.getCourseWQT();
      }
      convertWQT = (amount / courseWQT!) * (1 - 0.01);
      isSuccessCourse = true;
    } catch (e, trace) {
      print('getCourseWQT | $e\n$trace');
      onError(e.toString());
    }
    isLoadingCourse = false;
  }

  @action
  createSwap(String address) async {
    try {
      onLoading();
      Web3Client _client = service!.client!;
      final _address = AccountRepository().userWallet!.address!;
      final _privateKey = AccountRepository().userWallet!.privateKey!;
      final _nonce = await _client.getTransactionCount(EthereumAddress.fromHex(_address));
      final _cred = await service!.getCredentials(_privateKey);
      final _gas = await service!.getGas();
      final _chainId = await service!.client!.getChainId();
      final _contract = await _getContract();
      print('price: $amount');
      await _approve();
      final _hashTx = await _client.sendTransaction(
        _cred,
        Transaction.callContract(
          from: EthereumAddress.fromHex(_address),
          contract: _contract,
          function: _contract.function('swap'),
          gasPrice: _gas,
          maxGas: 2000000,
          parameters: [
            ///nonce uint256
            BigInt.from(_nonce),

            ///chainTo uint256
            BigInt.from(1.0),

            ///amount uint256
            BigInt.from(amount * pow(10, 6)),

            ///recipient address
            EthereumAddress.fromHex(address),

            ///userId string
            '1',

            ///symbol string
            'USDT'
          ],
        ),
        chainId: _chainId.toInt(),
      );
      int _attempts = 0;
      while (_attempts < 8) {
        final result = await _client.getTransactionReceipt(_hashTx);
        if (result != null) {
          getMaxBalance();
          onSuccess(true);
          return;
        }
        await Future.delayed(const Duration(seconds: 3));
        _attempts++;
      }
      getMaxBalance();
      onError('Waiting time has expired');
    } catch (e, trace) {
      print('createSwap | e: $e\ntrace: $trace');
      onError(e.toString());
    }
  }

  Future<DeployedContract> _getContract() async {
    final _abiJson = await rootBundle.loadString("assets/contracts/WQBridge.json");
    final _contractAbi = ContractAbi.fromJson(_abiJson, 'WQBridge');
    final _contractAddress = EthereumAddress.fromHex(Web3Utils.getAddressContractForSwap(network!));
    return DeployedContract(_contractAbi, _contractAddress);
  }

  _connectRpc() async {
    if (service != null) {
      service!.client?.dispose();
      service!.client = null;
      service = null;
    }
    service = ClientService(
      Configs.configsNetwork[NetworkName.workNetMainnet]!,
      customRpc: Web3Utils.getRpcNetworkForSwap(network!),
    );
    await Future.delayed(const Duration(seconds: 2));
    await getMaxBalance();
  }

  _approve() async {
    final contract = Erc20(
      address: EthereumAddress.fromHex(Web3Utils.getTokenUSDTForSwap(network!)),
      client: service!.client!,
    );
    final _cred = await service!.getCredentials(AccountRepository().userWallet!.privateKey!);
    final _spender = EthereumAddress.fromHex(Web3Utils.getAddressContractForSwap(network!));
    final _gas = await service!.getGas();
    await contract.approve(
      _spender,
      BigInt.from(amount * pow(10, 6)),
      credentials: _cred,
      transaction: Transaction(
        gasPrice: _gas,
        maxGas: 2000000,
        value: EtherAmount.zero(),
      ),
    );
  }

  @action
  clearData() {
    if (service != null) {
      service?.client?.dispose();
    }
    service = null;
    courseWQT = null;
    network = null;
    amount = 0.0;
    maxAmount = null;
    isConnect = false;
    convertWQT = null;
    isLoadingCourse = false;
    isSuccessCourse = false;
  }
}
