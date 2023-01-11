class Invited {
  Invited({
    required this.id,
    required this.workerId,
    required this.questId,
    required this.status,
    required this.type,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String workerId;
  String questId;
  int status;
  int type;
  String message;
  DateTime createdAt;
  DateTime updatedAt;

  factory Invited.fromJson(Map<String, dynamic> json) => Invited(
    id: json["id"],
    workerId: json["workerId"],
    questId: json["questId"],
    status: json["status"],
    type: json["type"],
    message: json["message"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "workerId": workerId,
    "questId": questId,
    "status": status,
    "type": type,
    "message": message,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
