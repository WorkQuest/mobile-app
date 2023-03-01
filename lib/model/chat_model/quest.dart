import 'package:app/model/quests_models/open_dispute.dart';

class Quest {
  Quest({
    required this.id,
    required this.title,
    required this.openDispute,
  });

  String id;
  String? title;
  OpenDispute? openDispute;

  factory Quest.fromJson(Map<String, dynamic> json) => Quest(
        id: json["id"],
        title: json["title"],
        openDispute: json["openDispute"] == null
            ? null
            : OpenDispute.fromJson(json["openDispute"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "openDispute": openDispute?.toJson(),
      };
}
