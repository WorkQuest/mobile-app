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
  String? searchWord = "";

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
  List<BaseQuestResponse>? starredQuestsList;

  @observable
  List<BaseQuestResponse>? performedQuestsList;

  @observable
  List<BaseQuestResponse>? invitedQuestsList;

  @observable
  _MapList mapListChecker = _MapList.Map;

  @action
  changeValue() {
    if (mapListChecker == _MapList.Map) {
      mapListChecker = _MapList.List;
    } else {
      mapListChecker = _MapList.Map;
    }
  }

  @action
  isMapOpened() {
    return mapListChecker == _MapList.Map;
  }

  @action
  Future getQuests(/*{
    required bool invited,
    required performing,
    required bool starred,
  }*/) async {
    try {
      this.onLoading();
      questsList = await _apiProvider.getQuests(
        offset: this.offset,
        limit: this.limit,
        status: this.status,
        invited: false,
        performing: false,
        priority: this.priority,
        searchWord: this.searchWord,
        sort: this.sort,
        starred: false,
      );

      starredQuestsList = await _apiProvider.getQuests(
        offset: this.offset,
        limit: this.limit,
        status: this.status,
        invited: false,
        performing: false,
        priority: this.priority,
        searchWord: this.searchWord,
        sort: this.sort,
        starred: true,
      );

      invitedQuestsList = await _apiProvider.getQuests(
        offset: this.offset,
        limit: this.limit,
        status: this.status,
        invited: true,
        performing: false,
        priority: this.priority,
        searchWord: this.searchWord,
        sort: this.sort,
        starred: false,
      );

      performedQuestsList = await _apiProvider.getQuests(
        offset: this.offset,
        limit: this.limit,
        status: this.status,
        invited: false,
        performing: true,
        priority: this.priority,
        searchWord: this.searchWord,
        sort: this.sort,
        starred: false,
      );
      print(questsList);
      print(starredQuestsList);
      print(performedQuestsList);
      print(invitedQuestsList);
      this.onSuccess(true);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }
}

enum _MapList {
  Map,
  List,
}
