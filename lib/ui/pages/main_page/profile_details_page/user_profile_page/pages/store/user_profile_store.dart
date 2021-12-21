import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/ui/pages/main_page/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/portfolio_page/store/portfolio_store.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';

part 'user_profile_store.g.dart';

@singleton
class UserProfileStore extends _UserProfileStore with _$UserProfileStore {
  UserProfileStore(ApiProvider apiProvider, MyQuestStore questStore,
      PortfolioStore portfolioStore)
      : super(
          apiProvider,
          questStore,
          portfolioStore,
        );
}

abstract class _UserProfileStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;
  final MyQuestStore _questStore;
  final PortfolioStore _portfolioStore;

  _UserProfileStore(
    this._apiProvider,
    this._questStore,
    this._portfolioStore,
  ){
    _initStore();
  }

  ProfileMeResponse? userData;
  ProfileMeResponse? questHolder;

  void _initStore(){

  }
}
