class Media {
  String id;
  String url;

  Media({
    required this.id,
    required this.url,
  });

  factory Media.fromJson(Map<String, dynamic>? json) => Media(
        id: json?['id'] ?? "",
        url: json?['url'] ?? "",
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> locationData = new Map<String, dynamic>();
    locationData['id'] = this.id;
    locationData['url'] = this.url;
    return locationData;
  }
}
