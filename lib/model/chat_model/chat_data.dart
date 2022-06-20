import 'package:app/model/chat_model/message_model.dart';

class ChatData {
  ChatData({
    required this.id,
    required this.chatId,
    required this.lastMessageId,
    required this.createdAt,
    required this.updatedAt,
    required this.lastMessage,
  });

  String id;
  String chatId;
  String lastMessageId;
  DateTime createdAt;
  DateTime updatedAt;
  MessageModel lastMessage;

  factory ChatData.fromJson(Map<String, dynamic> json) => ChatData(
        id: json["id"],
        chatId: json["chatId"],
        lastMessageId: json["lastMessageId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        lastMessage: MessageModel.fromJson(json["lastMessage"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "chatId": chatId,
        "lastMessageId": lastMessageId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "lastMessage": lastMessage.toJson(),
      };
}
