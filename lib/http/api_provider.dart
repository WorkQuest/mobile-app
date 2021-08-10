import 'dart:typed_data';
import 'package:app/http/core/i_http_client.dart';
import 'package:app/model/bearer_token.dart';
import 'package:app/model/create_quest_model/create_quest_request_model.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/model/quests_models/quest_map_point.dart';
import 'package:dio/dio.dart';
import 'package:drishya_picker/drishya_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import 'package:injectable/injectable.dart';

@singleton
class ApiProvider {
  final IHttpClient _httpClient;

  ApiProvider(this._httpClient);
}

final Dio _dio = Dio();

extension LoginService on ApiProvider {
  Future<BearerToken> login({
    required String email,
    required String password,
  }) async {
    final responseData = await _httpClient.post(
      query: '/v1/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );
    BearerToken bearerToken = BearerToken.fromJson(
      responseData,
    );
    _httpClient.accessToken = bearerToken.access;
    return bearerToken;
  }

  Future<BearerToken> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final responseData = await _httpClient.post(
      query: '/v1/auth/register',
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password
      },
    );
    BearerToken bearerToken = BearerToken.fromJson(
      responseData,
    );
    _httpClient.accessToken = bearerToken.access;
    return bearerToken;
  }

  Future<BearerToken> refreshToken(String refreshToken) async {
    _httpClient.accessToken = refreshToken;
    final responseData = await _httpClient.post(
      query: '/v1/auth/refresh-tokens',
    );
    BearerToken bearerToken = BearerToken.fromJson(
      responseData,
    );
    _httpClient.accessToken = bearerToken.access;
    return bearerToken;
  }
}

extension QuestService on ApiProvider {
  Future<void> createQuest({
    required CreateQuestRequestModel quest,
  }) async {
    await _httpClient.post(
      query: '/v1/quest/create',
      data: quest.toJson(),
    );
  }

  Future<List<QuestMapPoint>> mapPoints(LatLngBounds bounds) async {
    final response = await _httpClient.get(
      query: '/v1/quests/map/points' +
          '?north[latitude]=${bounds.northeast.latitude.toString()}&' +
          'north[longitude]=${bounds.northeast.longitude.toString()}' +
          '&south[latitude]=${bounds.southwest.latitude.toString()}&' +
          'south[longitude]=${bounds.southwest.longitude.toString()}',
    );
    return List<QuestMapPoint>.from(
      response.map(
        (x) => QuestMapPoint.fromJson(x),
      ),
    );
  }

  Future<List<BaseQuestResponse>> getEmployerQuests(
    String userId, {
    int limit = 10,
    int offset = 0,
    String? searchWord,
    int priority = -1,
    int status = -1,
    String? sort,
    bool invited = true,
    bool performing = false,
    bool starred = false,
  }) async {
    final responseData = await _httpClient.get(
      query: "/v1/employer/$userId/quests",
    );
    return List<BaseQuestResponse>.from(
      responseData["quests"].map(
        (x) => BaseQuestResponse.fromJson(x),
      ),
    );
  }

  Future<BaseQuestResponse> getQuest({
    required String id,
  }) async {
    final responseData = await _httpClient.get(query: '/v1/quest/$id');
    return BaseQuestResponse.fromJson(responseData);
  }

  Future<List<BaseQuestResponse>> getQuests({
    int limit = 10,
    int offset = 0,
    String searchWord = "",
    int priority = -1,
    int status = -1,
    String? sort,
    bool? invited,
    bool? performing,
    bool? starred,
  }) async {
    final responseData = await _httpClient.get(
      query: '/v1/quests',
      queryParameters: {
        "offset": offset,
        "limit": limit,
        if (searchWord.isNotEmpty) "q": searchWord,
        //"priority": priority == -1 ? null : priority,
        //"status": status == -1 ? null : status,
        //"sort": sort,
        "invited": invited,
        "performing": performing,
        "starred": starred,
      },
    );

    return List<BaseQuestResponse>.from(
      responseData["quests"].map(
        (x) => BaseQuestResponse.fromJson(x),
      ),
    );
  }
}

extension UserInfoService on ApiProvider {
  Future<ProfileMeResponse> getProfileMe() async {
    final responseData = await _httpClient.get(
      query: '/v1/profile/me',
    );
    return ProfileMeResponse.fromJson(responseData);
  }
}

extension SetRoleService on ApiProvider {
  Future<void> setRole(String role) async {
    await _httpClient.post(
      query: '/v1/profile/set-role',
      data: {
        "role": role,
      },
    );
  }
}

extension ConfirmEmailService on ApiProvider {
  Future<void> confirmEmail({
    required String code,
  }) async {
    await _httpClient.post(
      query: '/v1/auth/confirm-email',
      data: {
        "confirmCode": code,
      },
    );
  }
}

extension ChangePassword on ApiProvider {
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await _httpClient.put(
      query: '/v1/profile/change-password',
      data: {
        "oldPassword": oldPassword,
        "newPassword": newPassword,
      },
    );
  }
}

extension GetUploadLink on ApiProvider {
  Future<List<String>> uploadMedia({
    required List<DrishyaEntity> medias,
  }) async {
    List<String> mediaId = [];
    Uint8List? bytes;

    for (var media in medias) {
      String contentType =
          media.entity.type == AssetType.video ? "video/mp4" : "image/jpeg";

      if (media.entity.type == AssetType.video) {
        File? file = await media.entity.file;
        bytes = await file!.readAsBytes();
      } else
        bytes = media.bytes;

      final response = await _httpClient.post(
        query: '/v1/storage/get-upload-link',
        data: {
          "contentType": contentType,
        },
      );
      await _uploadMedia(
        response["url"],
        bytes,
        contentType,
      );
      mediaId.add(response["mediaId"]);
    }
    print("$mediaId");
    return mediaId;
  }
}

Future _uploadMedia(
    String uploadLink, Uint8List? bytes, String contentType) async {
  await _dio.put(
    '$uploadLink',
    data: MultipartFile.fromBytes(bytes!).finalize(),
    options: Options(
      headers: {
        'Content-Type': contentType,
        "x-amz-acl": " public-read",
        'Connection': 'keep-alive',
        'Content-Length': bytes.length,
      },
    ),
  );
}
