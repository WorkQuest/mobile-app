import 'package:mobx/mobx.dart';

part 'start_store.g.dart';

class StartStore = _StartStore with _$StartStore;

abstract class _StartStore with Store {
  @observable
  int currentPos = 0;

  @action
  void setCurrentPos(int index) => currentPos = index;
}