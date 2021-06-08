import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/quests_models/QuestsResponse.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'profile_me_store.g.dart';

@injectable
@singleton
class ProfileMeStore extends _ProfileMeStore with _$ProfileMeStore {
  ProfileMeStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _ProfileMeStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _ProfileMeStore(this._apiProvider);

  @observable
  List<QuestsResponse>? questsList;

  @action
  Future getProfileMe() async {
    try {
      this.onLoading();
      await _apiProvider.getProfileMe();
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
