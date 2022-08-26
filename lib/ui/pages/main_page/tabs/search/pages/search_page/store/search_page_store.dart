import 'package:mobx/mobx.dart';

part 'search_page_store.g.dart';

class SearchPageStore = SearchPageStoreBase with _$SearchPageStore;

abstract class SearchPageStoreBase with Store {
  @observable
  int pageIndex = 0;

  void setMapPage() => pageIndex = 0;

  void setQuestListPage() => pageIndex = 1;
}
