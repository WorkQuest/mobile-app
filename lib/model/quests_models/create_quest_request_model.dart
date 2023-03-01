import 'location_full.dart';

class CreateQuestRequestModel {
  String category;
  int priority;
  LocationFull location;
  String? title;
  String? description;

  // String locationPlaceName;
  String workplace;
  String? price;
  List media;
  List<String> specializationKeys;
  String employment;
  String payPeriod;
  int adType;

  CreateQuestRequestModel({
    this.category = '',
    this.adType = 0,
    required this.location,
    required this.priority,
    required this.employment,
    required this.specializationKeys,
    required this.payPeriod,
    // required this.locationPlaceName,
    required this.workplace,
    required this.media,
    this.title,
    this.description,
    this.price,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> questData = new Map<String, dynamic>();
    questData['priority'] = this.priority;
    questData['workplace'] = this.workplace;
    questData['locationFull'] = this.location.toJson();
    questData['payPeriod'] = this.payPeriod;

    // questData['locationPlaceName'] = this.locationPlaceName;
    if (title != null) questData['title'] = this.title;
    if (price != null) questData['price'] = this.price;
    if (description != null) questData['description'] = this.description;
    questData['specializationKeys'] = this.specializationKeys;
    questData['medias'] = this.media;
    questData['typeOfEmployment'] = this.employment;
    return questData;
  }
}
