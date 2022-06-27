import 'dart:math';

import 'package:app/model/web3/transactions_response.dart';

import '../model/web3/course_token_response.dart';
import 'api_provider.dart';

extension Web3Requests on ApiProvider {
  String _transactionsByToken({
    required String address,
    required String addressToken,
  }) {
    return "https://testnet-explorer-api.workquest.co/api/v1/token/$addressToken/account/$address/transfers";
  }

  String _transactions(String address) {
    return "https://testnet-explorer-api.workquest.co/api/v1/account/$address/transactions";
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
