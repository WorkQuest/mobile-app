import 'package:app/http/core/i_http_client.dart';
import 'package:injectable/injectable.dart';

@singleton
class ApiProvider {
  final IHttpClient _webService;

  ApiProvider(this._webService);
}

extension LoginService on ApiProvider {
  Future login({
    required String email,
    required String password,
  }) async {
    await _webService.post(
      query: '/v1/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );
  }

  Future register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    await _webService.post(
      query: '/v1/auth/register',
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password
      },
    );
  }
}
