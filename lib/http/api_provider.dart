import 'package:app/http/core/i_http_client.dart';
import 'package:app/model/bearer_token.dart';
import 'package:app/model/create_quest_model/create_quest_request_model.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:injectable/injectable.dart';

@singleton
class ApiProvider {
  final IHttpClient _httpClient;

  ApiProvider(this._httpClient);
}

extension LoginService on ApiProvider {
  Future<String> login({
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
    return bearerToken.refresh;
  }

  Future<String> register({
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
    return bearerToken.refresh;
  }

  Future<String> refreshToken(String refreshToken) async {
    _httpClient.accessToken = refreshToken;
    final responseData = await _httpClient.post(
      query: '/v1/auth/refresh-tokens',
    );
    BearerToken bearerToken = BearerToken.fromJson(
      responseData,
    );
    _httpClient.accessToken = bearerToken.access;
    return bearerToken.refresh;
  }
}

extension QuestService on ApiProvider {
  Future<void> createQuest({
    required CreateQuestRequestModel quest,
  }) async {
    final responseData = await _httpClient.post(
      query: '/v1/quest/create',
      data: quest.toJson(),
    );
  }

  Future<dynamic> getEmployerQuests(
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
    try {
      // final responseData = 
      await _httpClient.get(
        query: '/v1/employer/$userId/quests',
        queryParameters: {
          // "offset": offset,
          // "limit": limit,
          // "q": searchWord,
          // if (priority == -1) "priority": priority,
          // if (status == -1) "status": status,
          // if (sort != null) "sort": sort,
          "userId": userId,
          "invited": invited,
          "performing": performing,
          "starred": starred,
        },
      );
      return "responseData";
    } catch (e) {
      print("Tag_WK Error $e");
      return "Error";
    }
  }

  Future<List<BaseQuestResponse>> getQuests({
    int limit = 10,
    int offset = 0,
    String? searchWord,
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
        //"offset": offset,
        //"limit": limit,
        //"q": searchWord,
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
    final response = await _httpClient.post(
      query: '/v1/auth/confirm-email',
      data: {
        "confirmCode": code,
      },
    );
  }
}
