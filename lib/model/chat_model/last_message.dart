import 'package:app/model/chat_model/owner.dart';
import 'package:app/model/quests_models/create_quest_model/media_model.dart';

class LastMessage {
  LastMessage({
    required this.id,
    required this.number,
    required this.senderUserId,
    required this.chatId,
    required this.text,
    required this.type,
    required this.senderStatus,
    required this.sender,
    required this.medias,
  });

  String id;
  int number;
  String senderUserId;
  String chatId;
  String text;
  String type;
  String senderStatus;
  Owner? sender;
  List<Media> medias;

  factory LastMessage.fromJson(Map<String, dynamic> json) => LastMessage(
        id: json["id"],
        number: json["number"],
        senderUserId: json["senderUserId"],
        chatId: json["chatId"],
        text: json["text"],
        type: json["type"],
        senderStatus: json["senderStatus"],
        sender: Owner.fromJson(json["sender"]),
        medias: (json["medias"] as List<dynamic>)
            .map((e) => Media.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "number": number,
        "senderUserId": senderUserId,
        "chatId": chatId,
        "text": text,
        "type": type,
        "senderStatus": senderStatus,
        // "sender": sender.toJson(),
        "medias": List<dynamic>.from(medias.map((x) => x)),
      };
}
