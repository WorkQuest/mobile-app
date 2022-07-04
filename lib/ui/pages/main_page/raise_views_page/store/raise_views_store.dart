import 'dart:io';
import 'dart:math';

import 'package:app/constants.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:injectable/injectable.dart';
import 'package:app/base_store/i_store.dart';
import 'package:mobx/mobx.dart';
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

  Map<int, List<String>> price = {};

  List<String> forDay = [r"20$", r"12$", r"9$", r"7$"];
  List<String> forWeek = [r"35$", r"28$", r"22$", r"18$"];
  List<String> forMonth = [r"50$", r"35$", r"29$", r"21$"];

  setQuestId(String value) => questId = value;

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
  changePeriod(int? value) {
    print('changePeriod - $value');
    periodGroupValue = value!;
  }

  @action
  changeLevel(int? value) {
    print('changeLevel - $value');
    levelGroupValue = value!;
  }

  @computed
  bool get canSubmit => !isLoading && typeCoin != null && typeWallet != null;

  Future<String> getFee({bool isQuestRaise = false}) async {
    try {
      final _client = AccountRepository().getClientWorkNet();
      String _addressWUSD = '';
      if (AccountRepository().notifierNetwork.value == Network.mainnet) {
        _addressWUSD = '0x4d9F307F1fa63abC943b5db2CBa1c71D02d86AAa';
      } else {
        _addressWUSD = '0xf95ef11d0af1f40995218bb2b67ef909bcf30078';
      }
      final _contractApprove = await _client.getDeployedContract("WQBridgeToken", _addressWUSD);
      if (isQuestRaise) {
        final _amount = getAmount(isQuest: true, tariff: levelGroupValue, period: getPeriod(isQuest: true));
        final _price = BigInt.from(double.parse(_amount) * pow(10, 18));
        final _gasForApprove = await _client.getEstimateGasCallContract(
          contract: _contractApprove,
          function: _contractApprove.function(WQBridgeTokenFunctions.approve.name),
          params: [
            EthereumAddress.fromHex(Web3Utils.getAddressWorknetWQFactory()),
            _price,
          ],
        );

        final _contractPromote = await _client.getDeployedContract("WQPromotion", Web3Utils.getAddressWorknetWQPromotion());
        final _quest = await apiProvider.getQuest(id: questId);
        final _gasForPromote = await _client.getEstimateGasCallContract(
          contract: _contractPromote,
          function: _contractPromote.function(WQPromotionFunctions.promoteQuest.name),
          params: [
            EthereumAddress.fromHex(_quest.contractAddress!),
            BigInt.from(levelGroupValue - 1),
            BigInt.from(getPeriod(isQuest: true)),
          ],
        );
        return (_gasForApprove + _gasForPromote).toStringAsFixed(17);
      } else {
        final _amount = getAmount(isQuest: false, tariff: levelGroupValue, period: getPeriod(isQuest: false));
        final _price = BigInt.from(double.parse(_amount) * pow(10, 18));
        final _gasForApprove = await _client.getEstimateGasCallContract(
          contract: _contractApprove,
          function: _contractApprove.function(WQBridgeTokenFunctions.approve.name),
          params: [
            EthereumAddress.fromHex(Web3Utils.getAddressWorknetWQFactory()),
            _price,
          ],
        );

        final _contractPromote =
            await _client.getDeployedContract("WQPromotion", Web3Utils.getAddressWorknetWQPromotion());
        final _gasForPromote = await _client.getEstimateGasCallContract(
          contract: _contractPromote,
          function: _contractPromote.function(WQPromotionFunctions.promoteUser.name),
          params: [
            BigInt.from(levelGroupValue - 1),
            BigInt.from(getPeriod(isQuest: false)),
          ],
        );
        return (_gasForApprove + _gasForPromote).toStringAsFixed(17);
      }
    } on SocketException catch (_) {
      onError("Lost connection to server");
      throw FormatException('Lost connection to server');
    }
  }

  @action
  Future<void> raiseProfile() async {
    try {
      this.onLoading();
      final _period = getPeriod();
      print('levelGroupValue: $levelGroupValue | period: ${getPeriod()}');
      final _amount = getAmount(isQuest: false, tariff: levelGroupValue, period: _period);
      final _price = BigInt.from(double.parse(_amount) * pow(10, 18));
      await AccountRepository().getClientWorkNet().approveCoin(price: _price);
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
      final _quest = await apiProvider.getQuest(id: questId);
      final _period = getPeriod(isQuest: true);
      final _amount = getAmount(isQuest: true, tariff: levelGroupValue, period: _period);
      final _price = BigInt.from(double.parse(_amount) * pow(10, 18));
      await AccountRepository().getClientWorkNet().approveCoin(price: _price);
      await AccountRepository().getClientWorkNet().promoteQuest(
            tariff: levelGroupValue - 1,
            period: _period,
            amount: _amount,
            questAddress: _quest.contractAddress!,
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

  String getAmount({
    required bool isQuest,
    required int tariff,
    required int period,
  }) {
    if (isQuest) {
      switch (period) {
        case 1:
          switch (tariff) {
            case 1:
              return '20';
            case 2:
              return '12';
            case 3:
              return '9';
            case 4:
              return '7';
          }
          break;
        case 5:
          switch (tariff) {
            case 1:
              return '35';
            case 2:
              return '28';
            case 3:
              return '22';
            case 4:
              return '18';
          }
          break;
        case 7:
          switch (tariff) {
            case 1:
              return '50';
            case 2:
              return '35';
            case 3:
              return '29';
            case 4:
              return '21';
          }
          break;
      }
    } else {
      switch (period) {
        case 1:
          switch (tariff) {
            case 1:
              return '20';
            case 2:
              return '12';
            case 3:
              return '9';
            case 4:
              return '7';
          }
          break;
        case 7:
          switch (tariff) {
            case 1:
              return '35';
            case 2:
              return '28';
            case 3:
              return '22';
            case 4:
              return '18';
          }
          break;
        case 30:
          switch (tariff) {
            case 1:
              return '50';
            case 2:
              return '35';
            case 3:
              return '29';
            case 4:
              return '21';
          }
          break;
      }
    }
    return '0';
  }
}
