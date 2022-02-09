import 'dart:io';
import 'dart:typed_data';
import 'package:app/enums.dart';
import 'package:app/http/core/i_http_client.dart';
import 'package:app/model/bearer_token.dart';
import 'package:app/model/quests_models/create_quest_request_model.dart';
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
  final IHttpClient httpClient;

  ApiProvider(this.httpClient);
}

final Dio _dio = Dio();

extension LoginService on ApiProvider {
  Future<BearerToken> login({
    required String email,
    required String password,
  }) async {
    final responseData = await httpClient.post(
      query: '/v1/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );
    BearerToken bearerToken = BearerToken.fromJson(
      responseData,
    );
    httpClient.accessToken = bearerToken.access;
    return bearerToken;
  }

  Future<BearerToken> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final responseData = await httpClient.post(
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
    httpClient.accessToken = bearerToken.access;
    return bearerToken;
  }

  Future<BearerToken> refreshToken(
    String refreshToken,
  ) async {
    httpClient.accessToken = refreshToken;
    final responseData = await httpClient.post(
      query: '/v1/auth/refresh-tokens',
    );
    BearerToken bearerToken = BearerToken.fromJson(
      responseData,
    );
    httpClient.accessToken = bearerToken.access;
    return bearerToken;
  }
}

extension QuestService on ApiProvider {
  Future<void> createQuest({
    required CreateQuestRequestModel quest,
  }) async {
    await httpClient.post(
      query: '/v1/quest/create',
      data: quest.toJson(),
    );
  }

  Future<void> editQuest({
    required CreateQuestRequestModel quest,
    required String questId,
  }) async {
    await httpClient.put(
      query: '/v1/quest/$questId',
      data: quest.toJson(),
    );
  }

  Future<List<BaseQuestResponse>> mapPoints(LatLngBounds bounds) async {
    final response = await httpClient.get(
      query: '/v1/quest/map/points'
              '?northAndSouthCoordinates[north][latitude]=${bounds.northeast.latitude.toString()}&' +
          'northAndSouthCoordinates[north][longitude]=${bounds.northeast.longitude.toString()}' +
          '&northAndSouthCoordinates[south][latitude]=${bounds.southwest.latitude.toString()}&' +
          'northAndSouthCoordinates[south][longitude]=${bounds.southwest.longitude.toString()}',
    );

    // final response2 = await httpClient.get(
    //   query: '/v1/quests' +
    //       '?north[latitude]=${bounds.northeast.latitude.toString()}&' +
    //       'north[longitude]=${bounds.northeast.longitude.toString()}' +
    //       '&south[latitude]=${bounds.southwest.latitude.toString()}&' +
    //       'south[longitude]=${bounds.southwest.longitude.toString()}',
    // );

    //print("<-------------->$response <-------------->");

    return List<BaseQuestResponse>.from(
      response["quests"].map(
        (x) => BaseQuestResponse.fromJson(x),
      ),
    );
  }

  Future<List<BaseQuestResponse>> getEmployerQuests({
    String userId = "",
    int limit = 10,
    int offset = 0,
    int? priority,
    String sort = "",
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
      final responseData = await httpClient.get(
        query: "/v1/employer/$userId/quests?$status$sort",
        queryParameters: {
          "offset": offset,
          "limit": limit,
          if (priority != null) "priority": priority,
          if (invited != null) "invited": invited,
          if (performing != null) "performing": performing,
          if (starred != null) "starred": starred,
        },
      );
      return List<BaseQuestResponse>.from(
          responseData["quests"].map((x) => BaseQuestResponse.fromJson(x)));
    } catch (e) {
      return [];
    }
  }

  Future<List<BaseQuestResponse>> getAvailableQuests({
    String userId = "",
  }) async {
    try {
      final responseData =
          await httpClient.get(query: "/v1/worker/$userId/available-quests");
      return List<BaseQuestResponse>.from(
          responseData["quests"].map((x) => BaseQuestResponse.fromJson(x)));
    } catch (e) {
      return [];
    }
  }

