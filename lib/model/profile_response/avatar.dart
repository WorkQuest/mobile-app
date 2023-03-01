class Avatar {
  Avatar({
    required this.id,
    required this.url,
  });

  String? id;
  String? url;

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
      id: json["id"],
      url: json["url"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
      };
}
