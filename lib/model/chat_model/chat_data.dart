import 'package:app/model/chat_model/message_model.dart';

class ChatData {
  ChatData({
    required this.chatId,
    required this.lastMessageId,
    required this.createdAt,
    required this.lastMessage,
  });

  String chatId;
  String lastMessageId;
  DateTime createdAt;
  MessageModel? lastMessage;

  factory ChatData.fromJson(Map<String, dynamic> json) => ChatData(
        chatId: json["chatId"],
        lastMessageId: json["lastMessageId"],
        createdAt: DateTime.parse(json["createdAt"]),
        lastMessage: json["lastMessage"] == null
            ? null
            : MessageModel.fromJson(json["lastMessage"]),
      );

  Map<String, dynamic> toJson() => {
        "chatId": chatId,
        "lastMessageId": lastMessageId,
        "createdAt": createdAt.toIso8601String(),
        "lastMessage": lastMessage!.toJson(),
      };
}
