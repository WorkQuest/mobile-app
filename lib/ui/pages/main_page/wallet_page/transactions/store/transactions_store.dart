import 'package:app/http/api_provider.dart';
import 'package:app/http/web3_extension.dart';
import 'package:app/model/web3/transactions_response.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:app/web3/contractEnums.dart';
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
  TYPE_COINS type = TYPE_COINS.WQT;

  @action
  setType(TYPE_COINS value) => type = value;

  @action
  getTransactions({bool isForce = false}) async {
    canMoreLoading = true;
    if (isForce) {
      onLoading();
    }

    try {
      if (isForce) {
        if (transactions.isNotEmpty) {
          transactions.clear();
        }
        isMoreLoading = false;
      }
      List<Tx>? result;
      final _addressToken = Web3Utils.getAddressToken(type);
      if (type == TYPE_COINS.WQT) {
        result = await _apiProvider.getTransactions(
          AccountRepository().userAddress,
          limit: 10,
          offset: isForce ? transactions.length : 0,
        );
      } else {
        result = await _apiProvider.getTransactionsByToken(
          address: AccountRepository().userAddress,
          addressToken: _addressToken,
          limit: 10,
          offset: isForce ? transactions.length : 0,
        );
      }

      _setTypeCoinInTxs(result!);

      if (isForce) {
        transactions.addAll(result);
      } else {
        result = result.reversed.toList();
        result.map((tran) {
          if (!transactions.contains(tran)) {
            transactions.insert(0, tran);
          }
        }).toList();
      }
      onSuccess(true);
    } on FormatException catch (e, trace) {
      print('$e\n$trace');
      onError(e.message);
    } catch (e) {
      print('$e');
      onError(e.toString());
    }
  }

  @action
  getTransactionsMore() async {
    isMoreLoading = true;
    try {
      List<Tx>? result;
      final _addressToken = Web3Utils.getAddressToken(type);
      if (type == TYPE_COINS.WQT) {
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
      result.map((tran) {
        final index = transactions.indexWhere((element) => element.hash == tran.hash);
        if (index == -1) {
          transactions.add(tran);
        }
      }).toList();
      await Future.delayed(const Duration(milliseconds: 500));
      isMoreLoading = false;
      onSuccess(true);
    } catch (e, trace) {
      print('$e\n$trace');
      onError(e.toString());
    }
  }

  _setTypeCoinInTxs(List<Tx> txs) {
    txs.map((tran) {
      if (tran.fromAddressHash!.hex == Web3Utils.getAddressToken(TYPE_COINS.WUSD))
        tran.coin = TYPE_COINS.WUSD;
      else if (tran.fromAddressHash!.hex == Web3Utils.getAddressToken(TYPE_COINS.wETH))
        tran.coin = TYPE_COINS.wETH;
      else if (tran.fromAddressHash!.hex == Web3Utils.getAddressToken(TYPE_COINS.wBNB))
        tran.coin = TYPE_COINS.wBNB;
      else if (tran.fromAddressHash!.hex == Web3Utils.getAddressToken(TYPE_COINS.USDT))
        tran.coin = TYPE_COINS.USDT;
      else
        tran.coin = TYPE_COINS.WQT;
    }).toList();
  }
}