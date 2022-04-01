
import 'location_full.dart';

class CreateQuestRequestModel  {
  int priority;
  LocationFull location;
  String title;
  String description;
  // String locationPlaceName;
  String workplace;
  String price;
  List media;
  List<String> specializationKeys;
  String employment;

  CreateQuestRequestModel({
    required this.location,
    required this.priority,
    required this.employment,
    required this.specializationKeys,
    // required this.locationPlaceName,
    required this.workplace,
    required this.title,
    required this.media,
    required this.description,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> questData = new Map<String, dynamic>();
    questData['priority'] = this.priority;
    questData['workplace'] = this.workplace;
    // questData['locationPlaceName'] = this.locationPlaceName;
    questData['locationFull'] = this.location.toJson();
    questData['title'] = this.title;
    questData['specializationKeys'] = this.specializationKeys;
    questData['medias'] = this.media;
    questData['description'] = this.description;
    questData['price'] = this.price;
    questData['employment'] = this.employment;
    return questData;
  }
}
