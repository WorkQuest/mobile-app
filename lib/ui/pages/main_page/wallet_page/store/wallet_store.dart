import 'package:app/http/api_provider.dart';
import 'package:app/http/web3_extension.dart';
import 'package:app/model/web3/transactions_response.dart';
import 'package:app/web3/contractEnums.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:app/web3/service/client_service.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/base_store/i_store.dart';

part 'wallet_store.g.dart';

@singleton
class WalletStore extends _WalletStore with _$WalletStore {
  WalletStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _WalletStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _WalletStore(this._apiProvider);

  @observable
  ObservableList<BalanceItem> coins = ObservableList.of([]);
  @observable
  ObservableList<Tx> transactions = ObservableList<Tx>.of([]);

  @observable
  bool isMoreLoading = false;

  @action
  getCoins({bool isForce = true}) async {
    if (isForce) {
      onLoading();
    }
    try {
      print('getCoins');

      final list =
          await ClientService().getAllBalance(AccountRepository().privateKey);
      if (coins.isNotEmpty) {
        coins.clear();
      }
      final ether = list.firstWhere((element) => element.title == 'ether');
      coins.add(BalanceItem(
        "WUSD",
        ether.amount,
      ));
      final wqt = await ClientService()
          .getBalanceFromContract('0x917dc1a9E858deB0A5bDCb44C7601F655F728DfE');
      coins.add(BalanceItem(
        "WQT",
        wqt.toString(),
      ));

      if (isForce) {
        onSuccess(true);
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  @action
  getTransactions({bool isForce = false}) async {
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
      var result = await _apiProvider.getTransactions(
        AccountRepository().userAddress!,
        limit: 10,
        offset: isForce ? transactions.length : 0,
      );

      result.map((tran) {
        if (tran.contractAddress != null) {
          tran.coin = TYPE_COINS.wqt;
          final res = BigInt.parse(
              tran.logs!.first.data.toString().substring(2),
              radix: 16);
          tran.value = res.toString();
        } else {
          tran.coin = TYPE_COINS.wusd;
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
    } catch (e, trace) {
      print('$e\n$trace');
      onError(e.toString());
    }
  }

  @action
  getTransactionsMore() async {
    isMoreLoading = true;
    try {
      final result = await _apiProvider.getTransactions(
        AccountRepository().userAddress!,
        limit: 10,
        offset: transactions.length,
      );
      result.map((tran) {
        if (tran.contractAddress != null) {
          tran.coin = TYPE_COINS.wqt;
          final res = BigInt.parse(
              tran.logs!.first.data.toString().substring(2),
              radix: 16);
          tran.value = res.toString();
        } else {
          tran.coin = TYPE_COINS.wusd;
        }
      }).toList();

      transactions.addAll(result);
      await Future.delayed(const Duration(milliseconds: 500));
      isMoreLoading = false;
      onSuccess(true);
    } catch (e, trace) {
      print('$e\n$trace');
      onError(e.toString());
    }
  }
}
