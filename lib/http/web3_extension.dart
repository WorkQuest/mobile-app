import 'dart:math';

import 'package:app/constants.dart';
import 'package:app/model/web3/course_token_response.dart';
import 'package:app/model/web3/current_course_tokens_response.dart';
import 'package:app/model/web3/transactions_response.dart';
import 'package:app/web3/repository/account_repository.dart';

import 'api_provider.dart';

extension Web3Requests on ApiProvider {
  Network get _network => AccountRepository().notifierNetwork.value;

  String _transactionsByToken({
    required String address,
    required String addressToken,
  }) {
    if (_network == Network.testnet) {
      return "https://dev-explorer-api.workquest.co/api/v1/token/$addressToken/account/$address/transfers";
    } else {
      return "https://mainnet-explorer-api.workquest.co/api/v1/token/$addressToken/account/$address/transfers";
    }
  }

  String _transactions(String address) {
    if (_network == Network.testnet) {
      return "https://dev-explorer-api.workquest.co/api/v1/account/$address/transactions";
    } else {
      return "https://mainnet-explorer-api.workquest.co/api/v1/account/$address/transactions";
    }
  }

  String get _courseTokens {
    if (_network == Network.testnet) {
      return "https://dev-oracle.workquest.co/api/v1/oracle/current-prices";
    }
    return "https://mainnet-oracle.workquest.co/api/v1/oracle/current-prices";
  }

  Future<void> registerWallet(String publicKey, String address) async {
    await httpClient.post(
      query: "/v1/auth/register/wallet",
      data: {
        "publicKey": publicKey,
        "address": address,
      },
    );
  }

  Future<double> getCourseWQT() async {
    final response = await httpClient.get(
      query: "https://dev-oracle.workquest.co/api/v1/oracle/sign-price/tokens",
      useBaseUrl: false,
    );

    final result = CourseTokenResponse.fromJson(response);
    final _indexWQT = result.symbols!.indexWhere((element) => element == 'WQT');
    final _course = result.prices![_indexWQT];
    return double.parse(_course) * pow(10, -18);
  }

  Future<List<CurrentCourseTokensResponse>> getCourseTokens() async {
    final response = await httpClient.get(
      query: _courseTokens,
      useBaseUrl: false,
    );
    return List<CurrentCourseTokensResponse>.from(
      response.map(
            (x) => CurrentCourseTokensResponse.fromJson(x),
      ),
    );
  }

  Future<List<Tx>?> getTransactions(String address,
      {int limit = 10, int offset = 0}) async {
    final response = await httpClient.get(
      query: '${_transactions(address)}?limit=$limit&offset=$offset',
      useBaseUrl: false,
    );

    return TransactionsResponse.fromJson(response).transactions;
  }

  Future<List<Tx>?> getTransactionsByToken({
    required String address,
    required String addressToken,
    int limit = 10,
    int offset = 0,
  }) async {
    final response = await httpClient.get(
        query: '${_transactionsByToken(
          address: address,
          addressToken: addressToken,
        )}?limit=$limit&offset=$offset',
        useBaseUrl: false);
    return TransactionsResponse.fromJsonToken(response).transactions!;
  }

  Future walletLogin(String signature, String address) async {
    final response = await httpClient.post(
      query: "/v1/auth/login/wallet",
      data: {
        "signature": signature,
        "address": address,
      },
    );
    print("Wallet Login$response");
  }
}
