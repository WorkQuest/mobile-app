import 'dart:io';
import 'package:app/base_store/i_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/transfer_page/transfer_page.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:app/web3/service/address_service.dart';
import 'package:decimal/decimal.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web3dart/web3dart.dart';

part 'transfer_store.g.dart';

@singleton
class TransferStore = TransferStoreBase with _$TransferStore;

abstract class TransferStoreBase extends IStore<bool> with Store {
  @observable
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
  bool get statusButtonTransfer => currentCoin != null && addressTo.isNotEmpty && amount.isNotEmpty;

  @action
  setAddressTo(String value) => addressTo = value;

  @action
  setAmount(String value) => amount = value;

  @action
  setCoin(CoinItem? value) async {
    maxAmount = null;
    currentCoin = value;
    if (value != null) {
      final _isNative = Web3Utils.isNativeToken(currentCoin!.typeCoin);
      final _client = AccountRepository().getClient();
      final _address = Web3Utils.getAddressToken(currentCoin!.typeCoin);
      final amount = _isNative
          ? await _client.getBalance(AccountRepository().privateKey)
          : await _client.getBalanceFromContract(_address);
      maxAmount = amount is Decimal
          ? amount.toDouble()
          : (Decimal.fromBigInt((amount as EtherAmount).getInWei) / Decimal.fromInt(10).pow(18)).toDouble();
    }
  }

  @action
  getMaxAmount() async {
    this.onLoading();
    try {
      final _client = AccountRepository().getClient();
      final _dataCoins = AccountRepository().getConfigNetwork().dataCoins;
      final _isNotToken =
          _dataCoins.firstWhere((element) => element.symbolToken == currentCoin!.typeCoin).addressToken == null;
      if (_isNotToken) {
        final _balance = await _client.getBalance(AccountRepository().privateKey);
        final _balanceInWei = _balance.getInWei;
        await getFee();
        final _gas = Decimal.parse(fee) * Decimal.fromInt(10).pow(18);
        final _amount = ((Decimal.parse(_balanceInWei.toString()) - _gas) / Decimal.fromInt(10).pow(18)).toDecimal();
        if (_amount < Decimal.zero) {
          amount = 0.0.toStringAsFixed(18);
        } else {
          amount = _amount.toStringAsFixed(18);
        }
      } else {
        final _balance = await AccountRepository()
            .getClient()
            .getBalanceFromContract(Web3Utils.getAddressToken(currentCoin!.typeCoin));
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
      final _from = EthereumAddress.fromHex(AccountRepository().userAddress);
      String _amount = amount.isEmpty ? '0.0' : amount;
      String _address = AddressService.convertToHexAddress(addressTo);
      final _gas = await _client.getGas();

      final _currentListTokens = AccountRepository().getConfigNetwork().dataCoins;
      final _isToken = currentCoin!.typeCoin != _currentListTokens.first.symbolToken;

      if (_isToken) {
        String _addressToken = Web3Utils.getAddressToken(currentCoin!.typeCoin);
        final _contract = Erc20(
          address: EthereumAddress.fromHex(_addressToken),
          client: _client.client!,
        );
        final _degree = await Web3Utils.getDegreeToken(_contract);
        final _estimateGas = await _client.getEstimateGas(
          Transaction.callContract(
            contract: _contract.self,
            function: _contract.self.abi.functions[7],
            parameters: [
              EthereumAddress.fromHex(_address),
              Web3Utils.getAmountBigInt(amount: _amount, degree: _degree),
            ],
            from: _from,
          ),
        );
        fee = Web3Utils.getGas(estimateGas: _estimateGas, gas: _gas.getInWei, degree: 18).toStringAsFixed(18);
      } else {
        final _value = EtherAmount.fromUnitAndValue(
          EtherUnit.wei,
          Web3Utils.getAmountBigInt(amount: _amount, degree: 18),
        );
        final _to = EthereumAddress.fromHex(_address);
        final _estimateGas = await _client.getEstimateGas(
          Transaction(
            to: _to,
            from: _from,
            value: _value,
          ),
        );
        fee = Web3Utils.getGas(estimateGas: _estimateGas, gas: _gas.getInWei, degree: 18).toStringAsFixed(18);
      }
    } on SocketException catch (_) {
      onError("Lost connection to server");
    } catch (e) {
      // print('e: $e');
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
}
