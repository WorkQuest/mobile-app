import 'package:app/model/chat_model/message_model.dart';
import 'package:app/model/profile_response/avatar.dart';
import 'package:mobx/mobx.dart';

class ChatModel {
  String id;
  String name;
  int type;
  ChatUserModel otherMember;
  MessageModel? lastMessage;
  DateTime? lastMessageDate;
  ObservableList<MessageModel>? messages;
  ChatModel({
    required this.id,
    required this.name,
    required this.type,
    required this.otherMember,
    required this.lastMessage,
    required this.lastMessageDate,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json["id"],
        name: json["name"] ?? "",
        type: json["type"],
        lastMessage: json["lastMessage"] == null
            ? null
            : MessageModel.fromJson(json["lastMessage"], ""),
        otherMember: ChatUserModel.fromJson(json["members"][0]),
        lastMessageDate: json["lastMessageDate"] == null
            ? null
            : DateTime.parse(json['lastMessageDate']),
      );
}

class ChatUserModel {
  String id;
  String firstName;
  String lastName;
  String avatarId;
  Avatar avatar;
  ChatUserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatarId,
    required this.avatar,
  });
  factory ChatUserModel.fromJson(Map<String, dynamic> json) => ChatUserModel(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        avatarId: json["avatarId"] ??
            "https://decimalchain.com/_nuxt/img/image.b668d57.jpg",
        avatar: Avatar.fromJson(json["avatar"]),
      );
}
