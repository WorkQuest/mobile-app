import 'package:app/http/api_provider.dart';
import 'package:app/base_store/i_store.dart';
import 'package:app/model/create_quest_model/create_quest_request_model.dart';
import 'package:app/model/quests_models/create_quest_model/location_model.dart';
import 'package:drishya_picker/drishya_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:easy_localization/easy_localization.dart';

part 'create_quest_store.g.dart';

@injectable
class CreateQuestStore extends _CreateQuestStore with _$CreateQuestStore {
  CreateQuestStore(ApiProvider questApiProvider) : super(questApiProvider);
}

abstract class _CreateQuestStore extends IStore<bool> with Store {
  final ApiProvider apiProvider;

  _CreateQuestStore(this.apiProvider);

  final List<String> priorityList = [
    "quests.priority.low".tr(),
    "quests.priority.normal".tr(),
    "quests.priority.urgent".tr(),
  ];

  final List<String> employmentList = [
    "quests.employment.fullTime".tr(),
    "quests.employment.partTime",
    "quests.employment.fixedTerm",
  ];

  final List<String> distantWorkList = [
    "Distant work",
    "Work in the office",
    "Both options".tr(),
  ];

  static List<String> months = [
    "months.january".tr(),
    "months.february".tr(),
    "months.march".tr(),
    "months.april".tr(),
    "months.may".tr(),
    "months.june".tr(),
    "months.july".tr(),
    "months.august".tr(),
    "months.september".tr(),
    "months.october".tr(),
    "months.november".tr(),
    "months.december".tr(),
  ];

  /// location, runtime, images and videos ,priority undone

  @observable
  String employment = "Full time";

  @observable
  String employmentValue = "fullTime";

  @observable
  String workplaceValue = "distant";

  @observable
  String workplace = "Distant work";

  @observable
  String category = 'Choose';

  @observable
  String categoryValue = 'other';

  @observable
  String priority = "quests.priority.low".tr();

  @observable
  bool hasRuntime = false;

  @observable
  DateTime runtimeValue = DateTime.now().add(
    Duration(days: 1),
  );

  @observable
  String dateTime = '';

  @observable
  double longitude = 0;

  @observable
  double latitude = 0;

  @observable
  String questTitle = '';

  @observable
  String description = '';

  @observable
  String price = '';

  @observable
  int adType = 0;

  @observable
  ObservableList<DrishyaEntity> media = ObservableList();

  @observable
  String locationPlaceName = '';

  /// change location data

  @action
  void setQuestTitle(String value) => questTitle = value;

  @action
  void setRuntime(bool? value) => hasRuntime = value!;

  @computed
  String get dateString => "${runtimeValue.year.toString()} - "
      "${months[runtimeValue.month - 1].padLeft(2, '0')} - "
      "${runtimeValue.day.toString().padLeft(2, '0')} ";

  @action
  void setDateTime(DateTime value) => runtimeValue = value;

  @action
  void setAboutQuest(String value) => description = value;

  @action
  void setPrice(String value) => price = value;

  @action
  void changedPriority(String selectedPriority) => priority = selectedPriority;

  @action
  void changedEmployment(String selectedEmployment) =>
      employment = selectedEmployment;

  @action
  void changedDistantWork(String selectedEmployment) =>
      workplace = selectedEmployment;

  @computed
  bool get canCreateQuest =>
      !isLoading &&
          price.isNotEmpty &&
          questTitle.isNotEmpty &&
          locationPlaceName.isNotEmpty &&
          description.isNotEmpty &&
          media.isNotEmpty;

  @action
  void emptyField() {
    List<String> fields = [];
    if (price.isEmpty)
      fields.add("price");
    if (questTitle.isEmpty)
      fields.add("quest title");
    if (locationPlaceName.isEmpty)
      fields.add("address");
    if (media.isEmpty)
      fields.add("media");
    onError("These fields are empty $fields");
  }

  String getWorkplaceValue() {
    switch (workplace) {
      case "Distant work":
        return workplaceValue = "distant";
      case "Work in office":
        return workplaceValue = "office";
      case "Both variant":
        return workplaceValue = "both";
    }
    return workplaceValue;
  }

  String getEmploymentValue() {
    switch (employment) {
      case "Full time":
        return employmentValue = "fullTime";
      case "Part time":
        return employmentValue = "partTime";
      case "Fixed term":
        return employmentValue = "fixedTerm";
    }
    return employmentValue;
  }

  ///API_KEY HERE
  GoogleMapsPlaces _places =
  GoogleMapsPlaces(apiKey: "AIzaSyAcSmI2VeNFNO9MdENuA4H9h9DviRKDZpU");

  @action
  Future<Null> getPrediction(BuildContext context) async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      ///API_KEY HERE
      apiKey: "AIzaSyAcSmI2VeNFNO9MdENuA4H9h9DviRKDZpU",
      mode: Mode.overlay,
      logo: SizedBox(),
      // Mode.fullscreen
    );
    locationPlaceName = p!.description!;
    displayPrediction(p.placeId);
  }

  @action
  Future<Null> displayPrediction(String? p) async {
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p!);
    latitude = detail.result.geometry!.location.lat;
    longitude = detail.result.geometry!.location.lng;
  }

  @action
  Future createQuest() async {
    try {
      this.onLoading();
      final LocationCode location = LocationCode(
        longitude: longitude,
        latitude: latitude,
      );
      final CreateQuestRequestModel questModel = CreateQuestRequestModel(
        category: categoryValue,
        employment: getEmploymentValue(),
        locationPlaceName: locationPlaceName,
        workplace: getWorkplaceValue(),
        skillFilters: {},
        priority: priorityList.indexOf(priority),
        location: location,
        media: await apiProvider.uploadMedia(
          medias: media,
        ),
        title: questTitle,
        description: description,
        price: price,
        adType: adType,
      );
      await apiProvider.createQuest(
        quest: questModel,
      );
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
