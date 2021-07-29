import 'package:app/model/quests_models/create_quest_model/location_model.dart';

class CreateQuestRequestModel {
  String category;
  int priority;
  Location location;
  String title;
  String description;
  String price;
  List media;
  int adType;

  CreateQuestRequestModel({
    required this.category,
    required this.priority,
    required this.location,
    required this.title,
    required this.media,
    required this.description,
    required this.price,
    required this.adType,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> questData = new Map<String, dynamic>();
    questData['category'] = this.category;
    questData['priority'] = this.priority;
    questData['location'] = this.location.toJson();
    questData['title'] = this.title;
    questData['medias'] = this.media;
    questData['description'] = this.description;
    questData['price'] = this.price;
    questData['adType'] = this.adType;
    return questData;
  }
}