import 'package:app/model/web3/transactions_response.dart';

import 'api_provider.dart';

extension Web3Requests on ApiProvider {
  String _transactionsByToken({
    required String address,
    required String addressToken,
  }) =>
      "https://dev-explorer.workquest.co/api/token/$addressToken/account/$address/transfers";

  Future<void> registerWallet(String publicKey, String address) async {
    await httpClient.post(
      query: "/v1/auth/register/wallet",
      data: {
        "publicKey": publicKey,
        "address": address,
      },
    );
  }

  Future<List<Tx>> getTransactions(String address,
      {int limit = 10, int offset = 0}) async {
    String _transactions(String address) =>
        "https://dev-explorer.workquest.co/api/v1/account/$address/txs";
    final response = await httpClient.get(
      query: '${_transactions(address)}?limit=$limit&offset=$offset',
      useBaseUrl: false,
    );
    print("responsed $response");
    return TransactionsResponse.fromJson(response).txs!;
  }

  Future<List<Tx>?> getTransactionsByToken({
    required String address,
    required String addressToken,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await httpClient.get(
          query: '${_transactionsByToken(
        address: address,
        addressToken: addressToken,
      )}?limit=$limit&offset=$offset');

      return TransactionsResponse.fromJson(response).txs!;
    } catch (e, tr) {
      print("$e $tr");
    }
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
