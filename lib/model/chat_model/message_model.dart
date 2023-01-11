import 'package:app/model/chat_model/info_message.dart';
import 'package:app/model/chat_model/star.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/quests_models/media_model.dart';

class MessageModel {
  MessageModel({
    required this.id,
    required this.number,
    required this.chatId,
    required this.senderUserId,
    required this.senderStatus,
    required this.type,
    required this.text,
    required this.createdAt,
    required this.medias,
    required this.sender,
    required this.infoMessage,
    required this.star,
  });

  String id;
  int number;
  String chatId;
  String senderUserId;
  String senderStatus;
  String type;
  String? text;
  DateTime createdAt;
  List<Media> medias;
  ProfileMeResponse? sender;
  InfoMessage? infoMessage;
  Star? star;

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json["id"],
        number: json["number"]??0,
        chatId: json["chatId"],
        senderUserId: json["senderUserId"],
        senderStatus: json["senderStatus"],
        type: json["type"],
        text: json["text"] == null ? null : json["text"],
        createdAt: DateTime.parse(json["createdAt"]),
        medias: (json["medias"] as List<dynamic>)
            .map((e) => Media.fromJson(e as Map<String, dynamic>))
            .toList(),
        sender: ProfileMeResponse.fromJson(json["sender"]),
        infoMessage: json["infoMessage"] == null
            ? null
            : InfoMessage.fromJson(json["infoMessage"]),
        star: json["star"] == null ? null : Star.fromJson(json["star"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "number": number,
        "chatId": chatId,
        "senderUserId": senderUserId,
        "senderStatus": senderStatus,
        "type": type,
        "text": text,
        "createdAt": createdAt,
        "sender": sender == null ? null : sender!.toJson(),
        "infoMessage": infoMessage,
        "star": star,
      };
}

enum MessageStatus { None, Wait, Send, Error }
