import 'package:app/model/user_model.dart';

class RespondModel {
  String id;
  String workerId;
  String questId;
  int status;
  int type;
  String message;
  DateTime createdAt;
  User worker;

  RespondModel(
      {required this.id,
      required this.createdAt,
      required this.message,
      required this.questId,
      required this.status,
      required this.type,
      required this.worker,
      required this.workerId});

  factory RespondModel.fromJson(Map<String, dynamic> json) {
    return RespondModel(
      id: json["id"],
      createdAt: DateTime.parse(json["createdAt"]),
      message: json["message"],
      questId: json["questId"],
      status: json["status"],
      type: json["type"],
      worker: User.fromJson(json["worker"]),
      workerId: json["workerId"],
    );
  }
}
