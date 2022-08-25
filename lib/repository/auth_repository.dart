import 'dart:convert';
import 'dart:io';

import 'package:app/http/api_provider.dart';
import 'package:app/http/web3_extension.dart';
import 'package:app/model/bearer_token.dart';
import 'package:app/utils/storage.dart';
import 'package:app/web3/repository/wallet_repository.dart';
import 'package:app/web3/wallet.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class IAuthRepository {
  Future refreshToken();

  Future signInWallet(String mnemonic);

  Future<BearerToken> signInEmailPassword({required String username, required String password, String totp = ''});

  Future<bool> validateTotp(String totp);

  Future deletePushToken();
}

class AuthRepository extends IAuthRepository {
  AuthRepository(ApiProvider apiProvider) : _apiProvider = apiProvider;

  ApiProvider _apiProvider;

  @override
  Future refreshToken() async {
    try {
      String? token = await Storage.readRefreshToken();
      final bearerToken = await _apiProvider.refreshToken(token!, Platform.isIOS ? "iOS" : "Android");
      await Storage.writeRefreshToken(bearerToken.refresh);
      await Storage.writeAccessToken(bearerToken.access);
    } catch (e) {
      print('AuthRepository refreshToken | error: $e');
      throw AuthException(e.toString());
    }
  }

  @override
  Future signInWallet(String mnemonic) async {
    try {
      Wallet? wallet = await Wallet.derive(mnemonic);
      WalletRepository().connectClient();
      final signature = await WalletRepository().getClient().getSignature(wallet.privateKey!);
      final userMe = await _apiProvider.getProfileMe();
      final _address = await _apiProvider.walletLogin(signature, wallet.address!);
      if (_address != userMe.walletAddress) {
        throw FormatException("Incorrect mnemonic");
      }
      WalletRepository().setWallet(wallet);
      await Storage.write(StorageKeys.wallet.name, jsonEncode(wallet.toJson()));
      await Storage.write(StorageKeys.networkName.name, WalletRepository().networkName.value!.name);
    } catch (e) {
      print('AuthRepository signInWallet | error: $e');
      throw AuthException(e.toString());
    }
  }

  @override
  Future<BearerToken> signInEmailPassword({
    required String username,
    required String password,
    String totp = '',
  }) async {
    try {
      final bearerToken = await _apiProvider.login(
        email: username.trim(),
        password: password,
        platform: Platform.isIOS ? "iOS" : "Android",
        totp: totp,
      );

      await Storage.writeRefreshToken(bearerToken.refresh);
      await Storage.writeAccessToken(bearerToken.access);

      return bearerToken;
    } catch (e) {
      print('AuthRepository signInEmailPassword | error: $e');
      throw AuthException(e.toString());
    }
  }

  @override
  Future<bool> validateTotp(String totp) async {
    try {
      return await _apiProvider.validateTotp(totp: totp);
    } catch (e) {
      print('AuthRepository validateTotp | error: $e');
      throw AuthException(e.toString());
    }
  }

  @override
  Future deletePushToken() async {
    try {
      final token = await Storage.readPushToken();
      if (token != null) await _apiProvider.deletePushToken(token: token);
      FirebaseMessaging.instance.deleteToken();
    } catch (e) {
      print('AuthRepository deletePushToken | error: $e');
      throw AuthException(e.toString());
    }
  }
}

class AuthException implements Exception {
  final String message;

  AuthException([this.message = 'Unknown Auth error']);

  @override
  String toString() => message;
}
