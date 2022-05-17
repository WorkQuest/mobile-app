import 'package:app/model/quests_models/base_quest_response.dart';

class QuestChat {
  QuestChat({
    required this.id,
    required this.employerId,
    required this.workerId,
    required this.questId,
    required this.responseId,
    required this.chatId,
    required this.status,
    required this.quest,
  });

  String? id;
  String? employerId;
  String? workerId;
  String? questId;
  String? responseId;
  String? chatId;
  int? status;
  BaseQuestResponse? quest;

  factory QuestChat.fromJson(Map<String, dynamic> json) => QuestChat(
        id: json["id"],
        employerId: json["employerId"],
        workerId: json["workerId"],
        questId: json["questId"],
        responseId: json["responseId"],
        chatId: json["chatId"],
        status: json["status"],
        quest: json["quest"] == null
            ? null
            : BaseQuestResponse.fromJson(
                json["quest"],
              ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "employerId": employerId,
        "workerId": workerId,
        "questId": questId,
        "responseId": responseId,
        "chatId": chatId,
        "status": status,
        "quest": quest!.toJson(),
      };
}
