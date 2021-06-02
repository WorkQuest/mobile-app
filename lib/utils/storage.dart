import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static FlutterSecureStorage get _secureStorage => FlutterSecureStorage();

  static Future<void> writeToSecureStorage({
    required String value,
    required String key,
  }) async {
    await _secureStorage.write(key: key.toString(), value: value);
  }

  static Future<void> writeRefreshToken(String token) async {
    _secureStorage.write(key: "refreshToken", value: token);
  }

  static Future<String?> readRefreshToken() async {
    return _secureStorage.read(key: "refreshToken");
  }

  static deleteAllFromSecureStorage() async {
    await _secureStorage.deleteAll();
  }
}
