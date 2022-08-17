import 'dart:convert';
import 'dart:io';
import 'package:app/constants.dart';
import 'package:app/exceptions.dart';
import 'package:app/http/core/i_http_client.dart';
import 'package:app/log_service.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:app/utils/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable(as: IHttpClient, env: [Environment.test])
class TestHttpClient extends _HttpClient {
  TestHttpClient()
      : super(
          Dio(
            BaseOptions(
              //baseUrl: 'https://app.workquest.co/api',
              connectTimeout: 20000,
              receiveTimeout: 20000,
              headers: {"content-type": "application/json"},
            ),
          ),
        );

  @override
  String? accessToken;
}

class _HttpClient implements IHttpClient {
  final Dio _dio;

  Network get _network => AccountRepository().notifierNetwork.value;

  String get _baseUrl {
    if (_network == Network.testnet) {
      return Constants.isTestnet ? 'https://testnet-app.workquest.co/api' : 'https://dev-app.workquest.co/api';
    } else if (_network == Network.mainnet) {
      return 'https://app.workquest.co/api';
    }
    return 'https://app.workquest.co/api';
  }

  @override
  String? accessToken;
  @override
  String? platform;
  bool tokenExpired = false;

  _HttpClient(this._dio) {
    _setInterceptors();
  }

  @override
  Future get({
    required query,
    Map<String, dynamic>? queryParameters,
    bool useBaseUrl = true,
  }) async {
    return await _sendRequest(
      _dio.get(useBaseUrl ? _baseUrl + query : query, queryParameters: queryParameters),
    );
  }

  @override
  Future post({
    required query,
    Map<String, dynamic>? data,
    bool useBaseUrl = true,
  }) async {
    return await _sendRequest(
      _dio.post(
        useBaseUrl ? _baseUrl + query : query,
        data: data,
      ),
    );
  }

  @override
  Future put({
    required query,
    Map<String, dynamic>? data,
    bool useBaseUrl = true,
  }) async {
    return await _sendRequest(
      _dio.put(
        useBaseUrl ? _baseUrl + query : query,
        data: data,
      ),
    );
  }

  @override
  Future delete({
    required query,
    Map<String, dynamic>? data,
    bool useBaseUrl = true,
  }) async {
    return await _sendRequest(
      _dio.delete(
        useBaseUrl ? _baseUrl + query : query,
        data: data,
      ),
    );
  }

  Future _sendRequest(Future<Response> request) async {
    final Response response = await request.catchError((error) {
      if (error is DioError) {
        if (error.type == DioErrorType.connectTimeout) {
          throw Exception("errors.serverTimedOut".tr());
        }
        if (error.response == null) {
          throw CustomException('errors.checkInternetConnection'.tr());
        } else {
          final response = RequestErrorModel.fromJson(error.response!.data);
          throw CustomException(response.message);
        }
      }
    });
    return response.data["result"] ?? response.data;
  }

  void _setInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (accessToken != null) {
            options.headers["Authorization"] = "Bearer " + accessToken.toString();
          }
          if (tokenExpired == true) {
            String? token = await Storage.readRefreshToken();
            options.headers["Authorization"] = "Bearer " + token.toString();
          }
          if (options.uri.path.contains("auth/login") || options.uri.path.contains("refresh-tokens"))
            options.headers["user-agent"] = platform;

          println("\n---------- DioRequest ----------"
              "\n\turl: ${options.baseUrl}${options.path}"
              "\n\tmethod: ${options.method}"
              "\n\tquery: ${options.queryParameters}"
              "\n\tdata: ${options.data}"
              "\n\theaders: ${options.headers}\n}"
              "\n--------------------------------\n");

          return handler.next(options);
        },
        onResponse: (response, handler) {
          final options = response.requestOptions;
          print("\n---------- DioResponse ----------"
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

          if (error.response?.data["code"] == 401001) {
            await refreshToken();
          }
          print('data test: ${options.data}');

          SharedPreferences.getInstance().then((value) async {
            List<String> _old = value.getStringList(errorsSharedKeys) ?? [];
            print(_old);
            _old.insert(
                0,
                jsonEncode(ErrorRequestModel(
                  url: options.baseUrl + options.path,
                  method: options.method,
                  query: options.queryParameters.toString(),
                  data: options.data.toString(),
                  message: error.message,
                  response: error.response.toString(),
                  date: DateTime.now().toString(),
                ).toJson()));

            value.setStringList(
              errorsSharedKeys,
              _old,
            );
          });

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
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
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

  Future refreshToken() async {
    this.tokenExpired = true;
    final responseData = await post(
      query: '/v1/auth/refresh-tokens',
    );
    this.accessToken = responseData["access"];
    println("\n---------- DioInfo ----------"
        "\n\info: TOKEN REFRESHED"
        "\n--------------------------------\n");
    Storage.writeRefreshToken(responseData["refresh"]);
    Storage.writeAccessToken(responseData["access"]);
    this.tokenExpired = false;
  }
}

const errorsSharedKeys = "errorsShared";

class CustomException implements Exception {
  final dynamic message;

  CustomException([this.message]);

  @override
  String toString() {
    return message;
  }
}

class ErrorRequestModel {
  final String url;
  final String method;
  final String query;
  final String? data;
  final String message;
  final String? response;
  final String date;

  const ErrorRequestModel({
    required this.url,
    required this.method,
    required this.query,
    required this.data,
    required this.message,
    required this.response,
    required this.date,
  });

  factory ErrorRequestModel.fromJson(Map<String, dynamic> json) {
    return ErrorRequestModel(
      url: json["url"],
      method: json["method"],
      query: json["query"],
      data: json["data"],
      message: json["message"],
      date: json["date"],
      response: json["response"] == null ? null : json["response"],
    );
  }

  Map<String, dynamic> toJson() => {
        "url": url,
        "method": method,
        "query": query,
        "data": data,
        "message": message,
        "date": date,
        "response": response,
      };

  @override
  String toString() {
    return "Url: $url\n"
        "Method: $method\n"
        "Query: $query\n"
        "Data: $data\n"
        "Message: $message\n"
        "Response: $response\n"
        "Date: $date";
  }
}
