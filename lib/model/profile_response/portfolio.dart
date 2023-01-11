import 'package:app/model/quests_models/media_model.dart';

class PortfolioModel {
  PortfolioModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.medias,
    required this.user,
  });

  String id;
  String userId;
  String title;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  List<Media> medias;
  User user;

  factory PortfolioModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      PortfolioModel(
        id: json["id"],
        userId: json["userId"],
        title: json["title"] ?? "No title",
        description: json["description"] ?? "No title",
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        medias: json["medias"] == null
            ? []
            : List<Media>.from(json["medias"].map((x) => Media.fromJson(x))),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "title": title,
        "description": description,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "medias": List<dynamic>.from(medias.map((x) => x.toJson())),
        "user": user.toJson(),
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
  Media avatar;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        avatar: Media.fromJson(
          json["avatar"] ??
              {
                "id": "",
                "url":
                    "https://workquest-cdn.fra1.digitaloceanspaces.com/sUYNZfZJvHr8fyVcrRroVo8PpzA5RbTghdnP0yEcJuIhTW26A5vlCYG8mZXs",
                "contentType": "",
              },
        ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "avatar": avatar.toJson(),
      };
}
