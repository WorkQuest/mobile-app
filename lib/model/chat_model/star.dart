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
        id: json["id"] == null ? null : json["id"],
        userId: json["userId"] == null ? null : json["userId"],
        chatId: json["chatId"] == null ? null : json["chatId"],
        adminId: json["adminId"] == null ? null : json["adminId"],
        messageId: json["messageId"] == null ? null : json["messageId"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "chatId": chatId,
        "adminId": adminId,
        "messageId": messageId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
