import 'package:app/model/web3/transactions_response.dart';

import 'api_provider.dart';

extension Web3Requests on ApiProvider {
  String _transactionsByToken({
    required String address,
    required String addressToken,
  }) =>
      "https://dev-explorer.workquest.co/api/v1/token/$addressToken/account/$address/transfers";

  Future<void> registerWallet(String publicKey, String address) async {
    await httpClient.post(
      query: "/v1/auth/register/wallet",
      data: {
        "publicKey": publicKey,
        "address": address,
      },
    );
  }

  Future<List<Tx>?> getTransactions(String address,
      {int limit = 10, int offset = 0}) async {
    try {
      String _transactions(String address) =>
          "https://dev-explorer.workquest.co/api/v1/account/$address/transactions";
      bool status = true;
      List<Tx>? result = [];
      while (status) {
        final response = await httpClient.get(
          query: '${_transactions(address)}?limit=$limit&offset=$offset',
          useBaseUrl: false,
        );

        final res = TransactionsResponse.fromJson(response);
        res.transactions!.map((tran) {
          if (tran.tokenTransfers != null && tran.tokenTransfers!.isEmpty) {
            result.add(tran);
          }
        }).toList();
        if (result.length >= 10 || res.transactions!.isEmpty) {
          status = false;
        } else {
          offset += 10;
        }
        print('offset = $offset');
        print('len result = ${result.length}');
      }
      return result;
    } catch (e, trace) {
      print('e: $e\ntrace: $trace');
    }
  }

  Future<List<Tx>?> getTransactionsByToken({
    required String address,
    required String addressToken,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      print("Called Tansaction By roken");
      final response = await httpClient.get(
          query: '${_transactionsByToken(
            address: address,
            addressToken: addressToken,
          )}?limit=$limit&offset=$offset',
          useBaseUrl: false);
      return TransactionsResponse.fromJsonToken(response).transactions!;
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
