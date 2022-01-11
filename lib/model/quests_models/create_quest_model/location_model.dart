class LocationCode {
  double longitude;
  double latitude;

  LocationCode({
    required this.longitude,
    required this.latitude,
  });

  factory LocationCode.fromJson(Map<String, dynamic> json) => LocationCode(
        longitude: json['longitude'] == 0 ? 0.0 : json['longitude'],
        latitude: json['latitude'] == 0 ? 0.0 : json['latitude'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> locationData = new Map<String, dynamic>();
    locationData['longitude'] = this.longitude;
    locationData['latitude'] = this.latitude;
    return locationData;
  }
}
