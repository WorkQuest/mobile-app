import 'package:app/base_store/i_store.dart';
import 'package:app/enums.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/quests_models/Responded.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/utils/web_socket.dart';

part 'my_quest_store.g.dart';

@singleton
class MyQuestStore extends _MyQuestStore with _$MyQuestStore {
  MyQuestStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _MyQuestStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _MyQuestStore(this._apiProvider) {
    WebSocket().handlerQuestList = this.changeLists;
  }

  @observable
  String sort = "sort[createdAt]=desc";

  @observable
  int priority = -1;

  int offsetActive = 0;
  int offsetInvited = 0;
  int offsetResponded = 0;
  int offsetPerformed = 0;
  int offsetStarred = 0;

  @observable
  int limit = 10;

  @observable
  int status = -1;

  @observable
  ObservableList<BaseQuestResponse> active = ObservableList.of([]);

  @observable
  ObservableList<BaseQuestResponse> starred = ObservableList.of([]);

  @observable
  ObservableList<BaseQuestResponse> performed = ObservableList.of([]);

  @observable
  ObservableList<BaseQuestResponse> invited = ObservableList.of([]);

  List<BaseQuestResponse> allQuests = [];

  bool loadActive = true;

  bool loadInvited = true;

  bool loadResponded = true;

  bool loadPerformed = true;

  bool loadStarred = true;

  String myId = "";

  UserRole role = UserRole.Worker;

  void setId(String value) => myId = value;

  void setRole(UserRole value) => role = value;

