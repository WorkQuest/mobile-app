import 'package:app/model/chat_model/quest.dart';

class QuestChat {
  QuestChat({
    required this.id,
    required this.employerId,
    required this.workerId,
    required this.disputeAdminId,
    required this.questId,
    required this.responseId,
    required this.chatId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.quest,
  });

  String? id;
  String? employerId;
  String? workerId;
  String? disputeAdminId;
  String? questId;
  String? responseId;
  String? chatId;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  Quest? quest;

  factory QuestChat.fromJson(Map<String, dynamic> json) => QuestChat(
        id: json["id"],
        employerId: json["employerId"],
        workerId: json["workerId"],
        disputeAdminId: json["disputeAdminId"],
        questId: json["questId"],
        responseId: json["responseId"],
        chatId: json["chatId"],
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        quest: json["quest"] == null ? null : Quest.fromJson(json["quest"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "employerId": employerId,
        "workerId": workerId,
        "disputeAdminId": disputeAdminId,
        "questId": questId,
        "responseId": responseId,
        "chatId": chatId,
        "status": status,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "quest": quest == null ? null : quest!.toJson(),
      };
}
