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
    } catch (e) {
      print("ERROR: $e");
    }
  }

  @action
  Future<void> setStar(BaseQuestResponse quest, bool set) async {
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
            quests[QuestsType.Favorites]!.sort();
          } else
            quests[QuestsType.Favorites]?.remove(quest);
        }
    });
  }

  @action
  void updateQuests(BaseQuestResponse quest) {
    quests.forEach((key, value) {
      for (int i = 0; i < value.length; i++)
        if (value[i].id == quest.id) {
          quests[key]!.remove(value[i]);
          quests[key]!.add(quest);
        }
    });
    sortQuests();
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
      case QuestsType.Created:
        return [-1, 1, 2];
      default:
        return [];
    }
  }
}
