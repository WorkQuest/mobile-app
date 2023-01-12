class Education {
  Education({
    required this.from,
    required this.to,
    required this.place,
  });

  String? from;
  String? to;
  String? place;

  factory Education.fromJson(Map<String, dynamic> json) => Education(
        from: json["from"],
        to: json["to"],
        place: json["place"],
      );

  Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
        "place": place,
      };
}

class WorkExperience {
  WorkExperience({
    required this.from,
    required this.to,
    required this.place,
  });

  String? from;
  String? to;
  String? place;

  factory WorkExperience.fromJson(Map<String, dynamic> json) => WorkExperience(
        from: json["from"],
        to: json["to"],
        place: json["place"],
      );

  Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
        "place": place,
      };
}
