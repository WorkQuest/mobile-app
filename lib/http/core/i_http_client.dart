
abstract class IHttpClient {

  String? accessToken;

  Future get({required query, Map<String, dynamic>? queryParameters, bool useBaseUrl = true});

  Future post({required query, Map<String, dynamic>? data});

  Future put({required query, Map<String, dynamic>? data});

  Future delete({required query, Map<String, dynamic>? data});
}