  Future<List<BaseQuestResponse>> getWorkerQuests({
    String userId = "",
    int limit = 10,
    int offset = 0,
    List<int> statuses = const [],
    String sort = "",
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
    final responseData = await httpClient.get(
      query: '/v1/worker/$userId/quests?$status$sort',
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

    return List<BaseQuestResponse>.from(
      responseData["quests"].map(
        (x) => BaseQuestResponse.fromJson(x),
      ),
    );
  }

  Future<BaseQuestResponse> getQuest({
    required String id,
  }) async {
    final responseData = await httpClient.get(query: '/v1/quest/$id');
    return BaseQuestResponse.fromJson(responseData);
  }

  Future<List<BaseQuestResponse>> getQuests({
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
    final responseData = await httpClient.get(
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

    return List<BaseQuestResponse>.from(
      responseData["quests"].map(
        (x) => BaseQuestResponse.fromJson(x),
      ),
    );
  }

  Future<Map<String, dynamic>> getWorkers({
    String searchWord = "",
    String sort = "",
    int limit = 10,
    int offset = 0,
    String? north,
    String? south,
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
      priorities += "priorities[]=$text&";
    });
    String ratingStatuses = "";
    ratingStatus.forEach((text) {
      ratingStatuses += "ratingStatuses[]=$text&";
    });
    String workplaces = "";
    workplace.forEach((text) {
      workplaces += "workplaces[]=$text&";
    });
    final responseData = await httpClient.get(
      query:
          '/v1/profile/workers?$priorities$ratingStatuses$workplaces$sort&$specialization',
      queryParameters: {
        if (searchWord.isNotEmpty) "q": searchWord,
        "offset": offset,
        "limit": limit,
        if (north != null) "north": north,
        if (south != null) "south": south,
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
    final responseData = await httpClient.get(
      query: '/v1/profile/$userId',
    );
    return ProfileMeResponse.fromJson(responseData);
  }

  Future<Map<int, List<int>>> getSkillFilters() async {
    final responseData = await httpClient.get(
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
    final isSuccess = await httpClient.post(
      query: '/v1/quest/$id/star',
    );
    return isSuccess == null;
  }

  Future<bool> removeStar({
    required String id,
  }) async {
    final isSuccess = await httpClient.delete(query: '/v1/quest/$id/star');
    return isSuccess == null;
  }

  Future<bool> respondOnQuest({
    required String id,
    required String message,
    required List media,
  }) async {
    try {
      final responseData = await httpClient.post(
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
          await httpClient.get(query: '/v1/quest/responses/my');
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
      final responseData = await httpClient.post(
        query: '/v1/quest/$questId/start',
        data: body,
      );
      return responseData == null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> inviteOnQuest({
    required String questId,
    required String userId,
    required String message,
  }) async {
    try {
      final responseData = await httpClient.post(
        query: '/v1/quest/$questId/invite',
        data: {
          "invitedUserId": userId,
          "message": message,
        },
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
      final responseData = await httpClient.post(
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
      final responseData = await httpClient.post(
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
          await httpClient.post(query: '/v1/quest/$questId/accept-work');
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
          await httpClient.post(query: '/v1/quest/$questId/reject-work');
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
          await httpClient.post(query: '/v1/quest/$questId/complete-work');
      return responseData == null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteQuest({
    required String questId,
  }) async {
    try {
      final responseData = await httpClient.delete(query: '/v1/quest/$questId');
      return responseData == null;
    } catch (e) {
      return false;
    }
  }

  Future<List<RespondModel>> responsesQuest(String id) async {
    try {
      final responseData = await httpClient.get(
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
      final responseData = await httpClient.get(
        query: '/v1/profile/me',
      );
      return ProfileMeResponse.fromJson(responseData);
    } catch (e, trace) {
      print("ERROR: $e");
      print("ERROR: $trace");
      final responseData = await httpClient.get(
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
        "phoneNumber": {
          "codeRegion": userData.phone.codeRegion,
          "phone": userData.phone.phone,
          "fullPhone": userData.phone.fullPhone
        },
        "firstName": userData.firstName,
        "lastName": userData.lastName.isNotEmpty ? userData.lastName : null,
        if (userData.role == UserRole.Worker)
          "wagePerHour": userData.wagePerHour,
        if (userData.role == UserRole.Worker)
          "priority": userData.priority.index,
        if (userData.role == UserRole.Worker) "workplace": userData.workplace,
        "additionalInfo": {
          "secondMobileNumber": {
            "codeRegion":
                userData.additionalInfo?.secondMobileNumber.codeRegion,
            "phone": userData.additionalInfo?.secondMobileNumber.phone,
            "fullPhone": userData.additionalInfo?.secondMobileNumber.fullPhone,
          },
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
        "locationFull": {
          "location": {
            "longitude": userData.locationCode?.longitude ?? 0,
            "latitude": userData.locationCode?.latitude ?? 0
          },
          "locationPlaceName": userData.locationPlaceName ?? "",
        }
      };
      if (userData.firstName.isEmpty) throw Exception("firstName is empty");
      final responseData;
      if (role == UserRole.Worker)
        responseData =
            await httpClient.put(query: '/v1/worker/profile/edit', data: body);
      else
        responseData = await httpClient.put(
            query: '/v1/employer/profile/edit', data: body);
      return ProfileMeResponse.fromJson(responseData);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

extension SetRoleService on ApiProvider {
  Future<void> setRole(String role) async {
    await httpClient.post(
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
    await httpClient.post(
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
    await httpClient.put(
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
    await httpClient.post(
      query: '/v1/profile/phone/send-code',
      data: {
        "phoneNumber": phoneNumber,
      },
    );
  }

  Future<void> submitCode({
    required String confirmCode,
  }) async {
    await httpClient.post(
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
        case "docx":
          contentType = "application/msword";
          break;
      }

      bytes = media.readAsBytesSync();

      final response = await httpClient.post(
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

///Two FA
extension TwoFA on ApiProvider {
  Future<String> enable2FA() async {
    final responseData = await httpClient.post(
      query: '/v1/totp/enable',
    );
    return responseData;
  }

  Future<void> disable2FA({
    required String totp,
  }) async {
    await httpClient.post(
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
    await httpClient.post(
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
    await httpClient.put(
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
    await httpClient.post(
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
    await httpClient.delete(
      query: '/v1/portfolio/$portfolioId',
    );
  }

  Future<List<PortfolioModel>> getPortfolio({
    required String userId,
    required int offset,
  }) async {
    try {
      final responseData = await httpClient.get(
        query: '/v1/user/$userId/portfolio/cases',
        queryParameters: {
          "offset": offset,
        },
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
    await httpClient.post(
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
    await httpClient.post(
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
    await httpClient.post(
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
    required int offset,
  }) async {
    try {
      final response = await httpClient.get(
        query: '/v1/user/$userId/reviews',
        queryParameters: {
          "offset": offset,
        },
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
