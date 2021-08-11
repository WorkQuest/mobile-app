import 'package:mobx/mobx.dart';

part 'quest_page_store.g.dart';

class QuestPageStore = QuestPageStoreBase with _$QuestPageStore;

abstract class QuestPageStoreBase with Store {
  @observable
  PageState selectPage = PageState.Map;

  @action
  void changePage() {
    if (selectPage == PageState.Map)
      selectPage = PageState.List;
    else
      selectPage = PageState.Map;
  }
}

enum PageState {
  Map,
  List,
}
