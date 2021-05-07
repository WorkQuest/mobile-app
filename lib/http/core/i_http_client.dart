import 'package:app/model/bearer_token/bearer_token.dart';

abstract class IHttpClient {

  BearerToken? bearerToken;

  Future get({required query, Map<String, dynamic>? queryParameters});

  Future post({required query, Map<String, dynamic>? data});

}
