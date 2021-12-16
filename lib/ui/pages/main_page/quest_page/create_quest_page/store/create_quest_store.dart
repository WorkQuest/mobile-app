import 'dart:io';

import 'package:app/http/api_provider.dart';
import 'package:app/base_store/i_store.dart';
import 'package:app/keys.dart';
import 'package:app/model/create_quest_model/create_quest_request_model.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/model/quests_models/create_quest_model/location_model.dart';
import 'package:app/model/quests_models/create_quest_model/media_model.dart';
import 'package:app/ui/widgets/error_dialog.dart';
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
    "quests.employment.partTime".tr(),
    "quests.employment.fixedTerm".tr(),
  ];

  final List<String> distantWorkList = [
    "Distant work",
    "Work in the office",
    "Both variant",
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
  ObservableList<File> mediaFile = ObservableList();

  @observable
  ObservableList<Media> mediaIds = ObservableList();

  @observable
  String locationPlaceName = '';

  @observable
  List<String> skillFilters = [];

  /// change location data

  @action
  void setQuestTitle(String value) => questTitle = value;

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
      locationPlaceName.isNotEmpty &&
          mediaFile.isNotEmpty &&
      skillFilters.isNotEmpty;

  @computed
  bool get canSubmitEditQuest =>
      !isLoading &&
      locationPlaceName.isNotEmpty &&
      (mediaIds.isNotEmpty || mediaFile.isNotEmpty) &&
      skillFilters.isNotEmpty;

  @action
  void emptyField(BuildContext context) {
    if (locationPlaceName.isEmpty) errorAlert(context, "Address is empty");
    if (mediaFile.isEmpty) errorAlert(context, "Media is empty");
    if (skillFilters.isEmpty) errorAlert(context, "Skills are empty");
  }

  String getWorkplaceValue() {
    switch (workplace) {
      case "Distant work":
        return workplaceValue = "distant";
      case "Work in the office":
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

  String getWorkplace(String workplaceValue) {
    switch (workplaceValue) {
      case "distant":
        return workplace = "Distant work";
      case "office":
        return workplace = "Work in the office";
      case "both":
        return workplace = "Both variant";
    }
    return workplace;
  }

  String getEmployment(String employmentValue) {
    switch (employmentValue) {
      case "fullTime":
        return employment = "Full time";
      case "partTime":
        return employment = "Part time";
      case "fixedTerm":
        return employment = "Fixed term";
    }
    return employment;
  }

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: Keys.googleKey);

  @action
  Future<Null> getPrediction(BuildContext context) async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: Keys.googleKey,
      mode: Mode.overlay,
      logo: SizedBox(),
      // Mode.fullscreen
    );
    if (p != null) {
      locationPlaceName = p.description!;
      displayPrediction(p.placeId);
    }
  }

  @action
  Future<Null> displayPrediction(String? p) async {
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p!);
    latitude = detail.result.geometry!.location.lat;
    longitude = detail.result.geometry!.location.lng;
  }

  Future<BaseQuestResponse> getQuest(String questId) async {
    return await apiProvider.getQuest(
      id: questId,
    );
  }

  @action
  Future<void> createQuest({
    bool isEdit = false,
    String questId = "",
  }) async {
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
        specializationKeys: skillFilters,
        priority: priorityList.indexOf(priority),
        location: location,
        media: mediaIds.map((e) => e.id).toList() +
            await apiProvider.uploadMedia(
              medias: mediaFile,
            ),
        title: questTitle,
        description: description,
        price: price,
        adType: adType,
      );
      isEdit
          ? await apiProvider.editQuest(
              quest: questModel,
              questId: questId,
            )
          : await apiProvider.createQuest(
              quest: questModel,
            );
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
