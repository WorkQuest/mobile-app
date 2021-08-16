import 'package:app/model/chat_model/message_model.dart';

class ChatModel {
  String id;
  String name;
  int type;
  Map<String, dynamic> otherMember;
  String imageUrl;
  String? lastMessage;
  DateTime? lastMessageDate;
  List<MessageModel>? messages;
  ChatModel({
    required this.id,
    required this.name,
    required this.type,
    required this.otherMember,
    required this.imageUrl,
    required this.lastMessage,
    required this.lastMessageDate,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json["id"],
        name: json["name"] ?? "TestGroup",
        type: json["type"],
        lastMessage: json["lastMessage"].toString(),
        otherMember: json["otherMember"],
        lastMessageDate: json["lastMessageDate"] == null
            ? null
            : DateTime.parse(json['lastMessageDate']),
        imageUrl: "https://decimalchain.com/_nuxt/img/image.b668d57.jpg",
      );
}
