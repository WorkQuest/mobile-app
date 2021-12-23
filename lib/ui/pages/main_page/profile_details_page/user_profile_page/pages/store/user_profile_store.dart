import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import '../../../../../../../enums.dart';

part 'user_profile_store.g.dart';

@singleton
class UserProfileStore extends _UserProfileStore with _$UserProfileStore {

  UserProfileStore(ApiProvider apiProvider,)
      : super(apiProvider, );
}

abstract class _UserProfileStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;
  ProfileMeResponse? userData;
  ProfileMeResponse? questHolder;

  @observable
  ObservableList<BaseQuestResponse> userQuest = ObservableList.of([]);

  _UserProfileStore(
    this._apiProvider,
  ) ;

  Future<void> getQuests(
    String userId,
    UserRole role,
  ) async {
    try {
      this.onLoading();
      //TODO:offset scroll
      if (role == UserRole.Employer) {
        final quests = await _apiProvider.getEmployerQuests(
          userId: userId,
          offset: 10,
          statuses: [6],
        );
        userQuest.addAll(ObservableList.of(List<BaseQuestResponse>.from(
            quests["quests"].map((x) => BaseQuestResponse.fromJson(x)))));
      }
      this.onSuccess(true);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }
}
