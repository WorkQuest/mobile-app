import 'package:mobx/mobx.dart';

part 'quest_page_store.g.dart';

class QuestPageStore = QuestPageStoreBase with _$QuestPageStore;

abstract class QuestPageStoreBase with Store {
  @observable
  int pageIndex = 0;

  void setMapPage() => pageIndex = 0;

  void setQuestListPage() => pageIndex = 1;
}
