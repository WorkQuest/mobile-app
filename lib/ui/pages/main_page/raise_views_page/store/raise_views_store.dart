import 'package:app/http/api_provider.dart';
import 'package:injectable/injectable.dart';
import 'package:app/base_store/i_store.dart';
import 'package:mobx/mobx.dart';

import '../../../../../web3/contractEnums.dart';
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
  TYPE_COINS? typeCoin;

  @observable
  TYPE_WALLET? typeWallet;

  @observable
  int periodGroupValue = 1;

  @observable
  int levelGroupValue = 1;

  int periodValue = 0;

  Map<int, List<String>> price = {};

  List<String> forDay = [r"20$", r"12$", r"9$", r"7$"];
  List<String> forWeek = [r"35$", r"28$", r"22$", r"18$"];
  List<String> forMonth = [r"50$", r"35$", r"29$", r"21$"];

  @action
  setTitleSelectedCoin(TYPE_COINS? value) => typeCoin = value;

  @action
  setTitleSelectedWallet(TYPE_WALLET? value) => typeWallet = value;

  @action
  void initPrice() {
    price[1] = forDay;
    price[2] = forWeek;
    price[3] = forMonth;
  }

  int getPeriod() {
    switch (periodGroupValue) {
      case 1:
        return periodValue = 1;
      case 2:
        return periodValue = 7;
      case 3:
        return periodValue = 30;
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

  @action
  Future<void> raiseProfile() async {
    try {
      this.onLoading();
      final _period = getPeriod();
      print('levelGroupValue: $levelGroupValue | period: ${getPeriod()}');
      // await apiProvider.raiseProfile(
      //     duration: getPeriod(), type: levelGroupValue - 1);
      // await ClientService().promoteUser(
      //   tariff: levelGroupValue,
      //   period: _period,
      //   amount: _getAmount(
      //     isQuest: false,
      //     tariff: levelGroupValue,
      //     period: _period,
      //   ),
      // );
      this.onSuccess(true);
    } catch (e, trace) {
      print('e: $e\ntrace: $trace');
      this.onError(e.toString());
    }
  }

  @action
  Future<void> raiseQuest(String questId) async {
    try {
      this.onLoading();
      await apiProvider.raiseQuest(
          questId: questId, duration: getPeriod(), type: levelGroupValue - 1);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  String _getAmount({
    required bool isQuest,
    required int tariff,
    required int period,
  }) {
    if (isQuest) {
      switch (period) {
        case 1:
          break;
        case 5:
          break;
        case 7:
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
