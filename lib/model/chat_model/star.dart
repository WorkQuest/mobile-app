class Star {
  Star({
    required this.id,
    required this.userId,
    required this.messageId,
    required this.createdAt,
  });

  String? id;
  String userId;
  String? messageId;
  DateTime createdAt;

  factory Star.fromJson(Map<String, dynamic> json) => Star(
        id: json["id"],
        userId: json["userId"],
        messageId: json["messageId"],
        createdAt: DateTime.parse(json["createdAt"]),
      );
}
