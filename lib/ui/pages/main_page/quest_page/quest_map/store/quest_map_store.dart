import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'quest_map_store.g.dart';

@injectable
@singleton
class QuestMapStore extends _QuestMapStore with _$QuestMapStore {
  QuestMapStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _QuestMapStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _QuestMapStore(this._apiProvider);

  @action
  Future getQuests(String userId) async {
    try {
      this.onLoading();

      var response = await _apiProvider.mapPoints();

      print(response);
      
      this.onSuccess(true);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }
}
