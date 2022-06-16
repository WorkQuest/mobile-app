import 'dart:convert';

import 'package:app/web3/wallet.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static const activeAddress = "address";
  static const wallets = "wallets";

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

  static Future<void> writeAccessToken(String token) async {
    _secureStorage.write(key: "accessToken", value: token);
  }

  static Future<void> writePinCode(String pinCode) async {
    _secureStorage.write(key: "pinCode", value: pinCode);
  }

  static Future<void> writeConfig(String config) async {
    _secureStorage.write(key: "configName", value: config);
  }

  static Future<String?> readConfig() async {
    return await _secureStorage.read(key: "configName");
  }

  static Future<String?> readPinCode() async {
    return await _secureStorage.read(key: "pinCode");
  }

  static Future<String?> readRefreshToken() async {
    return await _secureStorage.read(key: "refreshToken");
  }

  static Future<bool> toLoginCheck() async {
    if (!await _secureStorage.containsKey(key: "refreshToken")) return false;
    if (!await _secureStorage.containsKey(key: "pinCode")) return false;
    return true;
  }

  static Future<String?> readAccessToken() async {
    return await _secureStorage.read(key: "accessToken");
  }

  static deleteAllFromSecureStorage() async {
    await _secureStorage.deleteAll();
    FirebaseMessaging.instance.deleteToken();
  }

  ///Wallets
  static Future<void> write(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  static Future<String?> read(String key) async {
    return await _secureStorage.read(key: key);
  }

  static Future<void> delete(String key) async {
    return await _secureStorage.delete(key: key);
  }

  static Future<Wallet?> readWallet() async {
    String? wallet = await _secureStorage.read(key: "wallet");
    if (wallet == null) {
      return null;
    }

    return Wallet.fromJson(jsonDecode(wallets));
  }
}
