import 'dart:io';
import 'dart:typed_data';
import 'package:app/enums.dart';
import 'package:app/http/core/i_http_client.dart';
import 'package:app/model/bearer_token.dart';
import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/model/chat_model/message_model.dart';
import 'package:app/model/create_quest_model/create_quest_request_model.dart';
import 'package:app/model/profile_response/portfolio.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/profile_response/review.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/model/quests_models/quest_map_point.dart';
import 'package:app/model/respond_model.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  Future<BearerToken> refreshToken(
    String refreshToken,
  ) async {
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

  Future<void> editQuest({
    required CreateQuestRequestModel quest,
    required String questId,
  }) async {
    await _httpClient.put(
      query: '/v1/quest/$questId',
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

  // Future<List<BaseQuestResponse>>
  Future<Map<String, dynamic>> getEmployerQuests({
    String userId = "",
    int limit = 10,
    int offset = 0,
    int? priority,
    List<int> statuses = const [],
    bool? invited,
    bool? performing,
    bool? starred,
  }) async {
    try {
      String status = "";
      statuses.forEach((text) {
        status += "statuses[]=$text&";
      });
      final responseData = await _httpClient.get(
        query: "/v1/employer/$userId/quests?$status",
        queryParameters: {
          "offset": offset,
          "limit": limit,
          if (priority != null) "priority": priority,
          if (invited != null) "invited": invited,
          if (performing != null) "performing": performing,
          if (starred != null) "starred": starred,
        },
      );
      return responseData;
      //   List<BaseQuestResponse>.from(
      //   responseData["quests"].map(
      //     (x) => BaseQuestResponse.fromJson(x),
      //   ),
      // );
    } catch (e) {
      return {};
    }
  }
  Future<Map<String, dynamic>> getWorkerQuests({
    String userId = "",
    int limit = 10,
    int offset = 0,
    List<int> statuses = const [],
    bool? invited,
    bool? performing,
    bool? starred,
    String? north,
    String? south,
  }) async {
    String status = "";
    statuses.forEach((text) {
      status += "statuses[]=$text&";
    });
    final responseData = await _httpClient.get(
      query:
      '/v1/worker/$userId/quests?$status',
      queryParameters: {
        "offset": offset,
        "limit": limit,
        if (invited != null) "invited": invited,
        if (performing != null) "performing": performing,
        if (starred != null) "starred": starred,
        if (north != null) "north": north,
        if (south != null) "south": south,
      },
    );

    return responseData;
    //   List<BaseQuestResponse>.from(
    //   responseData["quests"].map(
    //     (x) => BaseQuestResponse.fromJson(x),
    //   ),
    // );
  }

  Future<BaseQuestResponse> getQuest({
    required String id,
  }) async {
    final responseData = await _httpClient.get(query: '/v1/quest/$id');
    return BaseQuestResponse.fromJson(responseData);
  }


  Future<Map<String, dynamic>> getQuests({
    List<String> workplace = const [],
    List<String> employment = const [],
    int limit = 10,
    int offset = 0,
    String searchWord = "",
    List<int> priority = const [],
    List<int> statuses = const [],
    String sort = "",
    List<String> specializations = const [],
    bool? invited,
    bool? performing,
    bool? starred,
    String? north,
    String? south,
  }) async {
    String specialization = "";
    specializations.forEach((text) {
      specialization += "specializations[]=$text&";
    });
    String status = "";
    statuses.forEach((text) {
      status += "statuses[]=$text&";
    });
    String priorities = "";
    priority.forEach((text) {
      priorities += "priorities[]=$text&";
    });
    String workplaces = "";
    workplace.forEach((text) {
      workplaces += "workplaces[]=$text&";
    });
    String employments = "";
    employment.forEach((text) {
      employments += "employments[]=$text&";
    });
    final responseData = await _httpClient.get(
      query:
          '/v1/quests?$workplaces$employments$status$specialization$priorities$sort',
      queryParameters: {
        "offset": offset,
        "limit": limit,
        if (searchWord.isNotEmpty) "q": searchWord,
        // if (sort.isNotEmpty) "sort": sort,
        if (invited != null) "invited": invited,
        if (performing != null) "performing": performing,
        if (starred != null) "starred": starred,
        if (north != null) "north": north,
        if (south != null) "south": south,
      },
    );

    return responseData;
    //   List<BaseQuestResponse>.from(
    //   responseData["quests"].map(
    //     (x) => BaseQuestResponse.fromJson(x),
    //   ),
    // );
  }

  Future<Map<String, dynamic>> getWorkers({
    String searchWord = "",
    String sort = "",
    int limit = 10,
    int offset = 0,
    List<int> priority = const [],
    List<String> ratingStatus = const [],
    List<String> workplace = const [],
    List<String> specializations = const [],
  }) async {
    String specialization = "";
    specializations.forEach((text) {
      specialization += "specializations[]=$text&";
    });
    String priorities = "";
    priority.forEach((text) {
      priorities += "priority[]=$text&";
    });
    String ratingStatuses = "";
    ratingStatus.forEach((text) {
      ratingStatuses += "ratingStatus[]=$text&";
    });
    String workplaces = "";
    workplace.forEach((text) {
      workplaces += "workplaces[]=$text&";
    });
    final responseData = await _httpClient.get(
      query:
          '/v1/profile/workers?$priorities$ratingStatuses$workplaces$sort$specialization',
      queryParameters: {
        if (searchWord.isNotEmpty) "q": searchWord,
        "offset": offset,
        "limit": limit,
        //"sort": sort,
      },
    );

    return responseData;
    //   List<ProfileMeResponse>.from(
    //   responseData["users"].map(
    //     (x) => ProfileMeResponse.fromJson(x),
    //   ),
    // );
  }

  Future<ProfileMeResponse> getProfileUser({
    required String userId,
  }) async {
    final responseData = await _httpClient.get(
      query: '/v1/profile/$userId',
    );
    return ProfileMeResponse.fromJson(responseData);
  }

  Future<Map<int, List<int>>> getSkillFilters() async {
    final responseData = await _httpClient.get(
      query: '/v1/skill-filters',
    );
    Map<int, List<int>> list = (responseData as Map).map((key, value) {
      return MapEntry<int, List<int>>(value["id"],
          (value["skills"] as Map).values.map((e) => e as int).toList());
    });
    return list;
  }

  Future<bool> setStar({
    required String id,
  }) async {
    final isSuccess = await _httpClient.post(
      query: '/v1/quest/$id/star',
    );
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
    required List media,
  }) async {
    try {
      final responseData = await _httpClient.post(
        query: '/v1/quest/$id/response',
        data: {
          "message": message,
          "medias": media,
        },
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

  Future<bool> startQuest({
    required String questId,
    required String userId,
  }) async {
    try {
      final body = {
        "assignedWorkerId": userId,
      };
      final responseData = await _httpClient.post(
        query: '/v1/quest/$questId/start',
        data: body,
      );
      return responseData == null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> acceptCompletedWork({
    required String questId,
  }) async {
    try {
      final responseData = await _httpClient.post(
          query: '/v1/quest/$questId/accept-completed-work');
      return responseData == null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> rejectCompletedWork({
    required String questId,
  }) async {
    try {
      final responseData = await _httpClient.post(
          query: '/v1/quest/$questId/reject-completed-work');
      return responseData == null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> acceptOnQuest({
    required String questId,
  }) async {
    try {
      final responseData =
          await _httpClient.post(query: '/v1/quest/$questId/accept-work');
      return responseData == null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> rejectOnQuest({
    required String questId,
  }) async {
    try {
      final responseData =
          await _httpClient.post(query: '/v1/quest/$questId/reject-work');
      return responseData == null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> completeWork({
    required String questId,
  }) async {
    try {
      final responseData =
          await _httpClient.post(query: '/v1/quest/$questId/complete-work');
      return responseData == null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteQuest({
    required String questId,
  }) async {
    try {
      final responseData =
          await _httpClient.delete(query: '/v1/quest/$questId');
      return responseData == null;
    } catch (e) {
      return false;
    }
  }

  Future<List<RespondModel>> responsesQuest(String id) async {
    try {
      final responseData = await _httpClient.get(
        query: '/v1/quest/$id/responses',
      );
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
    try {
      final responseData = await _httpClient.get(
        query: '/v1/profile/me',
      );
      return ProfileMeResponse.fromJson(responseData);
    } catch (e, trace) {
      print("ERROR: $e");
      print("ERROR: $trace");
      final responseData = await _httpClient.get(
        query: '/v1/profile/me',
      );
      return ProfileMeResponse.fromJson(responseData);
    }
  }

  Future<ProfileMeResponse> changeProfileMe(
    ProfileMeResponse userData,
    UserRole role,
  ) async {
    try {
      final body = {
        "avatarId": (userData.avatarId.isEmpty) ? null : userData.avatarId,
        "firstName": userData.firstName,
        "lastName": userData.lastName.isNotEmpty ? userData.lastName : null,
        if (userData.role == UserRole.Worker)
          "wagePerHour": userData.wagePerHour,
        if (userData.role == UserRole.Worker)
          "priority": userData.priority.index,
        if (userData.role == UserRole.Worker) "workplace": userData.workplace,
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
            "educations": userData.additionalInfo!.educations,
          if (userData.role == UserRole.Worker)
            "workExperiences": userData.additionalInfo!.workExperiences,
          if (userData.role == UserRole.Worker) "skills": [],
        },
        if (userData.role == UserRole.Worker)
          "specializationKeys": userData.userSpecializations,
        "location": {
          "longitude": userData.location?.longitude ?? 0,
          "latitude": userData.location?.latitude ?? 0,
        }
      };
      if (userData.firstName.isEmpty) throw Exception("firstName is empty");
      final responseData;
      if (role == UserRole.Worker)
        responseData =
            await _httpClient.put(query: '/v1/worker/profile/edit', data: body);
      else
        responseData = await _httpClient.put(
            query: '/v1/employer/profile/edit', data: body);
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

///SMSVerification
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

///Media Upload
extension GetUploadLink on ApiProvider {
  Future<List<String>> uploadMedia({
    required List<File> medias,
  }) async {
    List<String> mediaId = [];
    Uint8List? bytes;

    for (var media in medias) {
      String contentType = "";
      switch (media.path
          .split("/")
          .reversed
          .first
          .split(".")
          .reversed
          .toList()[0]) {
        case "mp4":
          contentType = "video/mp4";
          break;
        case "mov":
          contentType = "video/mp4";
          break;
        case "jpeg":
          contentType = "image/jpeg";
          break;
        case "jpg":
          contentType = "image/jpeg";
          break;
        case "png":
          contentType = "image/png";
          break;
        case "pdf":
          contentType = "application/pdf";
          break;
        case "doc":
          contentType = "application/msword";
          break;
      }

      bytes = media.readAsBytesSync();

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
    return mediaId;
  }

  Future _uploadMedia(
    String uploadLink,
    Uint8List? bytes,
    String contentType,
  ) async {
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

///Chat Service
extension ChatsService on ApiProvider {
  Future<List<ChatModel>> getChats({
    required int offset,
    required int limit,
  }) async {
    try {
      final responseData = await _httpClient.get(
        query: '/v1/user/me/chats',
        queryParameters: {
          "offset": offset,
          "limit": limit,
        },
      );
      return List<ChatModel>.from(
        responseData["chats"].map(
          (x) => ChatModel.fromJson(x),
        ),
      );
    } catch (e, stack) {
      print("ERROR $e");
      print("ERROR $stack");
      return [];
    }
  }

  Future<List<ProfileMeResponse>> getUsersForGroupCHat() async {
    try {
      final responseData = await _httpClient.get(
          query: '/v1/user/me/chat/members/users-by-chats');
      return List<ProfileMeResponse>.from(
        responseData["users"].map(
          (x) => ProfileMeResponse.fromJson(x),
        ),
      );
    } catch (e, trace) {
      print("ERROR: $e");
      print("ERROR: $trace");
      return [];
    }
  }

  Future<List<MessageModel>> getStarredMessage() async {
    try {
      final responseData =
          await _httpClient.get(query: '/v1/user/me/chat/messages/star');
      return List<MessageModel>.from(
        responseData["messages"].map(
          (x) => MessageModel.fromJson(x),
        ),
      );
    } catch (e, trace) {
      print("ERROR: $e");
      print("ERROR: $trace");
      return [];
    }
  }

  Future<Map<String, dynamic>> createGroupChat({
    required String chatName,
    required List<String> usersId,
  }) async {
    final responseData = await _httpClient.post(
      query: '/v1/user/me/chat/group/create',
      data: {
        "name": chatName,
        "memberUserIds": usersId,
      },
    );
    return responseData;
  }

  Future<void> addUsersInChat({
    required String chatId,
    required List<String> userIds,
  }) async {
    await _httpClient.post(
      query: '/v1/user/me/chat/group/$chatId/add',
      data: {"userIds": userIds},
    );
  }

  Future<void> setMessageStar({
    required String chatId,
    required String messageId,
  }) async {
    await _httpClient.post(
      query: '/v1/user/me/chat/$chatId/message/$messageId/star',
    );
  }

  Future<void> setChatStar({
    required String chatId,
  }) async {
    await _httpClient.post(
      query: '/v1/user/me/chat/$chatId/star',
    );
  }

  Future<void> removeStarFromMsg({
    required String messageId,
  }) async {
    await _httpClient.delete(
      query: '/v1/user/me/chat/message/$messageId/star',
    );
  }

  Future<void> removeStarFromChat({
    required String chatId,
  }) async {
    await _httpClient.delete(
      query: '/v1/user/me/chat/$chatId/star',
    );
  }

  Future<void> removeUser({
    required String chatId,
    required String userId,
  }) async {
    await _httpClient.delete(
      query: '/v1/user/me/chat/group/$chatId/remove/$userId',
    );
  }

  Future<void> setMessageRead({
    required String chatId,
    required String messageId,
  }) async {
    await _httpClient.post(
        query: '/v1/read/message/$chatId', data: {"messageId": messageId});
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
}

///Two FA
extension TwoFA on ApiProvider {
  Future<String> enable2FA() async {
    final responseData = await _httpClient.post(
      query: '/v1/totp/enable',
    );
    return responseData;
  }

  Future<void> disable2FA({
    required String totp,
  }) async {
    await _httpClient.post(
      query: '/v1/totp/disable',
      data: {
        "totp": totp,
      },
    );
  }

  Future<void> confirmEnabling2FA({
    required String confirmCode,
    required String totp,
  }) async {
    await _httpClient.post(
      query: '/v1/totp/enable',
      data: {
        "confirmCode": confirmCode,
        "totp": totp,
      },
    );
  }
}

///Portfolio
extension Portfolio on ApiProvider {
  Future<void> editPortfolio({
    required String portfolioId,
    required String title,
    required String description,
    required List<String> media,
  }) async {
    await _httpClient.put(
      query: '/v1/portfolio/$portfolioId',
      data: {
        "title": title,
        "description": description,
        "medias": media,
      },
    );
  }

  Future<void> addPortfolio({
    required String title,
    required String description,
    required List<String> media,
  }) async {
    await _httpClient.post(
      query: '/v1/portfolio/add-case',
      data: {
        "title": title,
        "description": description,
        "medias": media,
      },
    );
  }

  Future<void> deletePortfolio({
    required String portfolioId,
  }) async {
    await _httpClient.delete(
      query: '/v1/portfolio/$portfolioId',
    );
  }

  Future<List<PortfolioModel>> getPortfolio({
    required String userId,
  }) async {
    try {
      final responseData = await _httpClient.get(
        query: '/v1/user/$userId/portfolio/cases',
      );
      return List<PortfolioModel>.from(
        responseData["cases"].map(
          (x) => PortfolioModel.fromJson(x),
        ),
      );
    } catch (e, stack) {
      print("ERROR $e");
      print("ERROR $stack");
      return [];
    }
  }
}

extension RestorePassword on ApiProvider {
  Future<void> sendCodeToEmail({
    required String email,
  }) async {
    await _httpClient.post(
      query: '/v1/restore-password/send-code',
      data: {
        "email": email,
      },
    );
  }

  Future<void> setPassword({
    required String newPassword,
    required String token,
  }) async {
    await _httpClient.post(
      query: '/v1/restore-password/send-code',
      data: {
        "newPassword": newPassword,
        "token": token,
      },
    );
  }
}

extension Reviews on ApiProvider {
  Future<void> sendReview({
    required String questId,
    required String message,
    required int mark,
  }) async {
    await _httpClient.post(
      query: '/v1/review/send',
      data: {
        "questId": questId,
        "message": message,
        "mark": mark,
      },
    );
  }

  Future<List<Review>> getReviews({
    required String userId,
  }) async {
    try {
      final response = await _httpClient.get(
        query: '/v1/user/$userId/reviews',
      );
      return List<Review>.from(
        response["reviews"].map(
          (review) => Review.fromJson(review),
        ),
      );
    } catch (e, stack) {
      print("ERROR $e");
      print("ERROR $stack");
      return [];
    }
  }
}
