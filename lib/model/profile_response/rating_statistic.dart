class RatingStatistic {
  RatingStatistic({
    required this.id,
    required this.userId,
    required this.status,
    required this.reviewCount,
    required this.averageMark,
  });

  String id;
  String userId;
  int? status;
  int reviewCount;
  double averageMark;

  RatingStatistic.clone(RatingStatistic object)
      : this(
          id: object.id,
          userId: object.userId,
          status: object.status,
          reviewCount: object.reviewCount,
          averageMark: object.averageMark,
        );

  factory RatingStatistic.fromJson(Map<String, dynamic> json) =>
      RatingStatistic(
        id: json["id"],
        userId: json["userId"],
        status: json["status"],
        reviewCount: json["reviewCount"],
        averageMark: (json["averageMark"] ?? 0.0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "status": status,
        "reviewCount": reviewCount,
        "averageMark": averageMark,
      };
}
