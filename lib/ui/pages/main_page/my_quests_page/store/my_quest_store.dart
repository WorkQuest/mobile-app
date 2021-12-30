import 'package:app/base_store/i_store.dart';
import 'package:app/enums.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
    WebSocket().handlerQuests = this.changeQuest;
  }

  @observable
  String? sort = "";

  @observable
  int priority = -1;

  int offsetActive = 0;
  int offsetInvited = 0;
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
  ObservableList<BaseQuestResponse> requested = ObservableList.of([]);

  @observable
  ObservableList<BaseQuestResponse> invited = ObservableList.of([]);

  @observable
  ObservableList<BaseQuestResponse> allQuests = ObservableList.of([]);

  @observable
  List<BitmapDescriptor> iconsMarker = [];

  @observable
  BaseQuestResponse? selectQuestInfo;

  int activeCount = 0;

  int invitedCount = 0;

  int performedCount = 0;

  int starredCount = 0;

  bool loadActive = true;

  bool loadInvited = true;

  bool loadPerformed = true;

  bool loadStarred = true;

  void changeQuest(dynamic json) {
    print("WebSocket quests");
    var quest = BaseQuestResponse.fromJson(json);
    deleteQuest(quest);
    addQuest(quest, true);
  }

  void sortQuests() {
    active.sort((key1, key2) {
      return key1.createdAt.millisecondsSinceEpoch
          .compareTo(key2.createdAt.millisecondsSinceEpoch);
    });
    starred.sort((key1, key2) {
      return key1.createdAt.millisecondsSinceEpoch
          .compareTo(key2.createdAt.millisecondsSinceEpoch);
    });
    performed.sort((key1, key2) {
      return key1.createdAt.millisecondsSinceEpoch
          .compareTo(key2.createdAt.millisecondsSinceEpoch);
    });
    requested.sort((key1, key2) {
      return key1.createdAt.millisecondsSinceEpoch
          .compareTo(key2.createdAt.millisecondsSinceEpoch);
    });
    invited.sort((key1, key2) {
      return key1.createdAt.millisecondsSinceEpoch
          .compareTo(key2.createdAt.millisecondsSinceEpoch);
    });
  }

  @action
  deleteQuest(BaseQuestResponse quest) {
    print("delete");
    active.removeWhere((element) => element.id == quest.id);
    performed.removeWhere((element) => element.id == quest.id);
    requested.removeWhere((element) => element.id == quest.id);
    invited.removeWhere((element) => element.id == quest.id);
    starred.removeWhere((element) => element.id == quest.id);
  }

  @action
  addQuest(BaseQuestResponse quest, bool restoreStarred) {
    print("add");
    if (quest.status == 0 ||
        quest.status == 1 ||
        quest.status == 3 ||
        quest.status == 5)
      active.add(quest);
    else if (quest.status == 4) {
      invited.add(quest);
      requested.add(quest);
    } else if (quest.status == 6) performed.add(quest);
    if (restoreStarred) starred.add(quest);
    sortQuests();
  }

  @action
  Future getQuests(String userId, UserRole role, bool createNewList) async {
    try {
      this.onLoading();
      if (createNewList) {
        this.offsetActive = 0;
        this.offsetInvited = 0;
        this.offsetPerformed = 0;
        this.offsetStarred = 0;
        active = ObservableList.of([]);
        starred.clear();
        performed.clear();
        requested.clear();
        invited.clear();
        loadActive = true;
        loadInvited = true;
        loadPerformed = true;
        loadStarred = true;
      }
      if (role == UserRole.Employer) {
        final responseActive = await _apiProvider.getEmployerQuests(
          userId: userId,
          offset: this.offsetActive,
          statuses: [0, 1, 3, 5],
        );

        activeCount = responseActive["count"];

        if (activeCount > offsetActive)
          active.addAll(ObservableList.of(List<BaseQuestResponse>.from(
              responseActive["quests"]
                  .map((x) => BaseQuestResponse.fromJson(x)))));

        final responseInvited = await _apiProvider.getEmployerQuests(
          userId: userId,
          offset: this.offsetInvited,
          statuses: [4],
        );

        invitedCount = responseInvited["count"];

        if (invitedCount > offsetInvited)
          requested.addAll(ObservableList.of(List<BaseQuestResponse>.from(
              responseInvited["quests"]
                  .map((x) => BaseQuestResponse.fromJson(x)))));

        final responsePerformed = await _apiProvider.getEmployerQuests(
          userId: userId,
          offset: this.offsetPerformed,
          statuses: [6],
        );

        performedCount = responsePerformed["count"];

        if (performedCount > offsetPerformed)
          performed.addAll(ObservableList.of(List<BaseQuestResponse>.from(
              responsePerformed["quests"]
                  .map((x) => BaseQuestResponse.fromJson(x)))));

        // active.addAll(ObservableList.of(
        //   await _apiProvider.getEmployerQuests(
        //     userId: userId,
        //     offset: this.offsetActive,
        //     statuses: [0, 1, 3, 5],
        //   ),
        // // ));
        //
        // requested.addAll(ObservableList.of(
        //   await _apiProvider.getEmployerQuests(
        //     userId: userId,
        //     statuses: [4],
        //     offset: this.offsetInvited,
        //   ),
        // ));
        //
        // performed.addAll(ObservableList.of(
        //   await _apiProvider.getEmployerQuests(
        //     userId: userId,
        //     statuses: [6],
        //     offset: this.offsetPerformed,
        //   ),
        // ));
      } else {
        final responseActive = await _apiProvider.getWorkerQuests(
          offset: this.offsetActive,
          userId: userId,
          statuses: [1, 3, 5],
        );

        activeCount = responseActive["count"];

        if (loadActive)
          active.addAll(ObservableList.of(List<BaseQuestResponse>.from(
              responseActive["quests"]
                  .map((x) => BaseQuestResponse.fromJson(x)))));

        final responseInvited = await _apiProvider.getWorkerQuests(
          offset: this.offsetInvited,
          userId: userId,
          statuses: [4],
        );

        invitedCount = responseInvited["count"];

        if (loadInvited)
          invited.addAll(ObservableList.of(List<BaseQuestResponse>.from(
              responseInvited["quests"]
                  .map((x) => BaseQuestResponse.fromJson(x)))));

        final responsePerformed = await _apiProvider.getWorkerQuests(
          offset: this.offsetPerformed,
          userId: userId,
          statuses: [6],
        );

        performedCount = responsePerformed["count"];

        if (loadPerformed)
          performed.addAll(ObservableList.of(List<BaseQuestResponse>.from(
              responsePerformed["quests"]
                  .map((x) => BaseQuestResponse.fromJson(x)))));

        final responseStarred = await _apiProvider.getWorkerQuests(
          offset: this.offsetStarred,
          userId: userId,
          starred: true,
        );

        starredCount = responseStarred["count"];

        if (loadStarred)
          starred.addAll(ObservableList.of(List<BaseQuestResponse>.from(
              responseStarred["quests"]
                  .map((x) => BaseQuestResponse.fromJson(x)))));

        // active.addAll(ObservableList.of(
        //   await _apiProvider.getQuests(
        //     offset: this.offsetActive,
        //     limit: this.limit,
        //     performing: true,
        //     statuses: [1, 3, 5],
        //   ),
        // ));
        //
        // starred.addAll(ObservableList.of(
        //   await _apiProvider.getQuests(
        //     offset: this.offsetStarred,
        //     limit: this.limit,
        //     starred: true,
        //   ),
        // ));
        //
        // invited.addAll(ObservableList.of(
        //   await _apiProvider.getQuests(
        //     offset: this.offsetInvited,
        //     limit: this.limit,
        //     performing: true,
        //     statuses: [4],
        //   ),
        // ));
        //
        // performed.addAll(ObservableList.of(
        //   await _apiProvider.getQuests(
        //     offset: this.offsetPerformed,
        //     limit: this.limit,
        //     performing: true,
        //     statuses: [6],
        //   ),
        // ));
      }
      // if (offsetActive != activeCount) {
      offsetActive += 10;
      //   loadActive = true;
      // } else
      //   loadActive = false;
      // if (offsetInvited + 10 < invitedCount) {
      this.offsetInvited += 10;
      //   loadInvited = true;
      // } else
      //   loadInvited = false;
      // if (offsetPerformed + 10 < performedCount) {
      this.offsetPerformed += 10;
      //   loadPerformed = true;
      // } else
      //   loadPerformed = false;
      // if (offsetStarred + 10 < starredCount) {
      this.offsetStarred += 10;
      //   loadStarred = true;
      // } else
      //   loadStarred = false;
      this.onSuccess(true);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }
}
