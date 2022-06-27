class GroupChat {
  GroupChat({
    required this.id,
    required this.name,
    required this.ownerMemberId,
    required this.chatId,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String name;
  String ownerMemberId;
  String chatId;
  DateTime createdAt;
  DateTime updatedAt;

  factory GroupChat.fromJson(Map<String, dynamic> json) => GroupChat(
        id: json["id"],
        name: json["name"],
        ownerMemberId: json["ownerMemberId"],
        chatId: json["chatId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "ownerMemberId": ownerMemberId,
        "chatId": chatId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
