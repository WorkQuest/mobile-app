import 'package:freezed_annotation/freezed_annotation.dart';

part 'quest_model.freezed.dart';

part 'quest_model.g.dart';


@freezed
abstract class QuestModel with _$QuestModel {

  const factory QuestModel({
    required String category,
    required int priority,
    required Location location,
    required String title,
    required String description,
    required String price,
    required int adType,
  }) = _QuestModel;

  factory QuestModel.fromJson(Map<String, dynamic> json) =>
      _$QuestModelFromJson(json);

}

class Location {
  double longitude;
  double latitude;

  Location({required this.longitude, required this.latitude,});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(longitude: json['longitude'], latitude: json['latitude'],);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> locationData = new Map<String, double>();
    locationData['longitude'] = this.longitude;
    locationData['latitude'] = this.latitude;
    return locationData;
  }
}