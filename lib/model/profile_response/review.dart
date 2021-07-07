class Review {
  Review({
    required this.reviewId,
    required this.questId,
    required this.fromUserId,
    required this.toUserId,
    required this.message,
    required this.mark,
    required this.createdAt,
    required this.updatedAt,
  });

  String reviewId;
  String questId;
  String fromUserId;
  String toUserId;
  String message;
  int mark;
  DateTime createdAt;
  DateTime updatedAt;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    reviewId: json["reviewId"],
    questId: json["questId"],
    fromUserId: json["fromUserId"],
    toUserId: json["toUserId"],
    message: json["message"],
    mark: json["mark"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "reviewId": reviewId,
    "questId": questId,
    "fromUserId": fromUserId,
    "toUserId": toUserId,
    "message": message,
    "mark": mark,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
