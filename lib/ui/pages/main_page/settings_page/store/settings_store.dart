import 'package:app/http/api_provider.dart';
import 'package:injectable/injectable.dart';
import 'package:app/base_store/i_store.dart';
import 'package:mobx/mobx.dart';

part 'settings_store.g.dart';

@injectable
class SettingsPageStore extends _SettingsPageStore with _$SettingsPageStore {
  SettingsPageStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _SettingsPageStore extends IStore<bool> with Store {

  final ApiProvider apiProvider;

  _SettingsPageStore(this.apiProvider);

  @observable
  int privacy = 1;
  @observable
  int filter = 2;

  @action
  void changePrivacy(int choice) {
    privacy = choice;
  }

  @action
  void changeFilter(int choice) {
    filter = choice;
  }
}
