class Invited {
  Invited({
    required this.id,
    required this.status,
  });

  String id;
  int status;

  factory Invited.fromJson(Map<String, dynamic> json) => Invited(
        id: json["id"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
      };
}
