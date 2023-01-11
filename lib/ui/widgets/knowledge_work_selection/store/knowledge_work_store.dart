import 'package:mobx/mobx.dart';

part 'knowledge_work_store.g.dart';

class KnowledgeWorkStore = _KnowledgeWorkStore with _$KnowledgeWorkStore;

abstract class _KnowledgeWorkStore with Store {
  @observable
  ObservableList<KnowledgeWork> numberOfFiled =
      ObservableList.of([KnowledgeWork()]);

  @action
  void addField(KnowledgeWork value) {
    numberOfFiled.add(value);
  }

  @action
  void deleteField(KnowledgeWork kng) {
    numberOfFiled.remove(kng);
  }
}

class KnowledgeWork {
  String id = DateTime.now().microsecond.toString();
  String dateFrom = '';
  String dateTo = '';
  String place = '';
  KnowledgeWork({this.dateFrom = "", this.dateTo ="",this.place = ""});

  bool get fieldIsNotEmpty =>
      dateFrom.isNotEmpty && dateTo.isNotEmpty && place.isNotEmpty;
}
