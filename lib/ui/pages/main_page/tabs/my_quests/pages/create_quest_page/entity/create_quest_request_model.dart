import '../../../../../../../../model/quests_models/location_full.dart';

class CreateQuestRequestModel {
  final int? priority;
  final LocationFull? location;
  final String? title;
  final String? description;
  final String? workplace;
  final String? price;
  final List? media;
  final List<String>? specializationKeys;
  final String? employment;
  final String? payPeriod;

  CreateQuestRequestModel({
    this.location,
    this.priority,
    this.employment,
    this.specializationKeys,
    this.payPeriod,
    this.workplace,
    this.media,
    this.title,
    this.description,
    this.price,
  });

  factory CreateQuestRequestModel.empty() => CreateQuestRequestModel(
        location: null,
        priority: 1,
        employment: 'FullTime',
        specializationKeys: [],
        payPeriod: 'Hourly',
        workplace: 'Remote',
        media: [],
        title: '',
        description: '',
        price: '0',
      );

  CreateQuestRequestModel copyWith({
    int? priority,
    LocationFull? location,
    String? title,
    String? description,
    String? workplace,
    String? price,
    List? media,
    List<String>? specializationKeys,
    String? employment,
    String? payPeriod,
  }) =>
      CreateQuestRequestModel(
          priority: priority ?? this.priority,
          location: location ?? this.location,
          title: title ?? this.title,
          description: description ?? this.description,
          workplace: workplace ?? this.workplace,
          media: media ?? this.media,
          specializationKeys: specializationKeys ?? this.specializationKeys,
          employment: employment ?? this.employment,
          payPeriod: payPeriod ?? this.payPeriod,
          price: price ?? this.price);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> questData = new Map<String, dynamic>();
    questData['priority'] = this.priority;
    questData['workplace'] = this.workplace;
    questData['locationFull'] = this.location?.toJson();
    questData['payPeriod'] = this.payPeriod;
    if (title != null) questData['title'] = this.title;
    if (price != null) questData['price'] = this.price;
    if (description != null) questData['description'] = this.description;
    questData['specializationKeys'] = this.specializationKeys;
    questData['medias'] = this.media;
    questData['typeOfEmployment'] = this.employment;
    return questData;
  }

  CreateQuestRequestModel editQuest() => CreateQuestRequestModel(
        priority: this.priority,
        location: this.location,
        workplace: this.workplace,
        media: this.media,
        specializationKeys: this.specializationKeys,
        employment:  this.employment,
        payPeriod: this.payPeriod,
        title: null,
        description: null,
        price: null,
      );
}
