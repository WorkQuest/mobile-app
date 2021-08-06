class Location {
  double longitude;
  double latitude;

  Location({
    required this.longitude,
    required this.latitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        longitude: json['longitude'] == 0 ? 0.0 : json['longitude'],
        latitude: json['latitude'] == 0 ? 0.0 : json['longitude'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> locationData = new Map<String, dynamic>();
    locationData['longitude'] = this.longitude;
    locationData['latitude'] = this.latitude;
    return locationData;
  }
}
