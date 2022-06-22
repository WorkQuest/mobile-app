import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:app/http/api_provider.dart';
import 'package:app/keys.dart';
import 'package:app/model/quests_models/create_quest_request_model.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/model/quests_models/location_full.dart';
import 'package:app/ui/widgets/media_upload/store/i_media_store.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/quest_util.dart';
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

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: Keys.googleKey);

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
  bool confirmUnderstandAboutEdit = false;

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
  setConfirmUnderstandAboutEdit(bool value) => confirmUnderstandAboutEdit = value;

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
      !isLoading && locationPlaceName.isNotEmpty && skillFilters.isNotEmpty && confirmUnderstandAboutEdit;

  @action
  void emptyField(BuildContext context) {
    if (locationPlaceName.isEmpty) {
      AlertDialogUtils.showInfoAlertDialog(context, title: 'Error', content: "Address is empty");
    }
    if (skillFilters.isEmpty) {
      AlertDialogUtils.showInfoAlertDialog(context, title: 'Error', content: "Skills are empty");
    }
  }


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
      print('employment: $employment');
      print('workplace: $workplace');
      print('payPeriod: $payPeriod');
      print('priority: $priority');
      final CreateQuestRequestModel questModel = CreateQuestRequestModel(
        employment: QuestUtils.getEmploymentValue(employment),
        workplace: QuestUtils.getWorkplaceValue(workplace),
        payPeriod: QuestUtils.getPayPeriodValue(payPeriod),
        priority: QuestUtils.getPriority(priority),
        specializationKeys: skillFilters,
        location: location,
        adType: adType,
        category: category,
        media: medias.map((media) => media.id).toList(),
        title: questTitle,
        description: description,
        price:
            (BigInt.parse(price).toDouble() * pow(10, 18)).toStringAsFixed(0),
      );
      print('questModel: ${questModel.toJson()}');
      //priority show item
      if (isEdit) {
        await AccountRepository().getClient().handleEvent(
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
        final balanceWusd = await AccountRepository().getClient()
            .getBalanceInUnit(EtherUnit.ether, AccountRepository().privateKey);
        final gas = await AccountRepository().getClient().getGas();

        if (balanceWusd < double.parse(price) + (gas.getInEther).toDouble()) {
          throw Exception('Not enough balance.');
        }

        final nonce = await apiProvider.createQuest(
          quest: questModel,
        );

        final approveCoin = await AccountRepository().getClient().approveCoin(cost: price);

        if (approveCoin)
          await AccountRepository().getClient().createNewContract(
            jobHash: description,
            cost: price,
            deadline: 0.toString(),
            nonce: nonce,
          );
      }

      this.onSuccess(true);
    } on FormatException catch (e) {
      this.onError(e.message);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
