class Star {
  Star({
    this.id,
    this.userId,
    this.chatId,
    this.adminId,
    this.messageId,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? userId;
  String? chatId;
  String? adminId;
  String? messageId;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Star.fromJson(Map<String, dynamic> json) => Star(
        id: json["id"],
        userId: json["userId"],
        chatId: json["chatId"],
        adminId: json["adminId"],
        messageId: json["messageId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "chatId": chatId,
        "adminId": adminId,
        "messageId": messageId,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
      };
}
