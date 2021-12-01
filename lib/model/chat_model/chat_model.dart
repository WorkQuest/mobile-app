import 'package:app/model/chat_model/me_member.dart';
import 'package:app/model/chat_model/star.dart';
import 'package:app/model/profile_response/profile_me_response.dart';

import 'message_model.dart';

class ChatModel {
  ChatModel({
    required this.id,
    required this.ownerUserId,
    required this.lastMessageId,
    required this.lastMessageDate,
    required this.name,
    required this.type,
    required this.owner,
    required this.lastMessage,
    required this.meMember,
    required this.userMembers,
    required this.star,
  });

  String id;
  String? ownerUserId;
  String lastMessageId;
  DateTime lastMessageDate;
  String? name;
  String type;
  ProfileMeResponse? owner;
  MessageModel lastMessage;
  MeMember? meMember;
  List<ProfileMeResponse> userMembers;
  Star? star;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json["id"],
        ownerUserId: json["ownerUserId"] == null ? null : json["ownerUserId"],
        lastMessageId: json["lastMessageId"],
        lastMessageDate: DateTime.parse(json["lastMessageDate"]),
        name: json["name"] == null ? null : json["name"],
        type: json["type"],
        owner: json["owner"] == null
            ? null
            : ProfileMeResponse.fromJson(json["owner"]),
        lastMessage: MessageModel.fromJson(json["lastMessage"]),
        meMember: json["meMember"] == null
            ? null
            : MeMember.fromJson(json["meMember"]),
        userMembers: (json["userMembers"] as List<dynamic>)
            .map((e) => ProfileMeResponse.fromJson(e as Map<String, dynamic>))
            .toList(),
        star: json["star"] == null ? null : Star.fromJson(json["star"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ownerUserId": ownerUserId,
        "lastMessageId": lastMessageId,
        "lastMessageDate": lastMessageDate.toIso8601String(),
        "name": name,
        "type": type,
        "owner": owner == null ? null : owner!.toJson(),
        "lastMessage": lastMessage.toJson(),
        // "meMember": meMember.toJson(),
        //"userMembers": userMembers.toJson(),
        "star": star,
      };
}
