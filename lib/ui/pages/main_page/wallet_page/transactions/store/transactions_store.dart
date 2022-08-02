import 'package:app/constants.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/http/web3_extension.dart';
import 'package:app/model/web3/transactions_response.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/base_store/i_store.dart';

part 'transactions_store.g.dart';

@singleton
class TransactionsStore extends TransactionsStoreBase with _$TransactionsStore {
  TransactionsStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class TransactionsStoreBase extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  TransactionsStoreBase(this._apiProvider);

  @observable
  ObservableList<Tx> transactions = ObservableList<Tx>.of([]);

  @observable
  bool isMoreLoading = false;

  @observable
  bool canMoreLoading = true;

  @observable
  TokenSymbols type = TokenSymbols.WQT;

  @action
  setType(TokenSymbols value) => type = value;

  NetworkName get _typeNetwork => AccountRepository().networkName.value!;

  bool get _isOtherNetwork {
    if (_typeNetwork != NetworkName.workNetTestnet &&
        _typeNetwork != NetworkName.workNetMainnet) {
      return true;
    }
    return false;
  }

  @action
  getTransactions() async {
    if (_isOtherNetwork) {
      onSuccess(true);
      return;
    }
    canMoreLoading = true;
    onLoading();

    try {
      if (transactions.isNotEmpty) {
        transactions.clear();
      }
      isMoreLoading = false;

      List<Tx>? result;
      final _addressToken = Web3Utils.getAddressToken(type);

      if (type == TokenSymbols.WQT) {
        result = await _apiProvider.getTransactions(
          AccountRepository().userAddress,
          limit: 10,
          offset: transactions.length,
        );
      } else {
        result = await _apiProvider.getTransactionsByToken(
          address: AccountRepository().userAddress,
          addressToken: _addressToken,
          limit: 10,
          offset: transactions.length,
        );
      }

      _setTypeCoinInTxs(result!);

      transactions.addAll(result);

      onSuccess(true);
    } on FormatException catch (e, trace) {
      print('$e\n$trace');
      onError(e.message);
    } catch (e, trace) {
      print('getTransactions | $e\n$trace');
      onError(e.toString());
    }
  }

  @action
  getTransactionsMore() async {
    if (_isOtherNetwork) {
      onSuccess(true);
      return;
    }
    isMoreLoading = true;
    try {
      List<Tx>? result;
      final _addressToken = Web3Utils.getAddressToken(type);
      if (type == TokenSymbols.WQT) {
        result = await _apiProvider.getTransactions(
          AccountRepository().userAddress,
          limit: 10,
          offset: transactions.length,
        );
      } else {
        result = await _apiProvider.getTransactionsByToken(
          address: AccountRepository().userAddress,
          addressToken: _addressToken,
          limit: 10,
          offset: transactions.length,
        );
      }
      if (result!.isEmpty) {
        canMoreLoading = false;
      }
      _setTypeCoinInTxs(result);
      transactions.addAll(result);
      isMoreLoading = false;
      onSuccess(true);
    } catch (e, trace) {
      print('$e\n$trace');
      onError(e.toString());
    }
  }

  @action
  addTransaction(Tx transaction) {
    try {
      if (isLoading) {
        return;
      }
      final _address = Web3Utils.getAddressToken(type);

      final _currentTokenIsNative = _address.isEmpty;
      final _isCurrentToken = _address == transaction.fromAddressHash!.hex ||
          _address == transaction.toAddressHash!.hex ||
          _currentTokenIsNative;
      if (!_isCurrentToken) {
        return;
      }
      final increase = transaction.fromAddressHash!.hex! !=
          (AccountRepository().userWallet?.address ?? '1234');
      transaction.coin = increase
          ? _getTitleCoin(
              transaction.fromAddressHash!.hex!,
              transaction.token_contract_address_hash?.hex,
              fromSocket: true,
            )
          : _getTitleCoin(
              transaction.toAddressHash!.hex!,
              transaction.token_contract_address_hash?.hex,
              fromSocket: true,
            );
      final _index =
          transactions.indexWhere((element) => element.hash == transaction.hash);
      if (_index == -1) {
        transactions.insert(0, transaction);
      }
    } catch (e) {
      // print('addTransaction | $e\n$trace');
      onError(e.toString());
    }
  }

  _setTypeCoinInTxs(List<Tx> txs) {
    txs.map((tran) {
      final increase = tran.fromAddressHash!.hex! !=
          (AccountRepository().userWallet?.address ?? '1234');
      tran.coin = increase
          ? _getTitleCoin(
              tran.fromAddressHash!.hex!, tran.token_contract_address_hash?.hex)
          : _getTitleCoin(
              tran.toAddressHash!.hex!, tran.token_contract_address_hash?.hex);
    }).toList();
  }

  TokenSymbols _getTitleCoin(
    String addressContract,
    String? contractAddress, {
    bool fromSocket = false,
  }) {
    if (type == TokenSymbols.WQT || fromSocket) {
      final _dataTokens = AccountRepository().getConfigNetworkWorknet().dataCoins;
      final _address = contractAddress ?? addressContract;
      if (_address ==
          _dataTokens
              .firstWhere((element) => element.symbolToken == TokenSymbols.WUSD)
              .addressToken) {
        return TokenSymbols.WUSD;
      } else if (_address ==
          _dataTokens
              .firstWhere((element) => element.symbolToken == TokenSymbols.wBNB)
              .addressToken) {
        return TokenSymbols.wBNB;
      } else if (_address ==
          _dataTokens
              .firstWhere((element) => element.symbolToken == TokenSymbols.wETH)
              .addressToken) {
        return TokenSymbols.wETH;
      } else if (_address ==
          _dataTokens
              .firstWhere((element) => element.symbolToken == TokenSymbols.USDT)
              .addressToken) {
        return TokenSymbols.USDT;
      } else {
        return TokenSymbols.WQT;
      }
    } else {
      if (contractAddress != null) {
        final _dataTokens = AccountRepository().getConfigNetwork().dataCoins;
        if (contractAddress ==
            _dataTokens
                .firstWhere((element) => element.symbolToken == TokenSymbols.WUSD)
                .addressToken) {
          return TokenSymbols.WUSD;
        } else if (contractAddress ==
            _dataTokens
                .firstWhere((element) => element.symbolToken == TokenSymbols.wBNB)
                .addressToken) {
          return TokenSymbols.wBNB;
        } else if (contractAddress ==
            _dataTokens
                .firstWhere((element) => element.symbolToken == TokenSymbols.wETH)
                .addressToken) {
          return TokenSymbols.wETH;
        } else if (contractAddress ==
            _dataTokens
                .firstWhere((element) => element.symbolToken == TokenSymbols.USDT)
                .addressToken) {
          return TokenSymbols.USDT;
        } else {
          return TokenSymbols.WQT;
        }
      }
      return type;
    }
  }

  @action
  clearData() {
    transactions.clear();
    isMoreLoading = false;
    canMoreLoading = true;
    type = TokenSymbols.WQT;
  }
}
