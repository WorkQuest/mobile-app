import 'dart:io';
import 'dart:math';
import 'package:app/base_store/i_store.dart';
import 'package:app/constants.dart';
import 'package:app/ui/pages/main_page/wallet_page/transfer_page/transfer_page.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:app/web3/service/address_service.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web3dart/web3dart.dart';

part 'transfer_store.g.dart';

@singleton
class TransferStore = TransferStoreBase with _$TransferStore;

abstract class TransferStoreBase extends IStore<bool> with Store {
  double? maxAmount;

  @observable
  CoinItem? currentCoin;

  @observable
  String addressTo = '';

  @observable
  String amount = '';

  @observable
  String fee = '';

  @computed
  bool get statusButtonTransfer =>
      currentCoin != null && addressTo.isNotEmpty && amount.isNotEmpty;

  @action
  setAddressTo(String value) => addressTo = value;

  @action
  setAmount(String value) => amount = value;

  @action
  setCoin(CoinItem? value) => currentCoin = value;

  @action
  getMaxAmount() async {
    this.onLoading();
    try {
      final _client = AccountRepository().getClient();
      final _dataCoins = AccountRepository().getConfigNetwork().dataCoins;
      final _isHaveAddressCoin = _dataCoins
          .firstWhere(
              (element) => element.symbolToken == currentCoin!.typeCoin)
          .addressToken ==
          null;
      if (_isHaveAddressCoin) {
        final _balance =
        await _client.getBalance(AccountRepository().privateKey);
        final _balanceInWei = _balance.getInWei;
        await getFee();
        final _gas = BigInt.from(double.parse(fee) * pow(10, 18));
        final _amount = (_balanceInWei - _gas).toDouble() * pow(10, -18);
        if (_amount < 0.0) {
          amount = 0.0.toStringAsFixed(18);
        } else {
          amount = ((_balanceInWei - _gas).toDouble() * pow(10, -18))
              .toStringAsFixed(18);
        }
      } else {
        final _balance = await _getBalanceToken(
            Web3Utils.getAddressToken(currentCoin!.typeCoin));
        amount = _balance.toStringAsFixed(18);
      }
      onSuccess(true);
    } on SocketException catch (_) {
      onError("Lost connection to server");
    } on FormatException catch (e) {
      onError(e.message);
    } catch (e) {
      onError(e.toString());
    }
  }

  @action
  getFee() async {
    try {
      final _client = AccountRepository().getClient();
      final _currentListTokens =
          AccountRepository().getConfigNetwork().dataCoins;
      final _from = EthereumAddress.fromHex(AccountRepository().userAddress);
      final _isToken =
          currentCoin!.typeCoin != _currentListTokens.first.symbolToken;
      String _address = '';
      String _amount = amount.isEmpty ? '0.0' : amount;
      try {
        final _isBech = addressTo.substring(0, 2).toLowerCase() == 'wq';
        _address =
        _isBech ? AddressService.bech32ToHex(addressTo) : addressTo;
      } catch (e) {
        _address = AccountRepository().userAddress;
      }
      if (_isToken) {
        String _addressToken = Web3Utils.getAddressToken(currentCoin!.typeCoin);
        final _degree = Web3Utils.getDegreeToken(currentCoin!.typeCoin);
        final _contract = Erc20(
          address: EthereumAddress.fromHex(_addressToken),
          client: _client.client!,
        ).self;
        final _estimateGas = await _client.getEstimateGas(
          Transaction.callContract(
            contract: _contract,
            function: _contract.abi.functions[7],
            parameters: [
              EthereumAddress.fromHex(_address),
              BigInt.from(double.tryParse(_amount) ?? 0.0 * pow(10, _degree)),
            ],
            from: _from,
          ),
        );
        final _gas = await _client.getGas();
        fee = ((_estimateGas * _gas.getInWei).toDouble() * pow(10, -18))
            .toStringAsFixed(17);
      } else {
        final _value = EtherAmount.fromUnitAndValue(
          EtherUnit.wei,
          BigInt.from(double.parse(_amount) * pow(10, 18)),
        );
        final _to = EthereumAddress.fromHex(_address);
        final _estimateGas = await _client.getEstimateGas(
          Transaction(
            to: _to,
            from: _from,
            value: _value,
          ),
        );
        final _gas = await _client.getGas();
        fee = ((_estimateGas * _gas.getInWei).toDouble() * pow(10, -18))
            .toStringAsFixed(17);
      }
    } on SocketException catch (_) {
      onError("Lost connection to server");
    } catch (e, trace) {
      onError(e.toString());
    }
  }

  @action
  clearData() {
    addressTo = '';
    amount = '';
    fee = '';
    currentCoin = null;
  }

  Future<double> _getBalanceToken(String addressToken) async {
    final _balance =
    await AccountRepository().getClient().getBalanceFromContract(
      addressToken,
      isUSDT: currentCoin!.typeCoin == TokenSymbols.USDT,
    );
    return _balance;
  }
}
