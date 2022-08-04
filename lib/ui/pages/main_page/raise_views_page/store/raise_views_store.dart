import 'dart:math';

import 'package:app/constants.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/utils/raise_view_util.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:decimal/decimal.dart';
import 'package:injectable/injectable.dart';
import 'package:app/base_store/i_store.dart';
import 'package:mobx/mobx.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web3dart/web3dart.dart';

import '../../../../../web3/contractEnums.dart';
import '../../../../../web3/repository/account_repository.dart';
import '../../../../../web3/service/client_service.dart';

part 'raise_views_store.g.dart';

@injectable
class RaiseViewStore extends _RaiseViewStore with _$RaiseViewStore {
  RaiseViewStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _RaiseViewStore extends IStore<RaiseViewStoreState> with Store {
  final ApiProvider apiProvider;

  _RaiseViewStore(this.apiProvider);

  @observable
  int periodGroupValue = 1;

  @observable
  int levelGroupValue = 1;

  String questId = "";

  String gas = "0.0";

  String amount = "";

  int period = 0;

  @observable
  bool needApprove = true;

  BaseQuestResponse? _quest;

  BigInt? _priceForApprove;

  String addressWUSD = AccountRepository().notifierNetwork.value == Network.mainnet
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

  Future<void> getQuest() async {
    try {
      this.onLoading();
      _quest = await apiProvider.getQuest(id: questId);
      this.onSuccess(RaiseViewStoreState.getQuest);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future<void> checkAllowance() async {
    try {
      this.onLoading();
      final _client = AccountRepository().getClientWorkNet();
      final _allowance = await _client.allowanceCoin(
        address: EthereumAddress.fromHex(addressWQPromotion),
      );
      print('_allowance: $_allowance');

      _priceForApprove = (Decimal.parse(amount) * Decimal.fromInt(10).pow(18)).toBigInt();
      print('_priceForApprove: $_priceForApprove');
      needApprove = _allowance < _priceForApprove!;
      this.onSuccess(RaiseViewStoreState.checkAllowance);
    } catch (e, trace) {
      print('checkAllowance | $e\n$trace');
      this.onError(e.toString());
    }
  }

  @action
  approve() async {
    try {
      print('approve');
      this.onLoading();
      await Web3Utils.checkPossibilityTx(
        typeCoin: TokenSymbols.WUSD,
        fee: Decimal.parse(gas),
        amount: double.parse(amount),
      );
      print('_priceForApprove: $_priceForApprove');
      await AccountRepository().getClientWorkNet().approveCoin(
            price: _priceForApprove!,
            address: EthereumAddress.fromHex(addressWQPromotion),
          );
      onSuccess(RaiseViewStoreState.approve);
    } on FormatException catch (e, trace) {
      print('raiseProfile FormatException | $e\n$trace');
      this.onError(e.message);
    } catch (e, trace) {
      print('raiseProfile | $e\n$trace');
      this.onError(e.toString());
    }
  }

  @action
  Future<void> raiseProfile() async {
    try {
      print('raiseProfile');
      this.onLoading();
      period = RaiseViewUtils.getPeriod(periodGroupValue: periodGroupValue);
      await Web3Utils.checkPossibilityTx(
        typeCoin: TokenSymbols.WUSD,
        fee: Decimal.parse(gas),
        amount: double.parse(amount),
      );
      await AccountRepository().getClientWorkNet().promoteUser(
            tariff: levelGroupValue,
            period: period,
          );
      this.onSuccess(RaiseViewStoreState.raiseProfile);
    } on FormatException catch (e, trace) {
      print('raiseProfile FormatException | $e\n$trace');
      this.onError(e.message);
    } catch (e, trace) {
      print('raiseProfile | $e\n$trace');
      this.onError(e.toString());
    }
  }

  @action
  Future<void> raiseQuest(String questId) async {
    try {
      print('raiseQuest');
      this.onLoading();
      await Web3Utils.checkPossibilityTx(
        typeCoin: TokenSymbols.WUSD,
        fee: Decimal.parse(gas),
        amount: double.parse(amount),
      );
      period = RaiseViewUtils.getPeriod(
        periodGroupValue: periodGroupValue,
        isQuest: true,
      );
      // final _price = BigInt.from(double.parse(amount) * pow(10, 18));
      // await AccountRepository().getClientWorkNet().approveCoin(price: _price);
      await AccountRepository().getClientWorkNet().promoteQuest(
            tariff: levelGroupValue,
            period: period,
            questAddress: _quest!.contractAddress!,
          );

      this.onSuccess(RaiseViewStoreState.raiseQuest);
    } on FormatException catch (e, trace) {
      print('raiseQuest FormatException | $e\n$trace');
      this.onError(e.message);
    } catch (e, trace) {
      print('raiseQuest | $e\n$trace');
      this.onError(e.toString());
    }
  }

  Future<void> getFeePromotion(bool isQuestRaise) async {
    final _client = AccountRepository().getClientWorkNet();
    final _contractPromote = await _client.getDeployedContract(
        "WQPromotion", Web3Utils.getAddressWorknetWQPromotion());
    double _gasForPromote = 0.0;
    if (isQuestRaise)
      _gasForPromote = await _client.getEstimateGasCallContract(
        contract: _contractPromote,
        function: _contractPromote.function(WQPromotionFunctions.promoteQuest.name),
        params: [
          EthereumAddress.fromHex(_quest!.contractAddress!),
          BigInt.from(levelGroupValue),
          BigInt.from(RaiseViewUtils.getPeriod(
              periodGroupValue: periodGroupValue, isQuest: true)),
        ],
      );
    else
      _gasForPromote = await _client.getEstimateGasCallContract(
        contract: _contractPromote,
        function: _contractPromote.function(WQPromotionFunctions.promoteUser.name),
        params: [
          BigInt.from(levelGroupValue),
          BigInt.from(RaiseViewUtils.getPeriod(
              periodGroupValue: periodGroupValue, isQuest: false)),
        ],
      );
    gas = _gasForPromote.toStringAsFixed(17);
  }

  Future<void> getFeeApprove({bool isQuestRaise = false}) async {
    final _client = AccountRepository().getClientWorkNet();
    final _contract =
        Erc20(address: EthereumAddress.fromHex(addressWUSD), client: _client.client!);
    final _gas = await _client.getGas();
    final _price = BigInt.from(double.parse(amount) * pow(10, 18));
    BigInt? _gasForApprove;
    if (isQuestRaise)
      _gasForApprove = await _client.getEstimateGas(
        Transaction.callContract(
          contract: _contract.self,
          function: _contract.self.abi.functions[1],
          parameters: [
            EthereumAddress.fromHex(addressWQPromotion),
            _price,
          ],
          from: EthereumAddress.fromHex(AccountRepository().userAddress),
          value: EtherAmount.zero(),
        ),
      );
    else
      _gasForApprove = await _client.getEstimateGas(
        Transaction.callContract(
          contract: _contract.self,
          function: _contract.self.abi.functions[1],
          parameters: [
            EthereumAddress.fromHex(Web3Utils.getAddressWorknetWQPromotion()),
            _price,
          ],
          from: EthereumAddress.fromHex(AccountRepository().userAddress),
          value: EtherAmount.zero(),
        ),
      );

    gas = (Decimal.fromBigInt(_gasForApprove) *
            Decimal.fromBigInt(_gas.getInWei) /
            Decimal.fromInt(10).pow(18))
        .toDouble()
        .toStringAsFixed(17);
  }
}

enum RaiseViewStoreState { approve, raiseProfile, raiseQuest, checkAllowance, getQuest }
