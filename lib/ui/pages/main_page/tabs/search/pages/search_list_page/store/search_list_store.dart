import 'dart:async';
import 'dart:convert';

import 'package:app/base_store/i_store.dart';
import 'package:app/enums.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/notification_model.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/repository/search_repository.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/search_list_page/entity/filter_arguments.dart';
import 'package:app/utils/push_notification/open_scree_from_push.dart';
import 'package:app/utils/storage.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'search_list_store.g.dart';

@singleton
class SearchListStore extends _SearchListStore with _$SearchListStore {
  SearchListStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _SearchListStore extends IStore<bool> with Store {
  final ISearchRepository _repository;

  _SearchListStore(ApiProvider apiProvider) : _repository = SearchRepository(apiProvider);

  FilterArguments filters = FilterArguments.empty();

  @observable
  bool isLoadingMore = false;

  @observable
  String searchWord = "";

  @observable
  ObservableList<BaseQuestResponse> questsList = ObservableList.of([]);

  @observable
  ObservableList<ProfileMeResponse> workersList = ObservableList.of([]);

  Timer? debounce;

  @computed
  bool get emptySearch => workersList.isEmpty && questsList.isEmpty && !this.isLoading;

  @action
  search({
    required UserRole role,
    String searchLine = '',
    bool isForce = true,
  }) {
    try {
      searchWord = searchLine.trim();
      if (isForce) {
        onLoading();
        role == UserRole.Worker ? questsList.clear() : workersList.clear();
      } else {
        isLoadingMore = true;
      }
      if (debounce != null) {
        debounce!.cancel();
      }
      debounce = Timer(const Duration(milliseconds: 300), () async {
        if (role == UserRole.Worker) {
          final result = await _repository.getQuests(
            filters: filters,
            role: role,
            offset: questsList.length,
            searchWord: searchWord,
          );
          questsList.addAll(result);
        } else {
          final result = await _repository.getWorkers(
            filters: filters,
            role: role,
            offset: questsList.length,
            searchWord: searchWord,
          );
          workersList.addAll(result);
        }
        this.onSuccess(true);
        isLoadingMore = false;
      });
    } catch (e) {
      onError(e.toString());
      isLoadingMore = false;
    }

  }

  @action
  setStar(String questId, bool star) {
    final index = questsList.indexWhere((element) => element.id == questId);
    if (index != -1) {
      final old = questsList.removeAt(index);
      old.star = star;
      questsList.insert(index, old);
    }
  }

  checkPush() async {
    final payload = await Storage.readPushPayload();
    if (payload != null) {
      final response = jsonDecode(payload);
      final notification = NotificationNotification.fromJson(response);
      OpenScreeFromPush().openScreen(notification);
      Storage.delete("pushPayload");
    }
  }

  @action
  clearData() {
    isLoadingMore = false;
    searchWord = "";
    questsList.clear();
    workersList.clear();
    debounce = null;
  }
}
