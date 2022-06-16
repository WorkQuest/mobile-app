import 'package:app/enums.dart';
import 'package:app/model/chat_model/chat_data.dart';
import 'package:app/model/chat_model/group_chat.dart';
import 'package:app/model/chat_model/member.dart';
import 'package:app/model/chat_model/quest_chat.dart';
import 'package:app/model/chat_model/star.dart';

class ChatModel {
  ChatModel({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.meMember,
    required this.star,
    required this.chatData,
    required this.members,
    required this.questChat,
    required this.groupChat,
  });

  String id;
  TypeChat type;
  DateTime createdAt;
  DateTime updatedAt;
  Member? meMember;
  Star? star;
  ChatData chatData;
  List<Member> members;
  QuestChat? questChat;
  GroupChat? groupChat;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json["id"],
        type: (String type) {
          switch (type) {
            case "Quest":
              if (json["questChat"]["status"] == 0)
                return TypeChat.active;
              else
                return TypeChat.completed;
            case "Private":
              return TypeChat.privates;
            case "Group":
              return TypeChat.group;
            default:
              return TypeChat.favourites;
          }
        }(json["type"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        meMember:
            json["meMember"] == null ? null : Member.fromJson(json["meMember"]),
        star: json["star"] == null ? null : Star.fromJson(json["star"]),
        chatData: ChatData.fromJson(json["chatData"]),
        members:
            List<Member>.from(json["members"].map((x) => Member.fromJson(x))),
        questChat: json["questChat"] == null
            ? null
            : QuestChat.fromJson(json["questChat"]),
        groupChat: json["groupChat"] == null
            ? null
            : GroupChat.fromJson(json["groupChat"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "meMember": meMember!.toJson(),
        "star": star,
        "chatData": chatData.toJson(),
        "members": List<dynamic>.from(members.map((x) => x.toJson())),
        "questChat": questChat,
        "groupChat": groupChat,
      };
}
