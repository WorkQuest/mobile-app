import 'dart:io';

import 'package:app/enums.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/utils/storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class IChooseRoleRepository {
  Future approveRole({
    required bool isChange,
    required UserRole role,
  });

  Future changeRole(String totp);

  Future refreshToken();

  Future deletePushToken();
}

class ChooseRoleRepository extends IChooseRoleRepository {
  ChooseRoleRepository(ApiProvider apiProvider) : _apiProvider = apiProvider;

  final ApiProvider _apiProvider;

  @override
  Future approveRole({required bool isChange, required UserRole role}) async {
    try {
      final newRole = isChange
          ? role == UserRole.Worker
              ? "employer"
              : "worker"
          : role == UserRole.Worker
              ? "worker"
              : "employer";
      await _apiProvider.setRole(newRole);
    } catch (e) {
      print('ChooseRoleRepository approveRole | error: $e');
      throw ChooseRoleException(e.toString());
    }
  }

  @override
  Future changeRole(String totp) async {
    try {
      await _apiProvider.changeRole(totp);
    } catch (e) {
      print('ChooseRoleRepository changeRole | error: $e');
      throw ChooseRoleException(e.toString());
    }
  }

  @override
  Future refreshToken() async {
    try {
      String? token = await Storage.readRefreshToken();
      final bearerToken = await _apiProvider.refreshToken(token!, Platform.isIOS ? "iOS" : "Android");
      await Storage.writeRefreshToken(bearerToken.refresh);
      await Storage.writeAccessToken(bearerToken.access);
    } catch (e) {
      print('ChooseRoleRepository refreshToken | error: $e');
      throw ChooseRoleException(e.toString());
    }
  }

  @override
  Future deletePushToken() async {
    try {
      final token = await Storage.readPushToken();
      if (token != null) await _apiProvider.deletePushToken(token: token);
      await Storage.delete("pushToken");
      FirebaseMessaging.instance.deleteToken();
    } catch (e) {
      print('ChooseRoleRepository deletePushToken | error: $e');
      throw ChooseRoleException(e.toString());
    }
  }
}

class ChooseRoleException implements Exception {
  final String message;

  const ChooseRoleException([this.message = 'Unknown choose role error']);

  @override
  String toString() => message;
}
