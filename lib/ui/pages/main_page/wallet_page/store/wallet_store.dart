import 'package:app/http/api_provider.dart';
import 'package:app/model/web3/current_course_tokens_response.dart';
import 'package:app/ui/pages/main_page/wallet_page/transactions/store/transactions_store.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:decimal/decimal.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/base_store/i_store.dart';
import 'package:app/http/web3_extension.dart';

import '../../../../../constants.dart';

part 'wallet_store.g.dart';

@singleton
class WalletStore extends _WalletStore with _$WalletStore {
  WalletStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _WalletStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _WalletStore(this._apiProvider);

  @observable
  TokenSymbols currentToken = TokenSymbols.WQT;

  @observable
  ObservableList<_CoinEntity> coins = ObservableList.of([]);

  @action
  setCurrentToken(TokenSymbols value) => currentToken = value;

  @action
  getCoins({bool isForce = true, bool tryAgain = true, bool fromSwap = false}) async {
    if (isForce) {
      onLoading();
      coins.clear();
    }
    try {
      final _tokens =
          Configs.configsNetwork[AccountRepository().networkName.value]!.dataCoins;
      await Future.delayed(const Duration(milliseconds: 250));
      final _listCoinsEntity = await _getCoinEntities(_tokens);
      _setCoins(_listCoinsEntity);

      if (isForce) {
        currentToken = coins.first.symbol;
        GetIt.I.get<TransactionsStore>().setType(currentToken);
        GetIt.I.get<TransactionsStore>().transactions =
            ObservableList.of(GetIt.I.get<TransactionsStore>().transactions);
        if (!fromSwap) {
          GetIt.I.get<TransactionsStore>().getTransactions();
        }
      }
      onSuccess(true);
    } catch (e, trace) {
      print('getCoins | $e\n$trace');
      await Future.delayed(const Duration(seconds: 1));
      if (tryAgain) {
        await getCoins(isForce: true, tryAgain: false, fromSwap: fromSwap);
      } else {
        onError(e.toString());
      }
    }
  }

  _setCoins(List<_CoinEntity> listCoins) {
    if (coins.isNotEmpty) {
      coins.map((element) {
        element.amount = listCoins.firstWhere((el) => el.symbol == element.symbol).amount;
      }).toList();
    } else {
      coins.addAll(listCoins);
    }
  }

  Future<List<_CoinEntity>> _getCoinEntities(List<DataCoins> coins) async {
    List<_TokenCourse> _courses = List.empty();
    if (!AccountRepository().isOtherNetwork) {
      final _result = await _apiProvider.getCourseTokens();
      _courses = _getListTokenCourse(_result);
    }

    List<_CoinEntity> _result = [];
    final _client = AccountRepository().getClient();
    await Stream.fromIterable(coins).asyncMap((coin) async {
      if (coin.addressToken == null) {
        final _balance = await _client.getBalance(AccountRepository().privateKey);
        final _amount =
            (Decimal.fromBigInt(_balance.getInWei) / Decimal.fromInt(10).pow(18))
                .toDouble()
                .toStringAsFixed(8);
        final _index =
            _courses.indexWhere((element) => element.token == coin.symbolToken);
        final _pricePerDollar = _index == -1 ? null : _courses[_index].pricePerDollar;
        _result.add(_CoinEntity(coin.symbolToken, _amount, _pricePerDollar));
      } else {
        final _amount = await _client.getBalanceFromContract(coin.addressToken!);
        final _index =
            _courses.indexWhere((element) => element.token == coin.symbolToken);
        final _pricePerDollar = _index == -1 ? null : _courses[_index].pricePerDollar;
        _result.add(_CoinEntity(coin.symbolToken, _amount.toString(), _pricePerDollar));
      }
    }).toList();

    return _result;
  }

  List<_TokenCourse> _getListTokenCourse(List<CurrentCourseTokensResponse> courses) {
    List<_TokenCourse> result = [];

    final _list = courses;
    for (var i in _list) {
      final _token = Web3Utils.getTokenSymbol(i.symbol!);
      if (_token != null) {
        final _course = Decimal.parse(i.price!) / Decimal.fromInt(10).pow(18);
        result.add(_TokenCourse(_token, _course.toDouble().toString()));
      }
    }
    result.add(_TokenCourse(TokenSymbols.WUSD, '1.0'));
    return result;
  }

  @action
  clearData() {
    coins.clear();
    currentToken = TokenSymbols.WQT;
  }
}

class _CoinEntity {
  final TokenSymbols symbol;
  String? amount;
  String? pricePerDollar;

  _CoinEntity(this.symbol, [this.amount, this.pricePerDollar]);

  @override
  toString() {
    return 'symbol: $symbol\n'
        'amount: $amount\n'
        'pricePerDollar: $pricePerDollar\n';
  }
}

class _TokenCourse {
  final TokenSymbols token;
  final String pricePerDollar;

  _TokenCourse(this.token, this.pricePerDollar);
}
