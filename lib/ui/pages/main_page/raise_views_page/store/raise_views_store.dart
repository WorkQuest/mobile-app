import 'dart:math';

import 'package:app/constants.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
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
  TokenSymbols? typeCoin;

  @observable
  TYPE_WALLET? typeWallet;

  @observable
  int periodGroupValue = 1;

  @observable
  int levelGroupValue = 1;

  int periodValue = 0;

  String questId = "";

  String gas = "0.0";

  String amount = "";

  bool approved = false;

  @observable
  bool needApprove = true;

  BaseQuestResponse? _quest;

  BigInt? _priceForApprove;

  String addressWUSD = AccountRepository().notifierNetwork.value == Network.mainnet
      ? Constants.worknetMainnetWUSD
      : Constants.worknetTestnetWUSD;

  final address = EthereumAddress.fromHex(Web3Utils.getAddressWorknetWQPromotion());

  Map<int, List<String>> price = {};

  List<String> forDay = [r"20$", r"12$", r"9$", r"7$"];
  List<String> forWeek = [r"35$", r"28$", r"22$", r"18$"];
  List<String> forMonth = [r"50$", r"35$", r"29$", r"21$"];

  List<DataCoins> coins = [
    DataCoins(
        symbolToken: TokenSymbols.WUSD,
        iconPath: "assets/coins/wusd.svg",
        title: 'WUSD',
        isEnable: true),
    DataCoins(
        symbolToken: TokenSymbols.WQT,
        iconPath: "assets/coins/wqt.svg",
        title: 'WQT',
        isEnable: true),
  ];

  List<WalletItem> wallets = [
    WalletItem("assets/coinpaymebts.svg", "Сoinpaymebts", TYPE_WALLET.Coinpaymebts),
  ];

  @observable
  DataCoins? currentCoin;

  @observable
  WalletItem? currentWallet;

  @computed
  bool get selectedCoin => currentCoin != null;

  @computed
  bool get selectedWallet => currentWallet != null;

  setQuestId(String value) => questId = value;

  @action
  setApprove(bool value) {
    approved = value;
    print("approved: $approved");
    if (!value) this.onError("Cancel");
  }

  @action
  setTitleSelectedCoin(TokenSymbols? value) => typeCoin = value;

  @action
  setTitleSelectedWallet(TYPE_WALLET? value) => typeWallet = value;

  @action
  void setCurrentCoin(DataCoins value) => currentCoin = value;

  @action
  void setCurrentWallet(WalletItem value) => currentWallet = value;

  @action
  void initPrice() {
    price[1] = forDay;
    price[2] = forWeek;
    price[3] = forMonth;
  }

  @action
  void initValue() {
    currentCoin = coins[0];
    currentWallet = wallets[0];
  }

  int getPeriod({bool isQuest = false}) {
    if (isQuest) {
      switch (periodGroupValue) {
        case 1:
          return periodValue = 1;
        case 2:
          return periodValue = 5;
        case 3:
          return periodValue = 7;
      }
    } else {
      switch (periodGroupValue) {
        case 1:
          return periodValue = 1;
        case 2:
          return periodValue = 7;
        case 3:
          return periodValue = 30;
      }
    }
    return periodValue;
  }

  @action
  changePeriod(int? value) => periodGroupValue = value!;

  @action
  changeLevel(int? value) => levelGroupValue = value!;

  @computed
  bool get canSubmit => !isLoading && typeCoin != null && typeWallet != null;

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
      final _allowance = await _client.allowanceCoin(address: address);
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
            address: address,
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
      final _period = getPeriod();
      await Web3Utils.checkPossibilityTx(
        typeCoin: TokenSymbols.WUSD,
        fee: Decimal.parse(gas),
        amount: double.parse(amount),
      );
      await AccountRepository().getClientWorkNet().promoteUser(
            tariff: levelGroupValue - 1,
            period: _period,
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
      final _period = getPeriod(isQuest: true);
      final _price = BigInt.from(double.parse(amount) * pow(10, 18));
      await AccountRepository().getClientWorkNet().approveCoin(price: _price);
      await AccountRepository().getClientWorkNet().promoteQuest(
            tariff: levelGroupValue - 1,
            period: _period,
            amount: amount,
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
          BigInt.from(levelGroupValue - 1),
          BigInt.from(getPeriod(isQuest: true)),
        ],
      );
    else
      _gasForPromote = await _client.getEstimateGasCallContract(
        contract: _contractPromote,
        function: _contractPromote.function(WQPromotionFunctions.promoteUser.name),
        params: [
          BigInt.from(levelGroupValue - 1),
          BigInt.from(getPeriod(isQuest: false)),
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
            address,
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

  void getAmount({
    required bool isQuest,
    required int tariff,
    required int period,
  }) {
    if (isQuest) {
      switch (period) {
        case 1:
          switch (tariff) {
            case 1:
              amount = '20';
              return;
            case 2:
              amount = '12';
              return;
            case 3:
              amount = '9';
              return;
            case 4:
              amount = '7';
              return;
          }
          break;
        case 5:
          switch (tariff) {
            case 1:
              amount = '35';
              return;
            case 2:
              amount = '28';
              return;
            case 3:
              amount = '22';
              return;
            case 4:
              amount = '18';
              return;
          }
          break;
        case 7:
          switch (tariff) {
            case 1:
              amount = '50';
              return;
            case 2:
              amount = '35';
              return;
            case 3:
              amount = '29';
              return;
            case 4:
              amount = '21';
              return;
          }
          break;
      }
    } else {
      switch (period) {
        case 1:
          switch (tariff) {
            case 1:
              amount = '20';
              return;
            case 2:
              amount = '12';
              return;
            case 3:
              amount = '9';
              return;
            case 4:
              amount = '7';
              return;
          }
          break;
        case 7:
          switch (tariff) {
            case 1:
              amount = '35';
              return;
            case 2:
              amount = '28';
              return;
            case 3:
              amount = '22';
              return;
            case 4:
              amount = '18';
              return;
          }
          break;
        case 30:
          switch (tariff) {
            case 1:
              amount = '50';
              return;
            case 2:
              amount = '35';
              return;
            case 3:
              amount = '29';
              return;
            case 4:
              amount = '21';
              return;
          }
          break;
      }
    }
  }
}

enum RaiseViewStoreState { approve, raiseProfile, raiseQuest, checkAllowance, getQuest }
