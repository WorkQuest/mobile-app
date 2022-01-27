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

  Future<bool> registerWallet(String publicKey, String address) async {
    final response = await httpClient.post(
      query: "/v1/auth/register/wallet",
      data: {
        "publicKey": publicKey,
        "address": address,
      },
    );

    if (response.statusCode != 200) {
      throw FormatException(response.data['msg']);
    }
    return response.data['ok'];
  }
}
