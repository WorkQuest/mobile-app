class Media {
  String id;
  String url;
  TypeMedia type;

  Media({required this.id, required this.url, required this.type});

  factory Media.fromJson(Map<String, dynamic>? json) => Media(
      id: json?['id'] ?? "",
      url: json?['url'] ?? "",
      type: (json?['contentType'] ?? "") == "video/mp4" ||
              (json?['contentType'] ?? "") == "video/mov"
          ? TypeMedia.Video
          : (json?['contentType'] ?? "") == "application/pdf"
              ? TypeMedia.Pdf
              : (json?['contentType'] ?? "") == "application/msword"
                  ? TypeMedia.Doc
                  : TypeMedia.Image);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> locationData = new Map<String, dynamic>();
    locationData['id'] = this.id;
    locationData['url'] = this.url;
    return locationData;
  }
}

enum TypeMedia { Image, Video, Pdf, Doc }
