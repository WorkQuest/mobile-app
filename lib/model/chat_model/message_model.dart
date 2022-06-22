import 'package:app/model/chat_model/info_message.dart';
import 'package:app/model/chat_model/member.dart';
import 'package:app/model/chat_model/star.dart';
import 'package:app/model/media_model.dart';

class MessageModel {
  MessageModel({
    required this.id,
    required this.number,
    required this.chatId,
    required this.senderMemberId,
    required this.senderStatus,
    required this.type,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
    required this.star,
    required this.sender,
    required this.medias,
    required this.infoMessage,
  });

  String id;
  int? number;
  String? chatId;
  String? senderMemberId;
  String? senderStatus;
  String? type;
  String? text;
  DateTime? createdAt;
  DateTime? updatedAt;
  Star? star;
  Member? sender;
  List<Media>? medias;
  InfoMessage? infoMessage;

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json["id"],
        number: json["number"],
        chatId: json["chatId"],
        senderMemberId: json["senderMemberId"],
        senderStatus: json["senderStatus"],
        type: json["type"],
        text: json["text"] == null ? null : json["text"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        star: json["star"] == null ? null : Star.fromJson(json["star"]),
        sender: json["sender"] == null ? null : Member.fromJson(json["sender"]),
        medias: json["medias"] == null
            ? []
            : (json["medias"] as List<dynamic>)
                .map((e) => Media.fromJson(e as Map<String, dynamic>))
                .toList(),
        infoMessage: json["infoMessage"] == null
            ? null
            : InfoMessage.fromJson(json["infoMessage"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "number": number,
        "chatId": chatId,
        "senderMemberId": senderMemberId,
        "senderStatus": senderStatus,
        "type": type,
        "text": text == null ? null : text,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "star": star,
        "sender": sender!.toJson(),
        "medias": List<dynamic>.from(medias!.map((x) => x)),
        "infoMessage": infoMessage == null ? null : infoMessage,
      };
}
