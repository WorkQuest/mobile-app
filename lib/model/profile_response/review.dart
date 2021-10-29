import 'from_user.dart';

class Review {
  Review({
    required this.id,
    required this.questId,
    required this.fromUserId,
    required this.toUserId,
    required this.message,
    required this.mark,
    required this.createdAt,
    required this.fromUser,
    //required this.updatedAt,
  });

  String id;
  String questId;
  String fromUserId;
  String toUserId;
  String message;
  int mark;
  DateTime createdAt;
  FromUser fromUser;


  //DateTime updatedAt;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        questId: json["questId"],
        fromUserId: json["fromUserId"],
        toUserId: json["toUserId"],
        message: json["message"],
        mark: json["mark"],
        createdAt: DateTime.parse(json["createdAt"]),
        fromUser: FromUser.fromJson(json["fromUser"]),
        //updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "questId": questId,
        "fromUserId": fromUserId,
        "toUserId": toUserId,
        "message": message,
        "mark": mark,
        "createdAt": createdAt.toIso8601String(),
        //"updatedAt": updatedAt.toIso8601String(),
      };
}
