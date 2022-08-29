import 'package:app/http/api_provider.dart';
import 'package:app/keys.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/create_quest_page/entity/create_quest_request_model.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/model/quests_models/location_full.dart';
import 'package:app/repository/create_quest_repository.dart';
import 'package:app/ui/widgets/media_upload/store/i_media_store.dart';
import 'package:app/utils/quest_util.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'create_quest_store.g.dart';

@injectable
class CreateQuestStore extends _CreateQuestStore with _$CreateQuestStore {
  CreateQuestStore(ApiProvider questApiProvider) : super(questApiProvider);
}

abstract class _CreateQuestStore extends IMediaStore<CreateQuestStoreState>
    with Store {
  final ICreateQuestRepository _repository;

  final ApiProvider _apiProvider;

  _CreateQuestStore(this._apiProvider)
      : _repository = CreateQuestRepository(_apiProvider);

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: Keys.googleKey);

  BigInt oldPrice = BigInt.zero;

  String? contractAddress;

  bool get isEdit => contractAddress != null;

  @observable
  CreateQuestRequestModel quest = CreateQuestRequestModel.empty();

  @action
  initQuest({required BaseQuestResponse? quest}) {
    setImages(quest?.medias ?? []);
    if (quest != null) {
      contractAddress = quest.contractAddress;
      oldPrice = BigInt.parse(quest.price);
      confirmUnderstandAboutEdit = true;
      this.quest = this.quest.copyWith(
            location: LocationFull(
              locationPlaceName: quest.locationPlaceName,
              locationCode: LocationCode(
                longitude: quest.location.longitude,
                latitude: quest.location.latitude,
              ),
            ),
            priority: quest.priority,
            employment: quest.employment,
            payPeriod: quest.payPeriod,
            title: quest.title,
            workplace: quest.workplace,
            description: quest.description,
            price: Decimal.parse(quest.price).toString(),
            media: quest.medias ?? [],
            specializationKeys: quest.questSpecializations,
          );
    }
  }

  @observable
  bool confirmUnderstandAboutEdit = false;

  @observable
  List<String> skillFilters = [];

  String? gas;

  bool needApprove = false;

  @action
  setConfirmUnderstandAboutEdit(bool value) =>
      confirmUnderstandAboutEdit = value;

  @action
  void setQuestTitle(String value) => quest = quest.copyWith(title: value);

  @action
  void setAboutQuest(String value) =>
      quest = quest.copyWith(description: value);

  @action
  void setPrice(String value) {
    final _price = Decimal.parse(value) * Decimal.fromInt(10).pow(18);
    quest = quest.copyWith(price: _price.toDouble().toStringAsFixed(0));
  }

  @action
  void changedPriority(String selectedPriority) => quest =
      quest.copyWith(priority: QuestUtils.getPriorityToValue(selectedPriority));

  @action
  void changedEmployment(String selectedEmployment) => quest = quest.copyWith(
      employment: QuestUtils.getEmploymentValue(selectedEmployment));

  @action
  void changedPayPeriod(String value) =>
      quest = quest.copyWith(payPeriod: QuestUtils.getPayPeriodValue(value));

  @action
  void changedDistantWork(String distantWork) => quest =
      quest.copyWith(workplace: QuestUtils.getWorkplaceValue(distantWork));

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
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId!);
      quest = quest.copyWith(
        location: LocationFull(
          locationPlaceName: p.description!,
          locationCode: LocationCode(
            longitude: detail.result.geometry!.location.lng,
            latitude: detail.result.geometry!.location.lat,
          ),
        ),
      );
    }
  }

  @action
  checkAllowance({String? addressQuest}) async {
    print('checkAllowance');
    try {
      onLoading();
      final _price = Decimal.parse(quest.price!) * Decimal.fromInt(10).pow(18);
      final _isNeedCheckApprove = _price.toBigInt() > oldPrice;
      if (_isNeedCheckApprove) {
        needApprove = await _repository.needApprove(
          price: quest.price!,
          contractAddress: addressQuest,
        );
      }
      onSuccess(CreateQuestStoreState.checkAllowance);
    } catch (e) {
      onError(e.toString());
    }
  }

  @action
  approve({String? contractAddress}) async {
    print('approve');
    try {
      onLoading();
      await _repository.approve(
          contractAddress: contractAddress, price: quest.price!);
      onSuccess(CreateQuestStoreState.approve);
    } catch (e) {
      onError(e.toString());
    }
  }

  @action
  editQuest({required String questId}) async {
    try {
      onLoading();
      quest = quest.copyWith(specializationKeys: skillFilters);
      await sendImages(_apiProvider);
      if (isEdit) {
        quest = quest.copyWith(
          title: null,
          description: null,
        );
      }
      await _repository.editQuest(
        quest: quest,
        questId: questId,
        contractAddress: contractAddress!,
      );

      onSuccess(CreateQuestStoreState.editQuest);
    } catch (e) {
      onError(e.toString());
    }
  }

  @action
  createQuest() async {
    try {
      this.onLoading();
      quest = quest.copyWith(specializationKeys: skillFilters);
      await sendImages(_apiProvider);
      await _repository.createQuest(quest: quest);

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
    try {
      this.onLoading();
      gas = await _repository.getGasApprove(price: quest.price!);
      onSuccess(CreateQuestStoreState.getGasApprove);
    } catch (e) {
      onError(e.toString());
    }
  }

  @action
  getGasEditQuest() async {
    try {
      onLoading();
      gas = await _repository.getGasEditQuest(
          price: quest.price!, contractAddress: contractAddress!);
      onSuccess(CreateQuestStoreState.getGasEditQuest);
    } catch (e) {
      onError(e.toString());
    }
  }

  getGasCreateQuest() async {
    try {
      onLoading();
      gas = await _repository.getGasCreateQuest(
          price: quest.price!, description: quest.description!);
      onSuccess(CreateQuestStoreState.getGasCreateQuest);
    } catch (e) {
      onError(e.toString());
    }
  }
}

enum CreateQuestStoreState {
  getPrediction,
  displayPrediction,
  getGasApprove,
  getGasEditQuest,
  getGasCreateQuest,
  createQuest,
  editQuest,
  checkAllowance,
  approve
}
