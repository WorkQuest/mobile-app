import 'package:app/base_store/i_store.dart';
import 'package:app/enums.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/quests_models/responded.dart';
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

  Map<QuestsType, int> offset = {};

  @observable
  int limit = 10;

  @observable
  int status = -1;

  @observable
  ObservableMap<QuestsType, ObservableList<BaseQuestResponse>> quests =
      ObservableMap.of({});

  String myId = "";

  UserRole role = UserRole.Worker;

  List<QuestsType> questsType = [];

  void setId(String value) => myId = value;

  void setRole(UserRole value) => role = value;

  @action
  dynamic changeLists(dynamic json) async {
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
      await updateListQuest();
      sortQuests();
    } catch (e) {
      print("ERROR: $e");
    }
  }

  @action
  Future<void> setStar(BaseQuestResponse quest, bool set) async {
    try {
      this.onLoading();
      if (set)
        await _apiProvider.setStar(id: quest.id);
      else
        await _apiProvider.removeStar(id: quest.id);
      quest.star = set;
      quests.forEach((key, value) async {
        for (int i = 0; i < value.length; i++)
          if (value[i].id == quest.id) {
            quests[key]![i].star = set;
            if (set) {
              quests[QuestsType.Favorites]?.add(quest);
              value.length -= 1;
            } else
              quests[QuestsType.Favorites]
                  ?.removeWhere((element) => element.id == quest.id);
          }
      });
      sortQuests();
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future<void> updateListQuest() async {
    getQuests(QuestsType.All, role, true);
    getQuests(QuestsType.Favorites, role, true);
    getQuests(QuestsType.Active, role, true);
    if (role == UserRole.Worker) getQuests(QuestsType.Responded, role, true);
    if (role == UserRole.Worker) getQuests(QuestsType.Invited, role, true);
    if (role == UserRole.Worker) getQuests(QuestsType.Performed, role, true);
    if (role == UserRole.Employer) getQuests(QuestsType.Created, role, true);
    if (role == UserRole.Employer) getQuests(QuestsType.Completed, role, true);
  }

  @action
  void sortQuests() {
    quests.forEach((key, value) {
      quests[key]!.sort((key2, key1) {
        return key1.createdAt!.millisecondsSinceEpoch
            .compareTo(key2.createdAt!.millisecondsSinceEpoch);
      });
    });
  }

  @action
  Future<void> getQuests(
    QuestsType questType,
    UserRole role,
    bool createNewList,
  ) async {
    await Future.delayed(const Duration(milliseconds: 250));
    try {
      if (offset[questType] == null) offset[questType] = 0;
      if (quests[questType] == null) quests[questType] = ObservableList.of([]);
      if (createNewList) {
        offset[questType] = 0;
        quests[questType] = ObservableList.of([]);
      }
      if (quests[questType]!.length != offset[questType]) return;
      this.onLoading();

      if (questType == QuestsType.Favorites)
        quests[questType]!.addAll(await _apiProvider.getQuests(
          offset: offset[questType]!,
          sort: "sort[createdAt]=desc",
          starred: true,
        ));
      else {
        quests[questType]!.addAll(role == UserRole.Employer
            ? await _apiProvider.getEmployerQuests(
                offset: offset[questType]!,
                sort: "sort[createdAt]=desc",
                statuses: getStatuses(questType),
                me: true,
              )
            : await _apiProvider.getWorkerQuests(
                offset: offset[questType]!,
                sort: "sort[createdAt]=desc",
                responded: questType == QuestsType.Responded ? true : false,
                invited: questType == QuestsType.Invited ? true : false,
                statuses: getStatuses(questType),
                me: true,
              ));
      }
      offset[questType] = offset[questType]! + 10;

      this.onSuccess(true);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }

  List<int> getStatuses(QuestsType questsType) {
    switch (questsType) {
      case QuestsType.Active:
        return [-2, 3, 4];
      case QuestsType.Performed:
        return [5];
      case QuestsType.Completed:
        return [5];
      case QuestsType.Created:
        return [-1, 1, 2];
      default:
        return [];
    }
  }

  void addNewQuest(BaseQuestResponse newQuest) {
    quests[QuestsType.All]?.insert(0, newQuest);
    quests[QuestsType.Created]?.insert(0, newQuest);
  }

  void getQuestType(BaseQuestResponse quest) {
    questsType.clear();
    questsType.add(QuestsType.All);

    if (quest.star) questsType.add(QuestsType.Favorites);

    if (quest.status == -2)
      questsType.add(QuestsType.Active);
    else if (quest.status == -1) {
      questsType.add(QuestsType.Active);

      if (role == UserRole.Employer) questsType.add(QuestsType.Created);
    } else if (quest.status == 1) {
      if (quest.responded?.status == 0 && role == UserRole.Worker)
        questsType.add(QuestsType.Responded);
      else if ((quest.responded?.status == -1 || quest.invited?.status == -1) &&
          role == UserRole.Worker)
        questsType.add(QuestsType.Responded);
      else if (quest.invited?.status == 1 && role == UserRole.Worker)
        questsType.add(QuestsType.Invited);
      else if (role == UserRole.Employer) questsType.add(QuestsType.Created);
    } else if (quest.status == 2) {
      if ((quest.responded?.status == -1 || quest.invited?.status == -1) &&
          role == UserRole.Worker)
        questsType.add(QuestsType.Responded);
      else if (role == UserRole.Worker)
        questsType.add(QuestsType.Responded);
      else if (role == UserRole.Employer) questsType.add(QuestsType.Created);
    } else if (quest.status == 3) {
      if ((quest.responded?.status == -1 || quest.invited?.status == -1) &&
          role == UserRole.Worker)
        questsType.add(QuestsType.Responded);
      else
        questsType.add(QuestsType.Active);
    } else if (quest.status == 4) {
      if ((quest.responded?.status == -1 || quest.invited?.status == -1) &&
          role == UserRole.Worker)
        questsType.add(QuestsType.Responded);
      else
        questsType.add(QuestsType.Active);
    } else if (quest.status == 5) {
      if ((quest.responded?.status == -1 || quest.invited?.status == -1) &&
          role == UserRole.Worker)
        questsType.add(QuestsType.Responded);
      else if (role == UserRole.Worker)
        questsType.add(QuestsType.Performed);
      else if (role == UserRole.Employer) questsType.add(QuestsType.Completed);
    }
  }
}
