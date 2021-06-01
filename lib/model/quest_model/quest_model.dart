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

  //Map<String, dynamic> toJson() => _$QuestModelToJson(this);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> questData = new Map<String, dynamic>();
    questData['category'] = this.category;
    questData['priority'] = this.priority;
    questData['location'] = this.location;
    questData['title'] = this.title;
    questData['description'] = this.description;
    questData['price'] = this.price;
    questData['adType'] = this.adType;
    return questData;
  }

}

class Location {
  double longitude;
  double latitude;

  Location({required this.longitude, required this.latitude,});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(longitude: json['longitude'], latitude: json['latitude'],);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> locationData = new Map<String, dynamic>();
    locationData['longitude'] = this.longitude;
    locationData['latitude'] = this.latitude;
    return locationData;
  }
}