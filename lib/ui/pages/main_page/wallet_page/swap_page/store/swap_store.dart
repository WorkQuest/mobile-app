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

  @computed
  bool get statusSend => isSuccessCourse && maxAmount != null && isConnect && convertWQT != null;

  ClientService get service => AccountRepository().getClient();

  @action
  setToken(SwapToken value) => token = value;

  @action
  setAmount(double value) => amount = value;

  @action
  getMaxBalance() async {
    final _result = await service.getBalanceFromContract(Web3Utils.getTokenUSDTForSwap(network!));
    maxAmount = _result.toDouble();
  }

  @action
  setNetwork(SwapNetworks? value) async {
    try {
      onLoading();
      network = value;
      maxAmount = null;
      isConnect = false;
      convertWQT = null;
      isSuccessCourse = false;
      if (value == null) {
        isLoading = false;
        return;
      }
      final _networkName = Web3Utils.getNetworkNameFromSwapNetworks(network!);
      AccountRepository().changeNetwork(_networkName);
      await getMaxBalance();
      isConnect = true;
      onSuccess(false);
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
    } catch (e) {
      // print('getCourseWQT | $e\n$trace');
    }
    isLoadingCourse = false;
  }

  @action
  createSwap() async {
    try {
      onLoading();
      Web3Client _client = service.client!;
      final _address = AccountRepository().userWallet!.address!;
      final _privateKey = AccountRepository().userWallet!.privateKey!;
      final _nonce = await _client.getTransactionCount(EthereumAddress.fromHex(_address));
      final _cred = await service.getCredentials(_privateKey);
      final _gas = await service.getGas();
      final _chainId = await service.client!.getChainId();
      final _contract = await _getContract();
      final _contractToken = Erc20(
        address: EthereumAddress.fromHex(Web3Utils.getTokenUSDTForSwap(network!)),
        client: service.client!,
      );
      final _degree = await Web3Utils.getDegreeToken(_contractToken);
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
            BigInt.from(amount * pow(10, _degree)),

            ///recipient address
            EthereumAddress.fromHex(AccountRepository().userAddress),

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
      final _link = Web3Utils.getLinkToExplorer(network!, _hashTx);
      onError('Waiting time has expired\n\nYou can check the transaction status in the explorer: \n $_link');
    } catch (e) {
      // print('createSwap | e: $e\ntrace: $trace');
      onError(e.toString());
    }
  }

  approve() async {
    final contract = Erc20(
      address: EthereumAddress.fromHex(Web3Utils.getTokenUSDTForSwap(network!)),
      client: service.client!,
    );
    final _cred = await service.getCredentials(AccountRepository().userWallet!.privateKey!);
    final _spender = EthereumAddress.fromHex(Web3Utils.getAddressContractForSwap(network!));
    final _gas = await service.getGas();
    final _degree = await Web3Utils.getDegreeToken(contract);
    final _txHashApprove = await contract.approve(
      _spender,
      BigInt.from(amount * pow(10, _degree)),
      credentials: _cred,
      transaction: Transaction(
        gasPrice: _gas,
        maxGas: 2000000,
        value: EtherAmount.zero(),
      ),
    );
    int _attempts = 0;
    while (_attempts < 8) {
      final result = await service.client!.getTransactionReceipt(_txHashApprove);
      if (result != null) {
        getMaxBalance();
        onSuccess(true);
        return;
      }
      await Future.delayed(const Duration(seconds: 3));
      _attempts++;
    }
  }

  Future<bool> needApprove() async {
    final _contract = Erc20(
      address: EthereumAddress.fromHex(Web3Utils.getTokenUSDTForSwap(network!)),
      client: service.client!,
    );
    final _degree = await Web3Utils.getDegreeToken(_contract);
    final _amount = BigInt.from(amount * pow(10, _degree));
    final _spender = EthereumAddress.fromHex(Web3Utils.getAddressContractForSwap(network!));
    final _allowance = await _contract.allowance(
      EthereumAddress.fromHex(AccountRepository().userAddress),
      _spender,
    );
    if (_allowance < _amount) {
      return true;
    }
    return false;
  }

  Future<BigInt> amountToken() async {
    final _contract = Erc20(
      address: EthereumAddress.fromHex(Web3Utils.getTokenUSDTForSwap(network!)),
      client: service.client!,
    );
    final _degree = await Web3Utils.getDegreeToken(_contract);
    return BigInt.from(amount * pow(10, _degree));
  }

  Future<DeployedContract> _getContract() async {
    final _abiJson = await rootBundle.loadString("assets/contracts/WQBridge.json");
    final _contractAbi = ContractAbi.fromJson(_abiJson, 'WQBridge');
    final _contractAddress = EthereumAddress.fromHex(Web3Utils.getAddressContractForSwap(network!));
    return DeployedContract(_contractAbi, _contractAddress);
  }

  Future<String> getEstimateGasApprove() async {
    final _contract = Erc20(
      address: EthereumAddress.fromHex(Web3Utils.getTokenUSDTForSwap(network!)),
      client: service.client!,
    );
    final _cred = await service.getCredentials(AccountRepository().userWallet!.privateKey!);
    final _spender = EthereumAddress.fromHex(Web3Utils.getAddressContractForSwap(network!));
    final _degree = await Web3Utils.getDegreeToken(_contract);
    final _estimateGas = await service.getEstimateGas(
      Transaction.callContract(
        contract: _contract.self,
        function: _contract.self.function('approve'),
        parameters: [
          _spender,
          BigInt.from(amount * pow(10, _degree)),
        ],
        from: _cred.address,
      ),
    );
    final _gas = await service.getGas();
    final _fee = Web3Utils.getGas(
      estimateGas: _estimateGas,
      gas: _gas.getInWei,
      degree: 18,
      isETH: network == SwapNetworks.ETH,
    );
    await Web3Utils.checkPossibilityTx(typeCoin: TokenSymbols.USDT, amount: amount, fee: _fee);
    return ((_estimateGas * _gas.getInWei).toDouble() * pow(10, -18)).toStringAsFixed(17);
  }

  Future<String> getEstimateGasSwap() async {
    final _address = AccountRepository().userWallet!.address!;
    final _nonce = await service.client!.getTransactionCount(EthereumAddress.fromHex(_address));
    final _gas = await service.getGas();
    final _contract = await _getContract();
    final _contractToken = Erc20(
      address: EthereumAddress.fromHex(Web3Utils.getTokenUSDTForSwap(network!)),
      client: service.client!,
    );
    final _degree = await Web3Utils.getDegreeToken(_contractToken);
    final _estimateGas = await service.getEstimateGas(
      Transaction.callContract(
        from: EthereumAddress.fromHex(_address),
        contract: _contract,
        function: _contract.function('swap'),
        parameters: [
          ///nonce uint256
          BigInt.from(_nonce),

          ///chainTo uint256
          BigInt.from(1.0),

          ///amount uint256
          BigInt.from(amount * pow(10, _degree)),

          ///recipient address
          EthereumAddress.fromHex(AccountRepository().userAddress),

          ///userId string
          '1',

          ///symbol string
          'USDT'
        ],
      ),
    );
    final _fee = Web3Utils.getGas(
      estimateGas: _estimateGas,
      gas: _gas.getInWei,
      degree: 18,
      isETH: network == SwapNetworks.ETH,
    );
    await Web3Utils.checkPossibilityTx(typeCoin: TokenSymbols.USDT, amount: amount, fee: _fee);
    return ((_estimateGas * _gas.getInWei).toDouble() * pow(10, -18)).toStringAsFixed(17);
  }

  @action
  clearData() {
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
