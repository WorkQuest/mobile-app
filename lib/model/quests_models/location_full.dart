class LocationFull {
  LocationFull({
    required this.locationCode,
    required this.locationPlaceName,
  });

  LocationCode locationCode;
  String locationPlaceName;

  LocationFull.clone(LocationFull object)
      : this(
            locationCode: object.locationCode,
            locationPlaceName: object.locationPlaceName);

  factory LocationFull.fromJson(Map<String, dynamic> json) {
    return LocationFull(
      locationCode: LocationCode.fromJson(json["location"]),
      locationPlaceName: json["locationPlaceName"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "location": locationCode,
        "locationPlaceName": locationPlaceName,
      };
}

class LocationCode {
  LocationCode({
    required this.longitude,
    required this.latitude,
  });

  double longitude;
  double latitude;

  LocationCode.clone(LocationCode object)
      : this(longitude: object.longitude, latitude: object.latitude);

  factory LocationCode.fromJson(Map<String, dynamic> json) {
    return LocationCode(
      latitude: json["latitude"] == 0 ? 0.0 : json["latitude"],
      longitude: json["longitude"] == 0 ? 0.0 : json["longitude"],
    );
  }

  Map<String, double> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}
