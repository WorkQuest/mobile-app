
abstract class IHttpClient {

  String? accessToken;

  Future get({required query, Map<String, dynamic>? queryParameters});

  Future post({required query, Map<String, dynamic>? data});

  Future put({required query, Map<String, dynamic>? data});
}
