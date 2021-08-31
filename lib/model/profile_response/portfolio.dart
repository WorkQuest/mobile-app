class Portfolio {
  Portfolio({
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

  factory Portfolio.fromJson(
    Map<String, dynamic> json,
  ) =>
      Portfolio(
        id: json["id"],
        userId: json["userId"],
        title: json["title"] ?? "No title",
        description: json["description"] ?? "No title" ,
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        medias:json["medias"]==null?[]: List<Media>.from(json["medias"].map((x) => Media.fromJson(x))),
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

class Media {
  Media({
    required this.id,
    required this.url,
    required this.contentType,
  });

  String id;
  String url;
  String contentType;

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        id: json["id"],
        url: json["url"],
        contentType: json["contentType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "contentType": contentType,
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
        avatar: Media.fromJson(json["avatar"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "avatar": avatar.toJson(),
      };
}
