import 'package:app/model/chat_model/member.dart';

class InfoMessage {
  InfoMessage({
    required this.id,
    required this.messageId,
    required this.userId,
    required this.messageAction,
    required this.member,
  });

  String? id;
  String messageId;
  String? userId;
  String messageAction;
  Member? member;

  factory InfoMessage.fromJson(Map<String, dynamic> json) => InfoMessage(
        id: json["json"],
        messageId: json["messageId"],
        userId: json["userId"],
        messageAction: json["messageAction"],
        member: json["member"] == null ? null : Member.fromJson(json["member"]),
      );
}
