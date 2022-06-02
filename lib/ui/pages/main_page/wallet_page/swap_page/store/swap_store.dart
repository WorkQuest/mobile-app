import 'package:app/web3/service/client_service.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:web3dart/web3dart.dart';
import 'package:app/base_store/i_store.dart';

import '../../../../../../../constants.dart';
import '../../../../../../../web3/repository/account_repository.dart';

part 'swap_store.g.dart';

enum SwapNetworks { ethereum, binance, matic }

enum SwapToken { tusdt, usdc }

@injectable
class SwapStore extends SwapStoreBase with _$SwapStore {}

abstract class SwapStoreBase extends IStore<bool> with Store {
  ClientService? service;

  @observable
  SwapNetworks? network;

  @observable
  SwapToken token = SwapToken.tusdt;

  @observable
  double amount = 0.0;

  @observable
  double maxAmount = 1000.0;

  @observable
  bool isConnect = false;

  @action
  setNetwork(SwapNetworks value) async {
    try {
      this.onLoading();
      network = value;
      await _connectRpc();
      isConnect = true;
      this.onSuccess(true);
    } catch (e) {
      isConnect = false;
      this.onError(e.toString());
    }
  }

  @action
  setToken(SwapToken value) => token = value;

  @action
  setAmount(double value) => amount = value;

  @action
  getMaxBalance() async {
    maxAmount = await service!.getBalanceFromContract(_getTokenUSDT(network!));
    print('network: $network');
    print('address usdt: ${_getTokenUSDT(network!)}');
    print('maxAmount: $maxAmount');
  }

  @action
  createSwap(String address) async {
    try {
      this.onLoading();
      Web3Client _client = service!.client!;
      final _address = AccountRepository().userWallet!.privateKey!;
      final _cred = await service!.getCredentials(_address);
      final _nonce =
          await _client.getTransactionCount(EthereumAddress.fromHex(_address));
      final _contract = await _getContract();
      final _hashTx = await _client.sendTransaction(
        _cred,
        Transaction.callContract(
          contract: _contract,
          function: _contract.function('swap'),
          parameters: [
            ///nonce uint256
            BigInt.from(_nonce),

            ///chainTo uint256
            BigInt.from(1.0),

            ///amount uint256
            BigInt.from(amount),

            ///recipient address
            EthereumAddress.fromHex(_address),

            ///symbol string
            'TUSDT'
          ],
        ),
      );
      int _attempts = 0;
      while (_attempts < 5) {
        final result = await _client.getTransactionReceipt(_hashTx);
        if (result != null) {
          this.onSuccess(true);
          return;
        }
        await Future.delayed(const Duration(seconds: 3));
        _attempts++;
      }
      this.onError('Waiting time has expired');
    } catch (e) {
      this.onError(e.toString());
    }
  }

  _connectRpc() async {
    if (service != null) {
      service!.client?.dispose();
      service!.client = null;
      service = null;
    }
    service = ClientService(
      Configs.configsNetwork[ConfigNameNetwork.devnet]!,
      customRpc: _getRpcNetwork(network!),
    );
    await getMaxBalance();
  }

  Future<DeployedContract> _getContract() async {
    final _abiJson =
        await rootBundle.loadString("assets/contracts/WQBridge.json");
    final _contractAbi = ContractAbi.fromJson(_abiJson, 'WQBridge');
    final _contractAddress = EthereumAddress.fromHex(
      _getAddressContract(network!),
    );
    return DeployedContract(_contractAbi, _contractAddress);
  }

  String _getAddressContract(SwapNetworks network) {
    switch (network) {
      case SwapNetworks.ethereum:
        return '0x9870a749Ae5CdbC4F96E3D0C067eB212779a8FA1';
      case SwapNetworks.binance:
        return '0x833d71EF0b51Aa9Fb69b1f986381132628ED10F3';
      case SwapNetworks.matic:
        return '0xE2e7518080a0097492087E652E8dEB1f6b96B62b';
    }
  }

  String _getRpcNetwork(SwapNetworks network) {
    switch (network) {
      case SwapNetworks.ethereum:
        return 'https://rinkeby.infura.io/v3';
      case SwapNetworks.binance:
        return 'https://data-seed-prebsc-1-s1.binance.org:8545/';
      case SwapNetworks.matic:
        return 'https://rpc-mumbai.matic.today';
    }
  }

  String _getTokenUSDT(SwapNetworks network) {
    switch (network) {
      case SwapNetworks.ethereum:
        return '0xD92E713d051C37EbB2561803a3b5FBAbc4962431';
      case SwapNetworks.binance:
        return '0xC9bda0FA861Bd3F66c7d0Fd75A9A8344e6Caa94A';
      case SwapNetworks.matic:
        return '0x631E327EA88C37D4238B5c559A715332266e7Ec1';
    }
  }
}
