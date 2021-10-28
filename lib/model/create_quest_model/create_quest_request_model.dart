import 'package:app/model/quests_models/create_quest_model/location_model.dart';

class CreateQuestRequestModel  {
  String category;
  int priority;
  LocationCode location;
  String title;
  String description;
  String locationPlaceName;
  String workplace;
  String price;
  List media;
  List<String> specializationKeys;
  int adType;
  String employment;

  CreateQuestRequestModel({
    required this.category,
    required this.location,
    required this.priority,
    required this.employment,
    required this.specializationKeys,
    required this.locationPlaceName,
    required this.workplace,
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
    questData['workplace'] = this.workplace;
    questData['locationPlaceName'] = this.locationPlaceName;
    questData['location'] = this.location.toJson();
    questData['title'] = this.title;
    questData['specializationKeys'] = this.specializationKeys;
    questData['medias'] = this.media;
    questData['description'] = this.description;
    questData['price'] = this.price;
    questData['adType'] = this.adType;
    questData['employment'] = this.employment;
    return questData;
  }
}
