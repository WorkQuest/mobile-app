import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:app/constants.dart';
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

  BigInt oldPrice = BigInt.zero;

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
  setConfirmUnderstandAboutEdit(bool value) =>
      confirmUnderstandAboutEdit = value;

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
      locationPlaceName.isNotEmpty && skillFilters.isNotEmpty;

  @computed
  bool get canSubmitEditQuest =>
      !isLoading &&
      locationPlaceName.isNotEmpty &&
      skillFilters.isNotEmpty &&
      confirmUnderstandAboutEdit;

  @action
  void emptyField(BuildContext context) {
    if (locationPlaceName.isEmpty) {
      AlertDialogUtils.showInfoAlertDialog(context,
          title: 'Error', content: "Address is empty");
    }
    if (skillFilters.isEmpty) {
      AlertDialogUtils.showInfoAlertDialog(context,
          title: 'Error', content: "Skills are empty");
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

  Future<String> getFee({bool isEdit = false}) async {
    double _resultGas = 0.0;
    try {
      this.onLoading();
      final _client = AccountRepository().getClient();
      if (isEdit) {
        final _price = BigInt.from((double.parse(price)) * pow(10, 18));
        if (_price > oldPrice) {
          final _allowance = await _client.allowanceCoin();
          print('allowance: $_allowance');
          final _priceForApprove = BigInt.from((_price.toDouble() * 1.1));
          print('priceForApprove: $_priceForApprove');
          final _isNeedApprove = _allowance < _priceForApprove;
          if (_isNeedApprove) {
            final _gasForApprove =
                await _client.getEstimateGasForApprove(_price);
            _resultGas += _gasForApprove;
            print("1 _resultGas: $_resultGas");
          }
        }
        final _contract =
            await _client.getDeployedContract("WorkQuest", contractAddress);
        final _function = _contract.function(WQContractFunctions.editJob.name);

        final _params = [
          Uint8List.fromList(
              utf8.encode(description.padRight(32).substring(0, 32))),
          _price,
        ];
        final _gas = await _client.getEstimateGasCallContract(
            contract: _contract, function: _function, params: _params);
        _resultGas += _gas;
        return _resultGas.toStringAsFixed(17);
      } else {
        final _price = BigInt.from(double.parse(price) * pow(10, 18));
        final _allowance = await _client.allowanceCoin();
        print('allowance: $_allowance');
        final _priceForApprove = BigInt.from((_price.toDouble() * 1.1));
        print('priceForApprove: $_priceForApprove');
        final _isNeedApprove = _allowance < _priceForApprove;
        if (_isNeedApprove) {
          final _gasForApprove = await _client.getEstimateGasForApprove(_price);
          _resultGas += _gasForApprove;
          print("1 _resultGas: $_resultGas");
        }
        final _contract = await _client.getDeployedContract(
            "WorkQuestFactory", Constants.worknetWQFactory);
        final _function =
            _contract.function(WQFContractFunctions.newWorkQuest.name);
        final _params = [
          _client.stringToBytes32(description),
          BigInt.zero,
          BigInt.from(0.0),
          BigInt.from(0.0),
        ];
        final _gas = await _client.getEstimateGasCallContract(
            contract: _contract, function: _function, params: _params);
        _resultGas += _gas;
        print("2 _resultGas: $_resultGas");
        return _resultGas.toStringAsFixed(17);
      }
    } on SocketException catch (_) {
      onError("Lost connection to server");
      throw FormatException('Lost connection to server');
    }
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
      final _price = BigInt.from((double.parse(price)) * pow(10, 18));
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
        price: (_price.toDouble()).toStringAsFixed(0),
      );
      //priority show item

      final _client = AccountRepository().getClient();

      if (isEdit) {
        await _client.handleEvent(
          function: WQContractFunctions.editJob,
          contractAddress: contractAddress,
          params: [
            Uint8List.fromList(
                utf8.encode(description.padRight(32).substring(0, 32))),
            _price,
          ],
          value: null,
        );
        await apiProvider.editQuest(
          quest: questModel,
          questId: questId,
        );
      } else {
        final balanceWusd = await _client.getBalanceInUnit(
            EtherUnit.ether, AccountRepository().privateKey);
        final gas = await _client.getGas();

        if (balanceWusd < double.parse(price) + (gas.getInEther).toDouble()) {
          throw Exception('Not enough balance.');
        }

        final nonce = await apiProvider.createQuest(
          quest: questModel,
        );

        final _priceForApprove = BigInt.from((_price.toDouble() * 1.1));
        final _allowance = await _client.allowanceCoin();
        final _isNeedApprove = _allowance < _priceForApprove;
        if (_isNeedApprove) {
          final approveCoin =
              await _client.approveCoin(price: _priceForApprove);

          if (approveCoin) {
            await _client.createNewContract(
              jobHash: description,
              price: _price,
              deadline: 0.toString(),
              nonce: nonce,
            );
          } else {
            throw FormatException('Failed approve');
          }
        } else {
          await _client.createNewContract(
            jobHash: description,
            price: _price,
            deadline: 0.toString(),
            nonce: nonce,
          );
        }
      }

      this.onSuccess(true);
    } on FormatException catch (e) {
      this.onError(e.message);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
