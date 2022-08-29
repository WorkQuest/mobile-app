import 'package:app/constants.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/repository/raise_views_repository.dart';
import 'package:app/utils/raise_view_util.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:app/web3/repository/wallet_repository.dart';
import 'package:decimal/decimal.dart';
import 'package:injectable/injectable.dart';
import 'package:app/base_store/i_store.dart';
import 'package:mobx/mobx.dart';

part 'raise_views_store.g.dart';

@injectable
class RaiseViewStore extends _RaiseViewStore with _$RaiseViewStore {
  RaiseViewStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _RaiseViewStore extends IStore<RaiseViewStoreState> with Store {
  final IRaiseViewsRepository _repository;

  _RaiseViewStore(ApiProvider apiProvider) : _repository = RaiseViewsRepository(apiProvider);

  @observable
  int periodGroupValue = 1;

  @observable
  int levelGroupValue = 0;

  String questId = "";

  String gas = "0.0";

  String amount = "";

  int period = 0;

  @observable
  bool needApprove = true;

  BaseQuestResponse? _quest;

  BigInt? _priceForApprove;

  String addressWUSD = WalletRepository().notifierNetwork.value == Network.mainnet
      ? Constants.worknetMainnetWUSD
      : Constants.worknetTestnetWUSD;

  String get addressWQPromotion => Web3Utils.getAddressWorknetWQPromotion();

  Map<int, List<String>> price = {};

  setQuestId(String value) => questId = value;

  setAmount({
    required bool isQuest,
    required int tariff,
    required int period,
  }) =>
      amount = RaiseViewUtils.getAmount(isQuest: isQuest, tariff: tariff, period: period);

  @action
  void initPrice() {
    price[1] = RaiseViewConstants.forDay;
    price[2] = RaiseViewConstants.forWeek;
    price[3] = RaiseViewConstants.forMonth;
  }

  @action
  changePeriod(int? value) => periodGroupValue = value!;

  @action
  changeLevel(int? value) => levelGroupValue = value!;

  @action
  getQuest() async {
    try {
      this.onLoading();
      _quest = await _repository.getQuest(questId);
      this.onSuccess(RaiseViewStoreState.getQuest);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  checkAllowance() async {
    try {
      this.onLoading();
      _priceForApprove = (Decimal.parse(amount) * Decimal.fromInt(10).pow(18)).toBigInt();
      needApprove = await _repository.needApprove(_priceForApprove!);
      this.onSuccess(RaiseViewStoreState.checkAllowance);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  approve() async {
    try {
      this.onLoading();
      await _repository.approve(_priceForApprove!);
      onSuccess(RaiseViewStoreState.approve);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  raiseProfile() async {
    try {
      this.onLoading();
      period = RaiseViewUtils.getPeriod(periodGroupValue: periodGroupValue);
      await _repository.raiseViewProfile(levelGroup: levelGroupValue, period: period, amount: amount);
      this.onSuccess(RaiseViewStoreState.raiseProfile);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  raiseQuest(String questId) async {
    try {
      this.onLoading();
      period = RaiseViewUtils.getPeriod(
        periodGroupValue: periodGroupValue,
        isQuest: true,
      );
      await _repository.raiseViewQuest(
        levelGroup: levelGroupValue,
        period: period,
        amount: amount,
        contractAddress: _quest!.contractAddress!,
      );
      this.onSuccess(RaiseViewStoreState.raiseQuest);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  getGasApprove() async {
    try {
      onLoading();
      _priceForApprove = (Decimal.parse(amount) * Decimal.fromInt(10).pow(18)).toBigInt();
      gas = await _repository.getGasApprove(_priceForApprove!);
      onSuccess(RaiseViewStoreState.getGasApprove);
    } catch (e) {
      onError(e.toString());
    }
  }

  @action
  getGasRaiseViewProfile() async {
    try {
      onLoading();
      period = RaiseViewUtils.getPeriod(periodGroupValue: periodGroupValue, isQuest: false);
      gas = await _repository.getGasRaiseViewProfile(levelGroup: levelGroupValue, period: period);
      onSuccess(RaiseViewStoreState.getGasRaiseViewProfile);
    } catch (e) {
      onError(e.toString());
    }
  }

  @action
  getGasRaiseViewQuest() async {
    try {
      onLoading();
      period = RaiseViewUtils.getPeriod(periodGroupValue: periodGroupValue, isQuest: true);
      gas = await _repository.getGasRaiseViewQuest(
        levelGroup: levelGroupValue,
        period: period,
        amount: amount,
        contractAddress: _quest!.contractAddress!,
      );
      onSuccess(RaiseViewStoreState.getGasRaiseViewQuest);
    } catch (e) {
      onError(e.toString());
    }
  }
}

enum RaiseViewStoreState {
  approve,
  raiseProfile,
  raiseQuest,
  checkAllowance,
  getQuest,
  getGasApprove,
  getGasRaiseViewProfile,
  getGasRaiseViewQuest
}
