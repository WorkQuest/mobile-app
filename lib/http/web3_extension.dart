import 'package:app/model/web3/transactions_response.dart';

import 'api_provider.dart';

extension Web3Requests on ApiProvider {
  // Future walletLogin(String signature, String address) async {
  //   final response = await httpClient.post(
  //     query: "",
  //     data: {
  //       "signature": signature,
  //       "address": address,
  //     },
  //   );
  //
  //   if (response.statusCode != 200) {
  //     throw FormatException(response.data['msg']);
  //   }
  //   print("Response$response");
  //   //HttpClient().setAccessToken = response.data['result']['access'];
  //
  //   return response;
  // }

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
    );
    print("responsed $response");
    return TransactionResponse.fromJson(response).txs!;
  }
}
