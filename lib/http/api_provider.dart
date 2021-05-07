import 'package:app/http/core/i_http_client.dart';
import 'package:app/model/bearer_token/bearer_token.dart';
import 'package:injectable/injectable.dart';

@singleton
class ApiProvider {
  final IHttpClient _httpClient;

  ApiProvider(this._httpClient);
}

extension LoginService on ApiProvider {
  Future<void> login({
    required String email,
    required String password,
  }) async {
    final responseData = await _httpClient.post(
      query: '/v1/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    _httpClient.bearerToken = BearerToken.fromJson(
      responseData["data"],
    );
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {

    final responseData = await _httpClient.post(
      query: '/v1/auth/register',
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password
      },
    );

    _httpClient.bearerToken = BearerToken.fromJson(
      responseData["data"],
    );
  }
}
