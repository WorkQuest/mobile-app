import 'dart:io';

import 'package:app/enums.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/utils/storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class IProfileMeRepository {
  Future<ProfileMeResponse?> getProfileMe();

  Future<List<BaseQuestResponse>> getCompletedQuests({
    required UserRole userRole,
    required String userId,
    required bool newList,
    required bool isProfileYours,
    int offset = 0,
  });

  Future<List<BaseQuestResponse>> getActiveQuests({
    required String userId,
    required bool newList,
    required bool isProfileYours,
    int offset = 0,
  });

  Future<ProfileMeResponse> changeProfile(
    ProfileMeResponse userData,
    ProfileMeResponse newUserData, {
    File? media,
  });

  Future deletePushToken();
}

class ProfileMeRepository extends IProfileMeRepository {
  ProfileMeRepository(ApiProvider apiProvider) : _apiProvider = apiProvider;

  final ApiProvider _apiProvider;

  @override
  Future<ProfileMeResponse> changeProfile(
    ProfileMeResponse userData,
    ProfileMeResponse newUserData, {
    File? media,
  }) async {
    try {
      if (media != null) {
        newUserData.avatarId =
            (await _apiProvider.uploadMedia(medias: [media]))[0];
      }
      final isTotpActive = userData.isTotpActive;
      final tempPhone = userData.tempPhone;
      newUserData = await _apiProvider.changeProfileMe(userData);
      newUserData.tempPhone = tempPhone;
      newUserData.isTotpActive = isTotpActive;
      return newUserData;
    } catch (e) {
      print('ProfileMeRepository changeProfile | error: $e');
      throw ProfileMeException(e.toString());
    }
  }

  @override
  Future deletePushToken() async {
    try {
      final token = await Storage.readPushToken();
      if (token != null) await _apiProvider.deletePushToken(token: token);
      FirebaseMessaging.instance.deleteToken();
    } catch (e) {
      print('ProfileMeRepository deletePushToken | error: $e');
      throw ProfileMeException(e.toString());
    }
  }

  @override
  Future<List<BaseQuestResponse>> getActiveQuests({
    required String userId,
    required bool newList,
    required bool isProfileYours,
    int offset = 0,
  }) async {
    try {
      return await _apiProvider.getWorkerQuests(
        offset: offset,
        sort: 'sort[createdAt]=desc',
        userId: userId,
        statuses: [-2, 3, 4],
        me: isProfileYours,
      );
    } catch (e) {
      print('ProfileMeRepository getActiveQuests | error: $e');
      throw ProfileMeException(e.toString());
    }
  }

  @override
  Future<List<BaseQuestResponse>> getCompletedQuests({
    required UserRole userRole,
    required String userId,
    required bool newList,
    required bool isProfileYours,
    int offset = 0,
  }) async {
    try {
      if (userRole == UserRole.Employer) {
        return await _apiProvider.getEmployerQuests(
          userId: userId,
          offset: offset,
          sort: 'sort[createdAt]=desc',
          statuses: [5],
          me: isProfileYours,
        );
      } else {
        return await _apiProvider.getWorkerQuests(
          userId: userId,
          offset: offset,
          sort: 'sort[createdAt]=desc',
          statuses: [5],
          me: isProfileYours,
        );
      }
    } catch (e) {
      print('ProfileMeRepository getCompletedQuests | error: $e');
      throw ProfileMeException(e.toString());
    }
  }

  @override
  Future<ProfileMeResponse?> getProfileMe() async {
    try {
      return await _apiProvider.getProfileMe();
    } catch (e) {
      print('ProfileMeRepository getProfileMe | error: $e');
      throw ProfileMeException(e.toString());
    }
  }
}

class ProfileMeException implements Exception {
  final String message;

  const ProfileMeException([this.message = 'Unknown profile me error']);

  @override
  String toString() => message;
}
