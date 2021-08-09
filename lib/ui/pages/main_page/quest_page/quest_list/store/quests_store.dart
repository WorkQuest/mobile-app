import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'quests_store.g.dart';

@injectable
@singleton
class QuestsStore extends _QuestsStore with _$QuestsStore {
  QuestsStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _QuestsStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _QuestsStore(this._apiProvider);

  @observable
  String searchWord = "";

  @observable
  String? sort = "";

  @observable
  int priority = -1;

  @observable
  int offset = 0;

  @observable
  int limit = 10;

  @observable
  int status = -1;

  @observable
  List<BaseQuestResponse>? questsList;

  @observable
  List<BaseQuestResponse>? searchResultList = [];
  

  @action
  void setSearchWord(String value) {
    searchWord = value;
    getSearchedQuests();
  }

  @action
  Future getSearchedQuests() async {
    searchResultList = await _apiProvider.getQuests(
      status: this.status,
      invited: false,
      performing: false,
      priority: this.priority,
      searchWord: this.searchWord,
      sort: this.sort,
      starred: false,
    );
    print(" list search $searchWord");
    print(" list search $searchResultList");
  }

  @action
  Future getQuests(String userId) async {
    try {
      this.onLoading();
      final loadQuestsList = await _apiProvider.getQuests(
        offset: this.offset,
        limit: this.limit,
        status: this.status,
        invited: false,
        performing: false,
        priority: this.priority,
        sort: this.sort,
        starred: false,
      );
      if (questsList != null) {
        this.questsList = [...this.questsList!, ...loadQuestsList];
        this.offset += 10;
      } else {
        questsList = loadQuestsList;
         this.offset += 10;
      }
      this.onSuccess(true);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }
}