import 'package:app/http/api_provider.dart';
import 'package:injectable/injectable.dart';
import 'package:app/base_store/i_store.dart';
import 'package:mobx/mobx.dart';

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
  int periodGroupValue = 1;
  @observable
  int levelGroupValue = 1;

  @action
  void changePeriod(int? value) => periodGroupValue = value!;

  @action
  void changeLevel(int? value) => levelGroupValue = value!;

  // @computed
  // bool get canSubmit =>
  //     !isLoading && _recipientAddress.isNotEmpty && _amount.isNotEmpty;
}
