import 'package:app/base_store/i_store.dart';
import 'package:app/di/injector.dart';
import 'package:app/enums.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/repository/my_quest_repository.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/http/web_socket.dart';

part 'my_quest_store.g.dart';

@singleton
class MyQuestStore extends _MyQuestStore with _$MyQuestStore {
  MyQuestStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _MyQuestStore extends IStore<MyQuestStoreState> with Store {
  final IMyQuestRepository _repository;

  _MyQuestStore(ApiProvider apiProvider)
      : _repository = MyQuestRepository(apiProvider) {
    WebSocket().handlerQuestList = this.changeLists;
  }

  @observable
  ObservableMap<QuestsType, ObservableList<BaseQuestResponse>> quests =
      ObservableMap.of({});

  String get myId => getIt.get<ProfileMeStore>().userData?.id ?? '';

  UserRole get role =>
      getIt.get<ProfileMeStore>().userData?.role ?? UserRole.Worker;

  @action
  dynamic changeLists(dynamic json) async {
    try {
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
      await _repository.setStar(quest, set);
      quest.star = set;
      quests.forEach((key, value) async {
        for (int i = 0; i < value.length; i++)
          if (value[i].id == quest.id) {
            quests[key]![i].star = set;
          }
      });
      if (set) {
        quests[QuestsType.Favorites]?.add(quest);
      } else {
        quests[QuestsType.Favorites]
            ?.removeWhere((element) => element.id == quest.id);
      }
      sortQuests();
      this.onSuccess(MyQuestStoreState.setStar);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future<void> updateListQuest() async {
    getQuests(questType: QuestsType.All);
    getQuests(questType: QuestsType.Favorites);
    getQuests(questType: QuestsType.Active);
    if (role == UserRole.Worker) getQuests(questType: QuestsType.Responded);
    if (role == UserRole.Worker) getQuests(questType: QuestsType.Invited);
    if (role == UserRole.Worker) getQuests(questType: QuestsType.Performed);
    if (role == UserRole.Employer) getQuests(questType: QuestsType.Created);
    if (role == UserRole.Employer) getQuests(questType: QuestsType.Completed);
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
  Future<void> getQuests({
    required QuestsType questType,
    bool isForce = true,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));
    try {
      if (quests[questType] == null) quests[questType] = ObservableList.of([]);
      if (isForce) {
        quests[questType] = ObservableList.of([]);
      }
      this.onLoading();

      if (questType == QuestsType.Favorites) {
        final result = await _repository.getFavoritesQuests(
            offset: quests[questType]!.length);
        quests[questType]!.addAll(result);
      } else if (role == UserRole.Employer) {
        final result = await _repository.getEmployerQuests(
          statuses: getStatuses(questType),
          offset: quests[questType]!.length,
        );
        quests[questType]!.addAll(result);
      } else {
        final result = await _repository.getWorkerQuests(
          statuses: getStatuses(questType),
          isResponded: questType == QuestsType.Responded ? true : false,
          isInvited: questType == QuestsType.Invited ? true : false,
        );
        quests[questType]!.addAll(result);
      }

      this.onSuccess(MyQuestStoreState.getQuests);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }

  @action
  deleteQuestFromList(QuestsType questsType, String id) {
    quests[questsType]!.removeWhere((quest) => quest.id == id);
    sortQuests();
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

  @action
  clearData() {
    quests = ObservableMap.of({});
  }
}

enum MyQuestStoreState { getQuests, setStar }
