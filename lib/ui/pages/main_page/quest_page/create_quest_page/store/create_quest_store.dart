import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:app/http/api_provider.dart';
import 'package:app/keys.dart';
import 'package:app/model/quests_models/create_quest_request_model.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/model/quests_models/location_full.dart';
import 'package:app/ui/widgets/error_dialog.dart';
import 'package:app/ui/widgets/media_upload/store/i_media_store.dart';
import 'package:app/web3/contractEnums.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:app/web3/service/client_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:web3dart/web3dart.dart';

part 'create_quest_store.g.dart';

@injectable
class CreateQuestStore extends _CreateQuestStore with _$CreateQuestStore {
  CreateQuestStore(ApiProvider questApiProvider) : super(questApiProvider);
}

abstract class _CreateQuestStore extends IMediaStore<bool> with Store {
  final ApiProvider apiProvider;

  _CreateQuestStore(this.apiProvider);

  final List<String> priorityList = [
    "quests.priority.low".tr(),
    "quests.priority.normal".tr(),
    "quests.priority.urgent".tr(),
  ];

  final List<String> employmentList = [
    "Full time",
    "Part time",
    "Fixed term",
    "Remote work",
    "Employment contract",
  ];

  final List<String> distantWorkList = [
    "Distant work",
    "Work in the office",
    "Both variant",
  ];

  final List<String> payPeriodList = [
    "quests.payPeriod.hourly",
    "quests.payPeriod.daily",
    "quests.payPeriod.weekly",
    "quests.payPeriod.biWeekly",
    "quests.payPeriod.semiMonthly",
    "quests.payPeriod.monthly",
    "quests.payPeriod.quarterly",
    "quests.payPeriod.semiAnnually",
    "quests.payPeriod.annually",
    "quests.payPeriod.fixedPeriod",
    "quests.payPeriod.byAgreement",
  ];

  /// location, runtime, images and videos ,priority undone

  @observable
  String employment = "Full time";

  @observable
  String employmentValue = "FullTime";

  @observable
  String workplaceValue = "Remote";

  @observable
  String workplace = "Distant work";

  @observable
  String payPeriod = "Hourly";

  @observable
  String payPeriodValue = "Hourly";

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
  String price = "";

  @observable
  String contractAddress = "";

  @observable
  int adType = 0;

  @observable
  String locationPlaceName = '';

  @observable
  List<String> skillFilters = [];

  String? idNewQuest;

  @action
  void increaseRuntime() {}

  @action
  void decreaseRuntime() {}

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
  void changedPayPeriod(String value) => payPeriod = value;

  @action
  void changedDistantWork(String selectedEmployment) =>
      workplace = selectedEmployment;

  @computed
  bool get canCreateQuest =>
      !isLoading && locationPlaceName.isNotEmpty && skillFilters.isNotEmpty;

  @computed
  bool get canSubmitEditQuest =>
      !isLoading && locationPlaceName.isNotEmpty && skillFilters.isNotEmpty;

  @action
  void emptyField(BuildContext context) {
    if (locationPlaceName.isEmpty) errorAlert(context, "Address is empty");
    if (skillFilters.isEmpty) errorAlert(context, "Skills are empty");
  }

  String getWorkplaceValue() {
    switch (workplace) {
      case "Distant work":
        return workplaceValue = "Remote";
      case "Work in the office":
        return workplaceValue = "InOffice";
      case "Both variant":
        return workplaceValue = "Hybrid";
    }
    return workplaceValue;
  }

  String getEmploymentValue() {
    switch (employment) {
      case "Full time":
        return employmentValue = "FullTime";
      case "Part time":
        return employmentValue = "PartTime";
      case "Fixed term":
        return employmentValue = "FixedTerm";
      case "Remote Work":
        return employmentValue = "RemoteWork";
      case "Employment Contract":
        return employmentValue = "EmploymentContract";
    }
    return employmentValue;
  }

  String getWorkplace(String workplaceValue) {
    switch (workplaceValue) {
      case "Remote":
        return workplace = "Distant work";
      case "InOffice":
        return workplace = "Work in the office";
      case "Hybrid":
        return workplace = "Both variant";
    }
    return workplace;
  }

