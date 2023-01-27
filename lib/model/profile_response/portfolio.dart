import 'package:app/model/media_model.dart';

class PortfolioModel {
  PortfolioModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.medias,
  });

  String id;
  String userId;
  String title;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  List<Media> medias;

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
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "title": title,
        "description": description,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "medias": List<dynamic>.from(medias.map((x) => x.toJson())),
      };
}
