import 'package:app/model/chat_model/chat_member_data.dart';
import 'package:app/model/profile_response/profile_me_response.dart';

class Member {
  Member({
    required this.id,
    required this.chatId,
    required this.userId,
    required this.adminId,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.chatMemberDeletionData,
    required this.user,
    required this.chatMemberData,
  });

  String id;
  String chatId;
  String? userId;
  String? adminId;
  String type;
  int status;
  DateTime createdAt;
  DateTime? updatedAt;
  dynamic chatMemberDeletionData;
  ProfileMeResponse? user;
  ChatMemberData? chatMemberData;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json["id"],
        chatId: json["chatId"],
        userId: json["userId"],
        adminId: json["adminId"],
        type: json["type"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        chatMemberDeletionData: json["chatMemberDeletionData"],
        user: json["user"] == null
            ? null
            : ProfileMeResponse.fromJson(json["user"]),
        chatMemberData: json["chatMemberData"] == null
            ? null
            : ChatMemberData.fromJson(json["chatMemberData"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "chatId": chatId,
        "userId": userId,
        "adminId": adminId,
        "type": type,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "chatMemberDeletionData": chatMemberDeletionData,
      };
}
