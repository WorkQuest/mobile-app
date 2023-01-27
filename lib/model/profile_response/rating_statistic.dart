class RatingStatistic {
  RatingStatistic({
    required this.id,
    required this.userId,
    required this.reviewCount,
    required this.averageMark,
  });

  String id;
  String userId;
  int reviewCount;
  double averageMark;

  factory RatingStatistic.fromJson(Map<String, dynamic> json) =>
      RatingStatistic(
        id: json["id"],
        userId: json["userId"],
        reviewCount: json["reviewCount"],
        averageMark: (json["averageMark"] ?? 0.0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "reviewCount": reviewCount,
        "averageMark": averageMark,
      };
}
