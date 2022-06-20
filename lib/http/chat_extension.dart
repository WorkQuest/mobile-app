import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/model/chat_model/message_model.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'api_provider.dart';

///Chat Service
extension ChatsService on ApiProvider {
  Future<List<ChatModel>> getChats({
    required int offset,
    required String query,
    int limit = 10,
    String? type,
    bool? starred,
    int? questChatStatus,
  }) async {
    try {
      final responseData = await httpClient.get(
        query: '/v1/user/me/chats',
        queryParameters: {
          "offset": offset,
          "limit": limit,
          if (starred != null) "starred": starred,
          if (query.isNotEmpty) "q": query,
          if (type != null) "type": type,
          if (questChatStatus != null) "questChatStatus": questChatStatus,
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

  Future<ChatModel> getChat({
    required String chatId,
  }) async {
    try {
      final responseData = await httpClient.get(
        query: '/v1/user/me/chat/$chatId',
      );
      return ChatModel.fromJson(responseData);
    } catch (e, stack) {
      print("ERROR $e");
      print("ERROR $stack");
      final responseData = await httpClient.get(
        query: '/v1/user/me/chat/$chatId',
      );
      return ChatModel.fromJson(responseData);
    }
  }

  Future<List<ProfileMeResponse>> getUsersForChat({
    String? excludeMembersChatId,
  }) async {
    try {
      final responseData = await httpClient.get(
        query: '/v1/user/me/chat/members/users-by-chats',
        queryParameters: {
          if (excludeMembersChatId != null)
            "excludeMembersChatId": excludeMembersChatId,
        },
      );
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

  Future<List<MessageModel>> getStarredMessage({
    required int offset,
  }) async {
    try {
      final responseData = await httpClient.get(
        query: '/v1/user/me/chat/messages/star',
        queryParameters: {
          "offset": offset,
        },
      );
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
        "userIds": usersId,
      },
    );
    return responseData;
  }

  Future<Map<String, dynamic>> sendMessageToUser({
    required String userId,
    required String text,
    required List<String> medias,
  }) async {
    final responseData = await httpClient.post(
      query: '/v1/user/$userId/send-message',
      data: {
        "text": text,
        "mediaIds": medias,
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
    int limit = 20,
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
