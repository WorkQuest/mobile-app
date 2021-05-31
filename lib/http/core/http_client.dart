import 'dart:io';

import 'package:app/exceptions.dart';
import 'package:app/http/core/i_http_client.dart';
import 'package:app/log_service.dart';
import 'package:app/model/bearer_token/bearer_token.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IHttpClient, env: [Environment.test])
class TestHttpClient extends _HttpClient {
  TestHttpClient()
      : super(
          Dio(BaseOptions(
            baseUrl: 'https://app-ver1.workquest.co/api',
            connectTimeout: 20000,
            receiveTimeout: 20000,
            headers: {
              "content-type": "application/json"
            }
          )),
        );
}

class _HttpClient implements IHttpClient {

  final Dio _dio;

  @override
  BearerToken? bearerToken;

  _HttpClient(this._dio) {
    _setInterceptors();
  }

  @override
  Future get({required query, Map<String, dynamic>? queryParameters}) async {
    return await _sendRequest(
      _dio.get(query, queryParameters: queryParameters),
    );
  }

  @override
  Future post({required query, Map<String, dynamic>? data}) async {
    return await _sendRequest(
      _dio.post(query, data: data),
    );
  }

  Future _sendRequest(Future<Response> request) async {
    final Response response = await request.catchError((error) {
      if (error is DioError) {
        throw RequestError(
          message: error.response.toString(),
        );
      }
    });

    return response.data["result"];
  }

  void _setInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {

          if (bearerToken != null) {

          }

          println("\n---------- DioRequest ----------"
              "\n\turl: ${options.baseUrl}${options.path}"
              "\n\tmethod: ${options.method}"
              "\n\tdata: ${options.data}"
              "\n\theaders: ${options.headers}\n}"
              "\n--------------------------------\n");

          return handler.next(options);
        },
        onResponse: (response, handler) {
          final options = response.requestOptions;
          println("\n---------- DioResponse ----------"
              "\n\turl: ${options.baseUrl}${options.path}"
              "\n\tmethod: ${options.method}"
              "\n\tresponse: $response"
              "\n--------------------------------\n");
          return handler.next(response);
        },
        onError: (error, handler) async {
          final options = error.requestOptions;
          println("\n---------- DioError ----------"
              "\n\turl: ${options.baseUrl}${options.path}"
              "\n\tmethod: ${options.method}"
              "\n\tmessage: ${error.message}"
              "\n\tresponse: ${error.response}"
              "\n--------------------------------\n");

          // if (error.response?.data["code"] == 401001) {
          //   if (refreshAttempt == 5) {
          //     refreshAttempt = 0;
          //     return handler.next(error);
          //   }
          //
          //   await _refreshToken(refreshAttempt++);
          //   return _dio.request(
          //     error.requestOptions.baseUrl + error.requestOptions.path,
          //     options: error.requestOptions,
          //   );
          // }

          return handler.next(error);
        },
      ),
    );
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }


  //int _refreshAttempt = 0;

  // Future<void> _refreshToken(int attempt) async {
  //   await _secureStorageService.deleteAccessToken();
  //
  //   var authResponseMap = await post(query: 'auth/refresh-token');
  //
  //   var authResponse = AuthResponse.fromMap(authResponseMap);
  //
  //   if (authResponse != null) {
  //     await _secureStorageService.saveAccessToken(authResponse.access);
  //     await _secureStorageService.saveRefreshToken(authResponse.refresh);
  //     refreshAttempt = 0;
  //   }
  // }
}
