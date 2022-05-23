import 'package:app/http/api_provider.dart';
import 'package:app/http/web3_extension.dart';
import 'package:app/model/web3/transactions_response.dart';
import 'package:app/web3/contractEnums.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/base_store/i_store.dart';

import '../../../../../../constants.dart';

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
      switch (type) {
        case TYPE_COINS.WQT:
          result = await _apiProvider.getTransactions(
            AccountRepository().userAddress!,
            limit: 10,
            offset: isForce ? transactions.length : 0,
          );
          break;
        case TYPE_COINS.WUSD:
          result = await _apiProvider.getTransactionsByToken(
            address: AccountRepository().userAddress!,
            addressToken: AddressCoins.wUsd,
            limit: 10,
            offset: isForce ? transactions.length : 0,
          );
          break;
        case TYPE_COINS.wBNB:
          result = await _apiProvider.getTransactionsByToken(
            address: AccountRepository().userAddress!,
            addressToken: AddressCoins.wBnb,
            limit: 10,
            offset: isForce ? transactions.length : 0,
          );
          break;
        case TYPE_COINS.wETH:
          result = await _apiProvider.getTransactionsByToken(
            address: AccountRepository().userAddress!,
            addressToken: AddressCoins.wEth,
            limit: 10,
            offset: isForce ? transactions.length : 0,
          );
          break;
        case TYPE_COINS.USDT:
          result = await _apiProvider.getTransactionsByToken(
            address: AccountRepository().userAddress!,
            addressToken: AddressCoins.uSdt,
            limit: 10,
            offset: isForce ? transactions.length : 0,
          );
          break;
      }

      result!.map((tran) {
        if (tran.toAddressHash!.hex! == AccountRepository().userAddress) {
          switch (tran.fromAddressHash!.hex!) {
            case AddressCoins.wUsd:
              tran.coin = TYPE_COINS.WUSD;
              break;
            case AddressCoins.wEth:
              tran.coin = TYPE_COINS.wETH;
              break;
            case AddressCoins.wBnb:
              tran.coin = TYPE_COINS.wBNB;
              break;
            case AddressCoins.uSdt:
              tran.coin = TYPE_COINS.USDT;
              break;
            default:
              tran.coin = TYPE_COINS.WQT;
              break;
          }
        } else {
          switch (tran.toAddressHash!.hex!) {
            case AddressCoins.wUsd:
              tran.coin = TYPE_COINS.WUSD;
              break;
            case AddressCoins.wEth:
              tran.coin = TYPE_COINS.wETH;
              break;
            case AddressCoins.wBnb:
              tran.coin = TYPE_COINS.wBNB;
              break;
            case AddressCoins.uSdt:
              tran.coin = TYPE_COINS.USDT;
              break;
            default:
              tran.coin = TYPE_COINS.WQT;
              break;
          }
        }
      }).toList();
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
      switch (type) {
        case TYPE_COINS.WQT:
          result = await _apiProvider.getTransactions(
            AccountRepository().userAddress!,
            limit: 10,
            offset: transactions.length,
          );
          break;
        case TYPE_COINS.WUSD:
          result = await _apiProvider.getTransactionsByToken(
            address: AccountRepository().userAddress!,
            addressToken: AddressCoins.wUsd,
            limit: 10,
            offset: transactions.length,
          );
          break;
        case TYPE_COINS.wBNB:
          result = await _apiProvider.getTransactionsByToken(
            address: AccountRepository().userAddress!,
            addressToken: AddressCoins.wBnb,
            limit: 10,
            offset: transactions.length,
          );
          break;
        case TYPE_COINS.wETH:
          result = await _apiProvider.getTransactionsByToken(
            address: AccountRepository().userAddress!,
            addressToken: AddressCoins.wEth,
            limit: 10,
            offset: transactions.length,
          );
          break;
        case TYPE_COINS.USDT:
          result = await _apiProvider.getTransactionsByToken(
            address: AccountRepository().userAddress!,
            addressToken: AddressCoins.uSdt,
            limit: 10,
            offset: transactions.length,
          );
          break;
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
}