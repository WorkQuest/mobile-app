import 'dart:io';
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

abstract class _RaiseViewStore extends IStore<bool> with Store {
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

  String gas = "";

  String amount = "";

  bool approved = false;

  BaseQuestResponse? _quest;

  String addressWUSD =
  AccountRepository().notifierNetwork.value == Network.mainnet
      ? '0x4d9F307F1fa63abC943b5db2CBa1c71D02d86AAa'
      : '0xf95ef11d0af1f40995218bb2b67ef909bcf30078';

  Map<int, List<String>> price = {};

  List<String> forDay = [r"20$", r"12$", r"9$", r"7$"];
  List<String> forWeek = [r"35$", r"28$", r"22$", r"18$"];
  List<String> forMonth = [r"50$", r"35$", r"29$", r"21$"];

  setQuestId(String value) => questId = value;

  @action
  setApprove(bool value) {
    approved = value;
    if (!value) this.onError("Cancel");
  }

  @action
  setTitleSelectedCoin(TokenSymbols? value) => typeCoin = value;

  @action
  setTitleSelectedWallet(TYPE_WALLET? value) => typeWallet = value;

  @action
  void initPrice() {
    price[1] = forDay;
    price[2] = forWeek;
    price[3] = forMonth;
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

  Future<void> getFeeApprove({bool isQuestRaise = false}) async {
    try {
      this.onLoading();
      final _client = AccountRepository().getClientWorkNet();
      final _contract = Erc20(
          address: EthereumAddress.fromHex(addressWUSD),
          client: _client.client!);
      final _gas = await _client.getGas();
      getAmount(
          isQuest: isQuestRaise,
          tariff: levelGroupValue,
          period: getPeriod(isQuest: isQuestRaise));
      if (isQuestRaise) {
        final _price = BigInt.from(double.parse(amount) * pow(10, 18));
        final _gasForApprove = await _client.getEstimateGas(
          Transaction.callContract(
            contract: _contract.self,
            function:
            _contract.self.abi.functions[1],
            parameters: [
              EthereumAddress.fromHex(Web3Utils.getAddressWorknetWQFactory()),
              _price,
            ],
            from: EthereumAddress.fromHex(AccountRepository().userAddress),
            value: EtherAmount.zero(),
          ),
        );
        print('_gasForApprove: $_gasForApprove');
        gas = (Decimal.fromBigInt(_gasForApprove) *
            Decimal.fromBigInt(_gas.getInWei) / Decimal.fromInt(10).pow(18))
            .toDouble()
            .toStringAsFixed(17);
      } else {
        final _price = BigInt.from(double.parse(amount) * pow(10, 18));

        final _gasForApprove = await _client.getEstimateGasCallContract(
          contract: _contract.self,
          function:
          _contract.self.function(WQBridgeTokenFunctions.approve.name),
          params: [
            EthereumAddress.fromHex(Web3Utils.getAddressWorknetWQFactory()),
            _price,
          ],
        );
        gas = _gasForApprove.toStringAsFixed(17);
      }
    } on SocketException catch (_) {
      this.onError("Lost connection to server");
      throw FormatException('Lost connection to server');
    }
  }

  Future<void> getFeePromotion(bool isQuestRaise) async {
    try {
      final _client = AccountRepository().getClientWorkNet();
      final _contractPromote = await _client.getDeployedContract(
          "WQPromotion", Web3Utils.getAddressWorknetWQPromotion());
      _quest = await apiProvider.getQuest(id: questId);
      double _gasForPromote = 0.0;
      if (isQuestRaise)
        _gasForPromote = await _client.getEstimateGasCallContract(
          contract: _contractPromote,
          function:
          _contractPromote.function(WQPromotionFunctions.promoteQuest.name),
          params: [
            EthereumAddress.fromHex(_quest!.contractAddress!),
            BigInt.from(levelGroupValue - 1),
            BigInt.from(getPeriod(isQuest: true)),
          ],
        );
      else
        _gasForPromote = await _client.getEstimateGasCallContract(
          contract: _contractPromote,
          function:
          _contractPromote.function(WQPromotionFunctions.promoteUser.name),
          params: [
            BigInt.from(levelGroupValue - 1),
            BigInt.from(getPeriod(isQuest: false)),
          ],
        );
      gas = _gasForPromote.toStringAsFixed(17);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  Future<void> approve() async {
    try {
      this.onLoading();
      final _period = getPeriod();
      getAmount(isQuest: false, tariff: levelGroupValue, period: _period);
      final _price = BigInt.from(double.parse(amount) * pow(10, 18));
      await AccountRepository().getClientWorkNet().approveCoin(price: _price);
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
      this.onLoading();
      final _period = getPeriod();
      await AccountRepository().getClientWorkNet().promoteUser(
        tariff: levelGroupValue - 1,
        period: _period,
      );
      this.onSuccess(true);
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
      this.onLoading();
      final _period = getPeriod(isQuest: true);
      getAmount(isQuest: true, tariff: levelGroupValue, period: _period);
      final _price = BigInt.from(double.parse(amount) * pow(10, 18));
      await AccountRepository().getClientWorkNet().approveCoin(price: _price);
      await AccountRepository().getClientWorkNet().promoteQuest(
        tariff: levelGroupValue - 1,
        period: _period,
        amount: amount,
        questAddress: _quest!.contractAddress!,
      );

      this.onSuccess(true);
    } on FormatException catch (e, trace) {
      print('raiseQuest FormatException | $e\n$trace');
      this.onError(e.message);
    } catch (e, trace) {
      print('raiseQuest | $e\n$trace');
      this.onError(e.toString());
    }
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
