import 'dart:io';
import 'dart:math';
import 'package:app/base_store/i_store.dart';
import 'package:app/constants.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';

part 'transfer_store.g.dart';

@singleton
class TransferStore = TransferStoreBase with _$TransferStore;

abstract class TransferStoreBase extends IStore<bool> with Store {
  double? maxAmount;

  @observable
  TokenSymbols? typeCoin;

  @observable
  String addressTo = '';

  @observable
  String amount = '';

  @observable
  String fee = '';

  @computed
  bool get statusButtonTransfer => typeCoin != null && addressTo.isNotEmpty && amount.isNotEmpty;

  @action
  setAddressTo(String value) => addressTo = value;

  @action
  setAmount(String value) => amount = value;

  @action
  setTitleSelectedCoin(TokenSymbols? value) async {
    maxAmount = null;
    typeCoin = value;
    final _client = AccountRepository().getClient(other: true);
    final _dataCoins = AccountRepository().getConfigNetwork().dataCoins;
    final _isHaveAddressCoin = _dataCoins.firstWhere((element) => element.symbolToken == typeCoin).addressToken == null;
    if (_isHaveAddressCoin) {
      final _balance = await _client.getBalance(AccountRepository().privateKey);
      final _balanceInWei = _balance.getInWei;
      final _gasInWei = await _client.getGas();
      maxAmount = ((_balanceInWei - _gasInWei.getInWei).toDouble() * pow(10, -18)).toDouble();
    } else {
      final _balance = await _getBalanceToken(Web3Utils.getAddressToken(typeCoin!));
      maxAmount = _balance.toDouble();
    }
  }

  @action
  getMaxAmount() async {
    this.onLoading();
    final _client = AccountRepository().getClient(other: true);
    try {
      final _dataCoins = AccountRepository().getConfigNetwork().dataCoins;
      final _isHaveAddressCoin =
          _dataCoins.firstWhere((element) => element.symbolToken == typeCoin).addressToken == null;
      if (_isHaveAddressCoin) {
        final _balance = await _client.getBalance(AccountRepository().privateKey);
        final _balanceInWei = _balance.getInWei;
        await getFee();
        final _gas = BigInt.from(double.parse(fee) * pow(10, 18));
        amount = ((_balanceInWei - _gas).toDouble() * pow(10, -18)).toStringAsFixed(18);
      } else {
        final _balance = await _getBalanceToken(Web3Utils.getAddressToken(typeCoin!));
        amount = _balance.toStringAsFixed(18);
      }
      this.onSuccess(true);
    } on SocketException catch (_) {
      this.onError("Lost connection to server");
    } on FormatException catch (e) {
      this.onError(e.message);
    } catch (e, trace) {
      print("ERROR: $e");
      print("ERROR: $trace");
      onError(e.toString());
    }
  }

  @action
  getFee() async {
    try {
      final _client = AccountRepository().getClient(other: true);
      final _currentListTokens = AccountRepository().getConfigNetwork().dataCoins;
      final _from = EthereumAddress.fromHex(AccountRepository().userAddress);
      final _isToken = typeCoin != _currentListTokens.first.symbolToken;
      if (_isToken) {
        String _addressToken = Web3Utils.getAddressToken(typeCoin!);
        final _degree = Web3Utils.getDegreeToken(typeCoin!);
        final _contract = Erc20(
          address: EthereumAddress.fromHex(_addressToken),
          client: _client.client!,
        ).self;
        final _estimateGas = await _client.getEstimateGas(
          Transaction.callContract(
            contract: _contract,
            function: _contract.abi.functions[7],
            parameters: [
              EthereumAddress.fromHex(addressTo),
              BigInt.from(double.tryParse(amount) ?? 0.0 * pow(10, _degree)),
            ],
            from: _from,
          ),
        );
        final _gas = await _client.getGas();
        fee = ((_estimateGas * _gas.getInWei).toDouble() * pow(10, -18)).toStringAsFixed(17);
      } else {
        final _value = EtherAmount.fromUnitAndValue(
          EtherUnit.wei,
          BigInt.from(double.parse(amount) * pow(10, 18)),
        );
        final _to = EthereumAddress.fromHex(addressTo);
        final _estimateGas = await _client.getEstimateGas(
          Transaction(
            to: _to,
            from: _from,
            value: _value,
          ),
        );
        final _gas = await _client.getGas();
        fee = ((_estimateGas * _gas.getInWei).toDouble() * pow(10, -18)).toStringAsFixed(17);
      }
    } on SocketException catch (_) {
      onError("Lost connection to server");
    } catch (e, trace) {
      print('getFee: $e\n$trace');
      onError(e.toString());
    }
  }

  Future<double> _getBalanceToken(String addressToken) async {
    final _balance = await AccountRepository().getClient(other: true).getBalanceFromContract(
          addressToken,
          isUSDT: typeCoin == TokenSymbols.USDT,
        );
    return _balance;
  }
}
