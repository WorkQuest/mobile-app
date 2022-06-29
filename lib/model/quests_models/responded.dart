class Responded {
  Responded({
    required this.id,
    required this.workerId,
    required this.questId,
    required this.type,
    required this.status,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String workerId;
  String questId;
  int type;
  int status;
  String? message;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Responded.fromJson(Map<String, dynamic> json) {
    return Responded(
      id: json["id"],
      workerId: json["workerId"],
      questId: json["questId"],
      type: json["type"],
      status: json["status"],
      message: json["message"],
      createdAt:
          json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      updatedAt:
          json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "workerId": workerId,
        "questId": questId,
        "type": type,
        "status": status,
        "message": message,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
      };
}
