import 'package:app/http/api_provider.dart';
import 'package:app/http/web3_extension.dart';
import 'package:app/model/web3/transactions_response.dart';
import 'package:app/web3/contractEnums.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/base_store/i_store.dart';

part 'wallet_store.g.dart';

@singleton
class WalletStore extends _WalletStore with _$WalletStore{
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
  getCoins() async {
    onLoading();
    try {
      print('getCoins');
      if (coins.isNotEmpty) {
        coins.clear();
      }
      final list = await AccountRepository()
          .client!
          .getAllBalance(AccountRepository().privateKey);
      final ether = list. firstWhere((element) => element.title == 'ether');
      coins.add(BalanceItem(
        "WUSD",
        ether.amount,
      ));
      final wqt = await AccountRepository().client!.getBalanceFromContract('0x917dc1a9E858deB0A5bDCb44C7601F655F728DfE');
      coins.add(BalanceItem(
        "WQT",
        wqt.toString(),
      ));
      onSuccess(true);
    } catch (e) {
      onError(e.toString());
    }
  }

  @action
  getTransactions({bool isForce = false}) async {
    if (isForce) {
      onLoading();
    } else {
      isMoreLoading = true;
    }
    try {
      if (isForce) {
        if (transactions.isNotEmpty) {
          transactions.clear();
        }
        isMoreLoading = false;
      }
      final result = await _apiProvider.getTransactions(
        AccountRepository().userAddress!,
        limit: 10,
        offset: transactions.length,
      );
      // await Future.delayed(const Duration(seconds: 2));
      // final result = List.generate(5, (index) {
      //   return Tx(value: '${index % 2}100000000000000', createdAt: DateTime.now());
      // });

      result.map((tran) {
        if (tran.contractAddress != null) {
          tran.coin = TYPE_COINS.wqt;
          final res = BigInt.parse(tran.logs!.first.data.toString().substring(2), radix: 16);
          tran.value = res.toString();
        } else {
          tran.coin = TYPE_COINS.wusd;
        }
      }).toList();

      transactions.addAll(result);
      await Future.delayed(const Duration( milliseconds: 500));
      isMoreLoading = false;
      onSuccess(true);
    } catch (e, trace) {
      print('$e\n$trace');
      onError(e.toString());
    }
  }
}
