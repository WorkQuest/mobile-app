import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'my_quest_store.g.dart';

@injectable
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
  List<BaseQuestResponse>? all;

  @observable
  List<BaseQuestResponse>? starred;

  @observable
  List<BaseQuestResponse>? performed;

  @observable
  List<BaseQuestResponse>? invited;

  @observable
  List<BitmapDescriptor> iconsMarker = [];

  @observable
  BaseQuestResponse? selectQuestInfo;

  @action
  Future getQuests(String userId) async {
    try {
      this.onLoading();

      all = await _apiProvider.getEmployerQuests(userId);

      starred = await _apiProvider.getEmployerQuests(
        userId,
        offset: this.offset,
        limit: this.limit,
        status: this.status,
        invited: false,
        performing: false,
        priority: this.priority,
        sort: this.sort,
        starred: true,
      );

      invited = await _apiProvider.getEmployerQuests(
        userId,
        offset: this.offset,
        limit: this.limit,
        status: this.status,
        invited: true,
        performing: false,
        priority: this.priority,
        sort: this.sort,
        starred: false,
      );

      performed = await _apiProvider.getEmployerQuests(
        userId,
        offset: this.offset,
        limit: this.limit,
        status: this.status,
        invited: false,
        performing: true,
        priority: this.priority,
        sort: this.sort,
        starred: false,
      );
      print(all);
      print(starred);
      print(performed);
      print(invited);
      this.onSuccess(true);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }
}