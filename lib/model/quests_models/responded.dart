class Responded {
  Responded({
    required this.workerId,
    required this.status,
  });

  String? workerId;
  int? status;

  factory Responded.fromJson(Map<String, dynamic> json) {
    return Responded(
      workerId: json["workerId"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() => {
        "workerId": workerId,
        "status": status,
      };
}
