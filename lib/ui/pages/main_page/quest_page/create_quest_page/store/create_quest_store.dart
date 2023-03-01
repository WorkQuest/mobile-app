import 'package:app/constants.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/keys.dart';
import 'package:app/model/quests_models/create_quest_request_model.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/model/quests_models/location_full.dart';
import 'package:app/ui/widgets/media_upload/store/i_media_store.dart';
import 'package:app/utils/quest_util.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:app/web3/contractEnums.dart';
import 'package:app/web3/repository/wallet_repository.dart';
import 'package:app/web3/service/client_service.dart';
import 'package:decimal/decimal.dart';
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

abstract class _CreateQuestStore extends IMediaStore<CreateQuestStoreState> with Store {
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

  String? gas;

  bool needApprove = false;

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
  void changedEmployment(String selectedEmployment) => employment = selectedEmployment;

  @action
  void changedPayPeriod(String value) => payPeriod = value;

  @action
  void changedDistantWork(String selectedEmployment) => workplace = selectedEmployment;

  @computed
  bool get canCreateQuest => locationPlaceName.isNotEmpty && skillFilters.isNotEmpty;

  @computed
  bool get canSubmitEditQuest =>
      locationPlaceName.isNotEmpty &&
      skillFilters.isNotEmpty &&
      confirmUnderstandAboutEdit;

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
  checkAllowance({String? addressQuest}) async {
    print('checkAllowance');
    try {
      onLoading();
      // await Future.delayed(const Duration(seconds: 1));
      // throw Exception('Error checkAllowance');
      final _client = WalletRepository().getClientWorkNet();
      final _price = Decimal.parse(price) * Decimal.fromInt(10).pow(18).toDecimal();
      final _isNeedCheckApprove = _price.toBigInt() > oldPrice;
      if (_isNeedCheckApprove) {
        print('addressQuest: $addressQuest');
        final _allowance = await _client.allowanceCoin(
          address: addressQuest == null ? null : EthereumAddress.fromHex(addressQuest),
        );
        print('allowance: $_allowance');
        final _priceForApprove =
            _price * Decimal.parse(Constants.commissionForQuest.toString());
        print('priceForApprove: $_priceForApprove');
        needApprove = _allowance < _priceForApprove.toBigInt();
        onSuccess(CreateQuestStoreState.checkAllowance);
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  @action
  approve({String? contractAddress}) async {
    print('approve');
    try {
      onLoading();
      // await Future.delayed(const Duration(seconds: 1));
      // throw Exception('Error approve');
      final _price = Decimal.parse(price) * Decimal.fromInt(10).pow(18).toDecimal();
      final _priceForApprove =
          _price * Decimal.parse(Constants.commissionForQuest.toString());
      final _isEdit = contractAddress != null;
      await WalletRepository().getClientWorkNet().approveCoin(
        price: _priceForApprove.toBigInt(),
        address: _isEdit
            ? EthereumAddress.fromHex(contractAddress!)
            : null,
      );
      onSuccess(CreateQuestStoreState.approve);
    } catch (e) {
      onError(e.toString());
    }
  }

  @action
  createQuest({
    bool isEdit = false,
    String questId = "",
  }) async {
    print('createQuest');
    try {
      this.onLoading();
      // await Future.delayed(const Duration(seconds: 1));
      // throw Exception('Error createQuest');
      final LocationFull location = LocationFull(
        locationPlaceName: locationPlaceName,
        locationCode: LocationCode(
          longitude: longitude,
          latitude: latitude,
        ),
      );
      await sendImages(apiProvider);
      final _price = Decimal.parse(price) * Decimal.fromInt(10).pow(18).toDecimal();
      print('employment: $employment');
      print('workplace: $workplace');
      print('payPeriod: $payPeriod');
      print('priority: $priority');
      final CreateQuestRequestModel questModel = CreateQuestRequestModel(
        employment: QuestUtils.getEmploymentValue(employment),
        workplace: QuestUtils.getWorkplaceValue(workplace),
        payPeriod: QuestUtils.getPayPeriodValue(payPeriod),
        priority: QuestUtils.getPriorityToValue(priority),
        specializationKeys: skillFilters,
        location: location,
        adType: adType,
        category: category,
        media: medias.map((media) => media.id).toList(),
        title: isEdit ? null : questTitle,
        description: isEdit ? null : description,
        price: isEdit ? null : (_price.toDouble()).toStringAsFixed(0),
      );
      //priority show item

      final _client = WalletRepository().getClientWorkNet();

      if (isEdit) {
        await _client.handleEvent(
          function: WQContractFunctions.editJob,
          contractAddress: contractAddress,
          params: [
            _price.toBigInt(),
          ],
          value: null,
        );
        await apiProvider.editQuest(
          quest: questModel,
          questId: questId,
        );
      } else {
        final balanceWusd = await _client.getBalanceInUnit(
            EtherUnit.ether, WalletRepository().privateKey);
        final gas = await _client.getGas();

        if (balanceWusd < double.parse(price) + (gas.getInEther).toDouble()) {
          throw Exception('Not enough balance.');
        }

        final nonce = await apiProvider.createQuest(
          quest: questModel,
        );

        final _priceForApprove =
            _price * Decimal.parse(Constants.commissionForQuest.toString());
        final _allowance = await _client.allowanceCoin();
        final _isNeedApprove = _allowance < _priceForApprove.toBigInt();
        if (_isNeedApprove) {
          final approveCoin =
              await _client.approveCoin(price: _priceForApprove.toBigInt());

          if (approveCoin) {
            await _client.createNewContract(
              jobHash: description,
              price: _price.toBigInt(),
              deadline: DateTime.now().add(const Duration(days: 1)).millisecondsSinceEpoch.toString(),
              nonce: nonce,
            );
          } else {
            throw FormatException('Failed approve');
          }
        } else {
          await _client.createNewContract(
            jobHash: description,
            price: _price.toBigInt(),
            deadline: 0.toString(),
            nonce: nonce,
          );
        }
      }

      this.onSuccess(CreateQuestStoreState.createQuest);
    } on FormatException catch (e) {
      print('createQuest FormatException | ${e.message}');
      this.onError(e.message);
    } catch (e, trace) {
      print('createQuest | $e\n$trace');
      this.onError(e.toString());
    }
  }

  @action
  getGasApprove({String? addressQuest}) async {
    print('getGasApprove');
    try {
      this.onLoading();
      // await Future.delayed(const Duration(seconds: 1));
      // throw Exception('Error getGasApprove');
      final _client = WalletRepository().getClientWorkNet();
      final _price = Decimal.parse(price) * Decimal.fromInt(10).pow(18).toDecimal();
      final _gasForApprove = await _client.getEstimateGasForApprove(_price.toBigInt());
      await Web3Utils.checkPossibilityTx(
        typeCoin: TokenSymbols.WUSD,
        fee: Decimal.parse(_gasForApprove.toString()),
        amount: double.parse(price),
        isMain: true,
      );
      gas = _gasForApprove.toStringAsFixed(17);
      onSuccess(CreateQuestStoreState.getGasApprove);
    } catch (e) {
      onError(e.toString());
    }
  }

  @action
  getGasEditOrCreateQuest({bool isEdit = false}) async {
    print('getGasEditOrCreateQuest');
    try {
      onLoading();
      // await Future.delayed(const Duration(seconds: 1));
      // throw Exception('Error getGasEditOrCreateQuest');
      final _client = WalletRepository().getClientWorkNet();
      if (isEdit) {
        final _price = Decimal.parse(price) * Decimal.fromInt(10).pow(18).toDecimal();
        final _contract = await _client.getDeployedContract("WorkQuest", contractAddress);
        final _function = _contract.function(WQContractFunctions.editJob.name);
        final _params = [
          _price.toBigInt(),
        ];
        final _gas = await _client.getEstimateGasCallContract(
            contract: _contract, function: _function, params: _params);
        await Web3Utils.checkPossibilityTx(
          typeCoin: TokenSymbols.WUSD,
          fee: Decimal.parse(_gas.toString()),
          amount: double.parse(price),
          isMain: true,
        );
        gas = _gas.toStringAsFixed(17);
        onSuccess(CreateQuestStoreState.getGasEditOrCreateQuest);
      } else {
        final _contract = await _client.getDeployedContract(
            "WorkQuestFactory", Web3Utils.getAddressWorknetWQFactory());
        final _function = _contract.function(WQFContractFunctions.newWorkQuest.name);
        final _params = [
          _client.stringToBytes32(description),
          BigInt.zero,
          BigInt.from(0.0),
          BigInt.from(0.0),
        ];
        final _gas = await _client.getEstimateGasCallContract(
            contract: _contract, function: _function, params: _params);
        await Web3Utils.checkPossibilityTx(
          typeCoin: TokenSymbols.WUSD,
          fee: Decimal.parse(_gas.toString()),
          amount: double.parse(price),
          isMain: true,
        );
        gas = _gas.toStringAsFixed(17);
        onSuccess(CreateQuestStoreState.getGasEditOrCreateQuest);
      }
    } catch (e, trace) {
      print('test $e\n$trace');
      onError(e.toString());
    }
  }
}

enum CreateQuestStoreState {
  getPrediction,
  displayPrediction,
  getGasApprove,
  getGasEditOrCreateQuest,
  createQuest,
  checkAllowance,
  approve
}
