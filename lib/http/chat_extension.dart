import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/model/chat_model/message_model.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'api_provider.dart';

///Chat Service
extension ChatsService on ApiProvider {
  Future<List<ChatModel>> getChats({
    required int offset,
    required int limit,
    bool? starred,
  }) async {
    try {
      final responseData = await httpClient.get(
        query: '/v1/user/me/chats',
        queryParameters: {
          "offset": offset,
          "limit": limit,
          if (starred != null) "starred": starred,
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
      final responseData = await httpClient.get(
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
          await httpClient.get(query: '/v1/user/me/chat/messages/star');
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
    final responseData = await httpClient.post(
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
    await httpClient.post(
      query: '/v1/user/me/chat/group/$chatId/add',
      data: {"userIds": userIds},
    );
  }

  Future<void> setMessageStar({
    required String chatId,
    required String messageId,
  }) async {
    await httpClient.post(
      query: '/v1/user/me/chat/$chatId/message/$messageId/star',
    );
  }

  Future<void> setChatStar({
    required String chatId,
  }) async {
    await httpClient.post(
      query: '/v1/user/me/chat/$chatId/star',
    );
  }

  Future<void> removeStarFromMsg({
    required String messageId,
  }) async {
    await httpClient.delete(
      query: '/v1/user/me/chat/message/$messageId/star',
    );
  }

  Future<void> removeStarFromChat({
    required String chatId,
  }) async {
    await httpClient.delete(
      query: '/v1/user/me/chat/$chatId/star',
    );
  }

  Future<void> removeUser({
    required String chatId,
    required String userId,
  }) async {
    await httpClient.delete(
      query: '/v1/user/me/chat/group/$chatId/remove/$userId',
    );
  }

  Future<void> leaveFromChat({
    required String chatId,
  }) async {
    await httpClient.post(
      query: '/v1/user/me/chat/group/$chatId/leave',
    );
  }

  Future<void> setMessageRead({
    required String chatId,
    required String messageId,
  }) async {
    await httpClient.post(
        query: '/v1/read/message/$chatId', data: {"messageId": messageId});
  }

  Future<Map<String, dynamic>> getMessages({
    required String chatId,
    required int offset,
    required int limit,
  }) async {
    final responseData = await httpClient.get(
      query: '/v1/user/me/chat/$chatId/messages',
      queryParameters: {
        "offset": offset,
        "limit": limit,
      },
    );
    return responseData;
  }
}
