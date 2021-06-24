import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'my_quests_store.g.dart';


@injectable
class MyQuestStore extends _MyQuestStore with _$MyQuestStore {
  MyQuestStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _MyQuestStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

   _MyQuestStore(this._apiProvider);

  @observable
  List<BaseQuestResponse>? questList;

  @observable
  String? searchWord;

  @observable
  int priority = -1;

  @observable
  int status = -1;

  @action
  Future list() async {
    try {
      this.onLoading();
      questList = await _apiProvider.getQuests();
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
