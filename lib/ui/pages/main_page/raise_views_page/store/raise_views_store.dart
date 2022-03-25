import 'package:app/http/api_provider.dart';
import 'package:injectable/injectable.dart';
import 'package:app/base_store/i_store.dart';
import 'package:mobx/mobx.dart';

import '../../../../../web3/contractEnums.dart';

part 'raise_views_store.g.dart';

@injectable
@singleton
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

  int typeValue = 4;

  Map<int, List<String>> price = {};

  List<String> forDay = [r"20$", r"12$", r"9$", r"7$"];
  List<String> forWeek = [r"35$", r"28$", r"22$", r"18$"];
  List<String> forMonth = [r"50$", r"35$", r"29$", r"21$"];

  @action
  setTitleSelectedCoin(TYPE_COINS? value) => typeCoin = value;

  @action
  setTitleSelectedWallet(TYPE_WALLET? value) => typeWallet = value;

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
        return periodValue = 31;
    }
    return periodValue;
  }

  @action
  void changePeriod(int? value) => periodGroupValue = value!;

  @action
  void changeLevel(int? value) => levelGroupValue = value!;

  @computed
  bool get canSubmit => !isLoading && typeCoin != null && typeWallet != null;

  Future<void> raiseProfile() async {
    try {
      this.onLoading();
      await apiProvider.raiseProfile(
          duration: getPeriod(), type: levelGroupValue - 1);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

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
}
