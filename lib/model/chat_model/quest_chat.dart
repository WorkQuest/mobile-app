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
  QuestChatInfo? quest;

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
            : QuestChatInfo.fromJson(json["quest"]),
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

class QuestChatInfo{
  QuestChatInfo({
    required this.id,
    required this.status,
  });

  String? id;
  int? status;

  factory QuestChatInfo.fromJson(Map<String, dynamic> json) => QuestChatInfo(
    id: json["id"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
  };
}