  String getPayPeriodValue() {
    switch (payPeriod) {
      case "Hourly":
        return payPeriodValue = "Hourly";
      case "Daily":
        return payPeriodValue = "Daily";
      case "Weekly":
        return payPeriodValue = "Weekly";
      case "BiWeekly":
        return payPeriodValue = "BiWeekly";
      case "Semi monthly":
        return payPeriodValue = "SemiMonthly";
      case "Monthly":
        return payPeriodValue = "Monthly";
      case "Quarterly":
        return payPeriodValue = "Quarterly";
      case "Semi annually":
        return payPeriodValue = "SemiAnnually";
      case "Annually":
        return payPeriodValue = "Annually";
      case "Fixed period":
        return payPeriodValue = "FixedPeriod";
      case "By agreement":
        return payPeriodValue = "ByAgreement";
    }
    return payPeriodValue;
  }

  String getPayPeriod(String value) {
    switch (value) {
      case "Hourly":
        return payPeriod = "Hourly";
      case "Daily":
        return payPeriod = "Daily";
      case "Weekly":
        return payPeriod = "Weekly";
      case "BiWeekly":
        return payPeriod = "BiWeekly";
      case "SemiMonthly":
        return payPeriod = "Semi monthly";
      case "Monthly":
        return payPeriod = "Monthly";
      case "Quarterly":
        return payPeriod = "Quarterly";
      case "SemiAnnually":
        return payPeriod = "Semi annually";
      case "Annually":
        return payPeriod = "Annually";
      case "FixedPeriod":
        return payPeriod = "Fixed period";
      case "ByAgreement":
        return payPeriod = "By agreement";
    }
    return payPeriod;
  }

  String getEmployment(String employmentValue) {
    switch (employmentValue) {
      case "fullTime":
        return employment = "Full time";
      case "partTime":
        return employment = "Part time";
      case "fixedTerm":
        return employment = "Fixed term";
      case "RemoteWork":
        return employment = "Remote Work";
      case "EmploymentContract":
        return employment = "Employment Contract";
    }
    return employment;
  }

  int priorityValue = 0;

  int getPriority() {
    switch (priority) {
      case "Low":
        return priorityValue = 1;
      case "Normal":
        return priorityValue = 2;
      case "Urgent":
        return priorityValue = 3;
    }
    return priorityValue;
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
      final LocationFull location = LocationFull(
        locationPlaceName: locationPlaceName,
        locationCode: LocationCode(
          longitude: longitude,
          latitude: latitude,
        ),
      );
      await sendImages(apiProvider);
      final CreateQuestRequestModel questModel = CreateQuestRequestModel(
        employment: getEmploymentValue(),
        workplace: getWorkplaceValue(),
        payPeriod: getPayPeriodValue(),
        specializationKeys: skillFilters,
        priority: getPriority(),
        location: location,
        adType: adType,
        category: category,
        media: medias.map((media) => media.id).toList(),
        title: questTitle,
        description: description,
        price:
            (BigInt.parse(price).toDouble() * pow(10, 18)).toStringAsFixed(0),
      );
      if (isEdit) {
        await ClientService().handleEvent(
          function: WQContractFunctions.editJob,
          contractAddress: contractAddress,
          params: [
            Uint8List.fromList(
              utf8.encode(
                description.padRight(32).substring(0, 32),
              ),
            ),
            BigInt.parse(price)
          ],
          value: null,
        );
        await apiProvider.editQuest(
          quest: questModel,
          questId: questId,
        );
      } else {
        final balanceWusd = await ClientService()
            .getBalanceInUnit(EtherUnit.ether, AccountRepository().privateKey);
        final gas = await ClientService().getGas();

        if (balanceWusd < double.parse(price) + (gas.getInEther).toDouble()) {
          throw Exception('Not enough balance.');
        }

        final nonce = await apiProvider.createQuest(
          quest: questModel,
        );

        final approveCoin = await ClientService().approveCoin(cost: price);

        if (approveCoin)
          await ClientService().createNewContract(
            jobHash: description,
            cost: price,
            deadline: 0.toString(),
            nonce: nonce,
          );
      }

      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
