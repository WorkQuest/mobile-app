import 'package:app/model/chat_model/chat_member_data.dart';
import 'package:app/model/chat_model/deletion_data.dart';
import 'package:app/model/profile_response/profile_me_response.dart';

class Member {
  Member({
    required this.id,
    required this.chatId,
    required this.userId,
    required this.adminId,
    required this.type,
    required this.status,
    required this.updatedAt,
    required this.chatMemberDeletionData,
    required this.user,
    required this.admin,
    required this.chatMemberData,
    required this.deletionData,
  });

  String id;
  String? chatId;
  String? userId;
  String? adminId;
  String? type;
  int? status;
  DateTime? updatedAt;
  dynamic chatMemberDeletionData;
  ProfileMeResponse? user;
  ProfileMeResponse? admin;
  ChatMemberData? chatMemberData;
  DeletionData? deletionData;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json["id"],
        chatId: json["chatId"],
        userId: json["userId"],
        adminId: json["adminId"],
        type: json["type"],
        status: json["status"],
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        chatMemberDeletionData: json["chatMemberDeletionData"],
        user: json["user"] == null
            ? null
            : ProfileMeResponse.fromJson(json["user"]),
        admin: json["admin"] == null
            ? null
            : ProfileMeResponse.fromJson(json["admin"]),
        chatMemberData: json["chatMemberData"] == null
            ? null
            : ChatMemberData.fromJson(json["chatMemberData"]),
        deletionData: json["deletionData"] == null
            ? null
            : DeletionData.fromJson(json["deletionData"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "chatId": chatId,
        "userId": userId,
        "adminId": adminId,
        "type": type,
        "status": status,
        "updatedAt": updatedAt!.toIso8601String(),
        "chatMemberDeletionData": chatMemberDeletionData,
        "deletionData": deletionData,
      };
}
