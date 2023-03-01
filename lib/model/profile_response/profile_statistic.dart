import 'package:app/model/profile_response/rating_statistic.dart';

class ProfileStatistic {
  ProfileStatistic({
    required this.chatsStatistic,
    required this.questsStatistic,
    required this.ratingStatistic,
  });

  ChatsStatistic chatsStatistic;
  QuestsStatistic questsStatistic;
  RatingStatistic ratingStatistic;

  factory ProfileStatistic.fromJson(Map<String, dynamic> json) =>
      ProfileStatistic(
        chatsStatistic: ChatsStatistic.fromJson(json["chatsStatistic"]),
        questsStatistic: QuestsStatistic.fromJson(json["questsStatistic"]),
        ratingStatistic: RatingStatistic.fromJson(json["ratingStatistic"]),
      );

  Map<String, dynamic> toJson() => {
        "chatsStatistic": chatsStatistic.toJson(),
        "questsStatistic": questsStatistic.toJson(),
        "ratingStatistic": ratingStatistic.toJson(),
      };
}

class ChatsStatistic {
  ChatsStatistic({
    required this.id,
    required this.userId,
    required this.unreadCountChats,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String userId;
  int unreadCountChats;
  DateTime createdAt;
  DateTime updatedAt;

  factory ChatsStatistic.fromJson(Map<String, dynamic> json) => ChatsStatistic(
        id: json["id"],
        userId: json["userId"],
        unreadCountChats: json["unreadCountChats"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "unreadCountChats": unreadCountChats,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class QuestsStatistic {
  QuestsStatistic({
    required this.id,
    required this.userId,
    required this.completed,
    required this.opened,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String userId;
  int completed;
  int opened;
  DateTime createdAt;
  DateTime updatedAt;

  factory QuestsStatistic.fromJson(Map<String, dynamic> json) =>
      QuestsStatistic(
        id: json["id"],
        userId: json["userId"],
        completed: json["completed"],
        opened: json["opened"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "completed": completed,
        "opened": opened,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}