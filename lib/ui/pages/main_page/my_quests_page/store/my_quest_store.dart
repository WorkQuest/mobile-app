import 'package:app/base_store/i_store.dart';
import 'package:app/enums.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/quests_models/Responded.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'my_quest_store.g.dart';

@singleton
class MyQuestStore extends _MyQuestStore with _$MyQuestStore {
  MyQuestStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _MyQuestStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _MyQuestStore(this._apiProvider);

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
  ObservableList<BaseQuestResponse> active = ObservableList.of([]);

  @observable
  ObservableList<BaseQuestResponse> starred = ObservableList.of([]);

  @observable
  ObservableList<BaseQuestResponse> performed = ObservableList.of([]);

  @observable
  ObservableList<BaseQuestResponse> requested = ObservableList.of([]);

  @observable
  ObservableList<Responded?> responded = ObservableList.of([]);

  @observable
  ObservableList<BaseQuestResponse> invited = ObservableList.of([]);

  @observable
  int activeLength = 0;

  @observable
  int starredLength = 0;

  @observable
  int performedLength = 0;

  @observable
  int requestedLength = 0;

  @observable
  int respondedLength = 0;

  @observable
  int invitedLength = 0;

  @observable
  List<BitmapDescriptor> iconsMarker = [];

  @observable
  BaseQuestResponse? selectQuestInfo;

  @action
  Future getQuests(String userId, UserRole role, bool createNewList) async {
    try {
      this.onLoading();
      if (createNewList) {
        this.offset = 0;
        active.clear();
        starred.clear();
        performed.clear();
        requested.clear();
        responded.clear();
        invited.clear();
      } else {
        activeLength = active.length;
        starredLength = starred.length;
        performedLength = performed.length;
        requestedLength = requested.length;
        respondedLength = responded.length;
        invitedLength = invited.length;
      }
      if (role == UserRole.Employer) {
        active.addAll(ObservableList.of(
          await _apiProvider.getEmployerQuests(
            userId: userId,
            offset: this.offset,
            statuses: [0, 1, 3, 5],
          ),
        ));

        requested.addAll(ObservableList.of(
          await _apiProvider.getEmployerQuests(
            userId: userId,
            statuses: [4],
            offset: this.offset,
          ),
        ));

        performed.addAll(ObservableList.of(
          await _apiProvider.getEmployerQuests(
            userId: userId,
            statuses: [6],
            offset: this.offset,
          ),
        ));
      } else {
        active.addAll(ObservableList.of(
          await _apiProvider.getQuests(
            offset: this.offset,
            limit: this.limit,
            performing: true,
            statuses: [1, 3, 5],
          ),
        ));

        starred.addAll(ObservableList.of(
          await _apiProvider.getQuests(
            offset: this.offset,
            limit: this.limit,
            starred: true,
          ),
        ));

        invited.addAll(ObservableList.of(
          await _apiProvider.getQuests(
            offset: this.offset,
            limit: this.limit,
            performing: true,
            statuses: [4],
          ),
        ));

        performed.addAll(ObservableList.of(
          await _apiProvider.getQuests(
            offset: this.offset,
            limit: this.limit,
            performing: true,
            statuses: [6],
          ),
        ));
      }
      this.offset += 10;
      this.onSuccess(true);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }
}
