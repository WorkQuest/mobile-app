import 'package:app/model/profile_response/avatar.dart';

class Notifications {
  Notifications({
    required this.count,
    required this.unreadCount,
    required this.notifications,
  });

  int count;
  int unreadCount;
  List<NotificationElement> notifications;

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
        count: json["count"],
        unreadCount: json["unreadCount"],
        notifications: List<NotificationElement>.from(
            json["notifications"].map((x) => NotificationElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "unreadCount": unreadCount,
        "notifications":
            List<dynamic>.from(notifications.map((x) => x.toJson())),
      };
}

class NotificationElement {
  NotificationElement({
    required this.id,
    required this.queueName,
    required this.notification,
    required this.seen,
    required this.createdAt,
  });

  String id;
  String queueName;
  NotificationNotification notification;
  bool seen;
  DateTime createdAt;

  factory NotificationElement.fromJson(Map<String, dynamic> json) =>
      NotificationElement(
        id: json["id"],
        queueName: json["queueName"],
        notification: NotificationNotification.fromJson(json["notification"]),
        seen: json["seen"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "queueName": queueName,
        "notification": notification.toJson(),
        "seen": seen,
        "createdAt": createdAt.toIso8601String(),
      };
}

class NotificationNotification {
  NotificationNotification({
    required this.data,
    required this.action,
    required this.recipients,
  });

  Data data;
  String action;
  List<dynamic> recipients;

  factory NotificationNotification.fromJson(Map<String, dynamic> json) =>
      NotificationNotification(
        data: Data.fromJson(json["data"]),
        action: json["action"],
        recipients: List<String>.from(json["recipients"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "action": action,
        "recipients": List<dynamic>.from(recipients.map((x) => x)),
      };
}

class Data {
  Data({
    required this.id,
    required this.title,
    required this.questId,
    required this.user,
  });

  String id;
  String? title;
  String questId;
  User user;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json["quest"] == null
          ? (json["questId"] ?? json["id"])
          : json["quest"]["id"],
      title: json["title"] == null
          ? json["quest"] == null
              ? json["message"] == null
                  ? json["text"]
                  : json["message"]
              : json["quest"]["title"]
          : json["title"],
      questId: json["questId"] ?? "",
      user: json["fromUser"] == null
          ? json["user"] == null
              ? User.fromJson(json["quest"]["user"])
              : User.fromJson(json["user"])
          : User.fromJson(json["fromUser"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "questId": questId,
      };
}

class User {
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  String id;
  String firstName;
  String lastName;
  Avatar? avatar;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        avatar: json["avatar"] == null ? null : Avatar.fromJson(json["avatar"]),
      );
}