  @action
  void changeLists(dynamic json) async {
    try {
      print("MyQuestStore");
      var quest =
          BaseQuestResponse.fromJson(json["data"]["quest"] ?? json["data"]);
      (json["recipients"] as List).forEach((element) {
        if (element == myId)
          quest.responded = Responded(
            id: "",
            workerId: myId,
            questId: quest.id,
            status: 0,
            type: 0,
            message: "message",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
      });
      addAllQuests();
      for (int i = 0; i < allQuests.length; i++)
        if (allQuests[i].status == quest.status &&
            allQuests[i].id == quest.id &&
            quest.status == 1) {
          return;
        }
      deleteQuest(quest.id);
      addQuest(quest, quest.star);
    } catch (e) {
      print("ERROR: $e");
    }
  }

  void addAllQuests() {
    allQuests.addAll(active);
    allQuests.addAll(performed);
    allQuests.addAll(invited);
    allQuests.addAll(starred);
  }

  void sortQuests() {
    active.sort((key2, key1) {
      return key1.createdAt.millisecondsSinceEpoch
          .compareTo(key2.createdAt.millisecondsSinceEpoch);
    });
    starred.sort((key2, key1) {
      return key1.createdAt.millisecondsSinceEpoch
          .compareTo(key2.createdAt.millisecondsSinceEpoch);
    });
    performed.sort((key2, key1) {
      return key1.createdAt.millisecondsSinceEpoch
          .compareTo(key2.createdAt.millisecondsSinceEpoch);
    });
    invited.sort((key2, key1) {
      return key1.createdAt.millisecondsSinceEpoch
          .compareTo(key2.createdAt.millisecondsSinceEpoch);
    });
  }

  @action
  deleteQuest(String id) {
    active.removeWhere((element) => element.id == id);
    performed.removeWhere((element) => element.id == id);
    invited.removeWhere((element) => element.id == id);
    starred.removeWhere((element) => element.id == id);
  }

  @action
  addQuest(BaseQuestResponse quest, bool restoreStarred) {
    if (quest.status == 0 ||
        quest.status == 1 ||
        quest.status == 3 ||
        quest.status == 4)
      active.add(quest);
    else if (quest.status == 2) {
      invited.add(quest);
    } else if (quest.status == 5) performed.add(quest);
    if (restoreStarred) starred.add(quest);
    sortQuests();
  }

  @action
  setStar(BaseQuestResponse quest, bool set) {
    active.forEach((element) {
      if (element.id == quest.id) if (set)
        quest.star = true;
      else
        quest.star = false;
    });
    performed.forEach((element) {
      if (element.id == quest.id) if (set)
        quest.star = true;
      else
        quest.star = false;
    });
    invited.forEach((element) {
      if (element.id == quest.id) if (set)
        quest.star = true;
      else
        quest.star = false;
    });
    if (set)
      starred.add(quest);
    else
      starred.removeWhere((element) => element.id == quest.id);
    sortQuests();
  }

  void removeDuplicate() {
    for (int i = 0; i < invited.length; i++) {
      for (int j = 1; j < invited.length; j++)
        if (invited[i].id == invited[j].id) invited.removeAt(j);
    }
  }

  @action
  Future getQuests(String userId, UserRole role, bool createNewList) async {
    await Future.delayed(const Duration(milliseconds: 250));
    try {
      this.onLoading();
      if (createNewList) {
        this.offsetActive = 0;
        this.offsetInvited = 0;
        this.offsetResponded = 0;
        this.offsetPerformed = 0;
        this.offsetStarred = 0;

        active = ObservableList.of([]);
        invited = ObservableList.of([]);
        performed = ObservableList.of([]);
        starred = ObservableList.of([]);
        allQuests = [];

        loadActive = true;
        loadInvited = true;
        loadResponded = true;
        loadPerformed = true;
        loadStarred = true;
      }

      if (role == UserRole.Employer) {
        if (loadActive)
          active.addAll(await _apiProvider.getEmployerQuests(
            sort: sort,
            offset: this.offsetActive,
            statuses: [0, 1, 3, 4],
            invited: false,
            me: true,
          ));

        if (loadInvited)
          invited.addAll(await _apiProvider.getEmployerQuests(
            sort: sort,
            offset: this.offsetInvited,
            // statuses: [2],
            invited: true,
            me: true,
          ));

        if (loadResponded)
          invited.addAll(await _apiProvider.getEmployerQuests(
            sort: sort,
            offset: this.offsetResponded,
            statuses: [2],
            // invited: true,
            me: true,
          ));

        if (loadPerformed) {
          performed.addAll(await _apiProvider.getEmployerQuests(
            sort: sort,
            offset: this.offsetPerformed,
            statuses: [5],
            invited: false,
            me: true,
          ));
        }
      } else {
        if (loadActive)
          active.addAll(await _apiProvider.getWorkerQuests(
            offset: this.offsetActive,
            sort: sort,
            statuses: [3, 4],
            me: true,
          ));

        if (loadInvited)
          invited.addAll(await _apiProvider.getWorkerQuests(
            offset: this.offsetInvited,
            sort: sort,
            statuses: [2],
            // invited: true,
            me: true,
          ));

        if (loadResponded)
          invited.addAll(await _apiProvider.getWorkerQuests(
            sort: sort,
            offset: this.offsetResponded,
            statuses: [2],
            // invited: true,
            me: true,
          ));

        if (loadPerformed)
          performed.addAll(await _apiProvider.getWorkerQuests(
            offset: this.offsetPerformed,
            sort: sort,
            statuses: [5],
            me: true,
          ));

        if (loadStarred)
          starred.addAll(await _apiProvider.getQuests(
            offset: this.offsetStarred,
            sort: sort,
            starred: true,
          ));
      }

      removeDuplicate();

      if (active.length % 10 == 0 && active.length != 0)
        offsetActive += 10;
      else
        loadActive = false;

      if (invited.length == (offsetActive + offsetResponded)) {
        this.offsetInvited += 10;
        this.offsetResponded += 10;
      } else {
        loadInvited = false;
        loadResponded = false;
      }

      if (performed.length % 10 == 0 && performed.length != 0)
        this.offsetPerformed += 10;
      else
        loadPerformed = false;

      if (starred.length % 10 == 0 && starred.length != 0)
        this.offsetStarred += 10;
      else
        loadStarred = false;

      this.onSuccess(true);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }
}
