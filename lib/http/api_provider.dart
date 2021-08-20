import 'dart:typed_data';
import 'package:app/enums.dart';
import 'package:app/http/core/i_http_client.dart';
import 'package:app/model/bearer_token.dart';
import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/model/create_quest_model/create_quest_request_model.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/model/quests_models/quest_map_point.dart';
import 'package:app/model/respond_model.dart';
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
    bool invited = false,
    bool performing = false,
    bool starred = false,
  }) async {
    try {
      final responseData = await _httpClient
          .get(query: "/v1/employer/$userId/quests", queryParameters: {
        if (invited) "invited": invited.toString(),
        if (performing) "performing": performing.toString(),
        if (starred) "starred": starred.toString(),
      });
      return List<BaseQuestResponse>.from(
        responseData["quests"].map(
          (x) => BaseQuestResponse.fromJson(x),
        ),
      );
    } catch (e) {
      return [];
    }
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
    int? priority,
    int? status,
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
        if (priority != null) "priority": priority,
        if (status != null) "status": status,
        //"sort": sort,
        if (invited != null) "invited": invited,
        if (performing != null) "performing": performing,
        if (starred != null) "starred": starred,
      },
    );

    return List<BaseQuestResponse>.from(
      responseData["quests"].map(
        (x) => BaseQuestResponse.fromJson(x),
      ),
    );
  }

  Future<bool> setStar({
    required String id,
  }) async {
    final isSuccess = await _httpClient.post(query: '/v1/quest/$id/star');
    return isSuccess == null;
  }

  Future<bool> removeStar({
    required String id,
  }) async {
    final isSuccess = await _httpClient.delete(query: '/v1/quest/$id/star');
    return isSuccess == null;
  }

  Future<bool> respondOnQuest({
    required String id,
    required String message,
  }) async {
    try {
      final responseData = await _httpClient.post(
        query: '/v1/quest/$id/response',
        data: {"message": message},
      );
      return responseData == null;
    } catch (e) {
      return false;
    }
  }

  Future<List<BaseQuestResponse>> responsesQuests() async {
    try {
      final responseData =
          await _httpClient.get(query: '/v1/quest/responses/my');
      return List<BaseQuestResponse>.from(
        responseData["responses"].map(
          (x) => BaseQuestResponse.fromJson(x),
        ),
      );
    } catch (e) {
      return [];
    }
  }

  Future<List<RespondModel>> responsesQuest(String id) async {
    try {
      final responseData =
          await _httpClient.get(query: '/v1/quest/$id/responses');

      return List<RespondModel>.from(
        responseData["responses"].map(
          (x) => RespondModel.fromJson(x),
        ),
      );
    } catch (e) {
      return [];
    }
  }
}

extension UserInfoService on ApiProvider {
  Future<ProfileMeResponse> getProfileMe() async {
    final responseData = await _httpClient.get(
      query: '/v1/profile/me',
    );
    return ProfileMeResponse.fromJson(responseData);
  }

  Future<ProfileMeResponse> changeProfileMe(ProfileMeResponse userData) async {
    try {
      final body = {
        "avatarId": (userData.avatarId.isEmpty) ? null : userData.avatarId,
        "firstName": userData.firstName,
        "lastName":
            (userData.lastName?.isNotEmpty ?? false) ? userData.lastName : null,
        "additionalInfo": {
          "secondMobileNumber":
              (userData.additionalInfo?.secondMobileNumber?.isNotEmpty ?? false)
                  ? userData.additionalInfo?.secondMobileNumber
                  : null,
          "address": (userData.additionalInfo?.address?.isNotEmpty ?? false)
              ? userData.additionalInfo?.address
              : null,
          "socialNetwork": {
            "instagram": (userData
                        .additionalInfo?.socialNetwork?.instagram?.isNotEmpty ??
                    false)
                ? userData.additionalInfo?.socialNetwork?.instagram
                : null,
            "twitter":
                (userData.additionalInfo?.socialNetwork?.twitter?.isNotEmpty ??
                        false)
                    ? userData.additionalInfo?.socialNetwork?.twitter
                    : null,
            "linkedin":
                (userData.additionalInfo?.socialNetwork?.linkedin?.isNotEmpty ??
                        false)
                    ? userData.additionalInfo?.socialNetwork?.linkedin
                    : null,
            "facebook":
                (userData.additionalInfo?.socialNetwork?.facebook?.isNotEmpty ??
                        false)
                    ? userData.additionalInfo?.socialNetwork?.facebook
                    : null,
          },
          "description":
              (userData.additionalInfo?.description?.isNotEmpty ?? false)
                  ? userData.additionalInfo?.description
                  : null,
          if (userData.role == UserRole.Employer)
            "company": (userData.additionalInfo?.company?.isNotEmpty ?? false)
                ? userData.additionalInfo?.company
                : null,
          if (userData.role == UserRole.Employer)
            "CEO": (userData.additionalInfo?.ceo?.isNotEmpty ?? false)
                ? userData.additionalInfo?.ceo
                : null,
          if (userData.role == UserRole.Employer)
            "website": (userData.additionalInfo?.website?.isNotEmpty ?? false)
                ? userData.additionalInfo?.website
                : null,
          if (userData.role == UserRole.Worker)
            "educations": [
              {
                "from": DateTime.now().toString(),
                "to": DateTime.now().toString(),
                "place": DateTime.now().toString(),
              }
            ],
          if (userData.role == UserRole.Worker)
            "workExperiences": [
              {
                "from": DateTime.now().toString(),
                "to": DateTime.now().toString(),
                "place": DateTime.now().toString(),
              }
            ],
          if (userData.role == UserRole.Worker) "skills": [],
        }
      };
      if (userData.firstName.isEmpty) throw Exception("firstName is empty");
      final responseData =
          await _httpClient.put(query: '/v1/profile/edit', data: body);
      return ProfileMeResponse.fromJson(responseData);
    } catch (e) {
      throw Exception(e.toString());
    }
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

extension SMSVerification on ApiProvider {
  Future<void> submitPhoneNumber({
    required String phoneNumber,
  }) async {
    await _httpClient.post(
      query: '/v1/profile/phone/send-code',
      data: {
        "phoneNumber": phoneNumber,
      },
    );
  }

  Future<void> submitCode({
    required String confirmCode,
  }) async {
    await _httpClient.post(
      query: '/v1/profile/phone/confirm',
      data: {
        "confirmCode": confirmCode,
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
}

extension ChatsService on ApiProvider {
  Future<List<ChatModel>> getChats() async {
    final responseData = await _httpClient.get(query: '/v1/user/me/chats');
    return List<ChatModel>.from(
      responseData["chats"].map(
        (x) => ChatModel.fromJson(x),
      ),
    );
  }

  Future<Map<String, dynamic>> getMessages({
    required String chatId,
    required int offset,
    required int limit,
  }) async {
    final responseData = await _httpClient.get(
      query: '/v1/user/me/chat/$chatId/messages',
      queryParameters: {
        "offset": offset,
        "limit": limit,
      },
    );
    return responseData;
  }

  Future<bool> sendMessageToChat({
    required String chatId,
    String? text,
    List<String>? mediasId,
  }) async {
    final responseData = await _httpClient.post(
      query: '/v1/chat/$chatId/send-message',
      data: {
        "text": text ?? "",
        "medias": mediasId ?? [],
      },
    );
    return responseData == null;
  }
}
