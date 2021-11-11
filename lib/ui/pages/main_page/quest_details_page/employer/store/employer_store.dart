import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/respond_model.dart';

import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'employer_store.g.dart';

@injectable
class EmployerStore extends _EmployerStore with _$EmployerStore {
  EmployerStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _EmployerStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _EmployerStore(this._apiProvider);

  @observable
  List<RespondModel>? respondedList;

  @observable
  String selectedResponders = "";

  @action
  getRespondedList(String id, String idWorker) async {
    respondedList = await _apiProvider.responsesQuest(id);
    if (respondedList != null)
      for (int index = 0; index < (respondedList?.length ?? 0); index++)
        if (respondedList![index].workerId== idWorker)
          respondedList!.removeAt(index);
  }

  @action
  startQuest({
    required String questId,
    required String userId,
  }) async {
    try {
      this.onLoading();
      await _apiProvider.startQuest(questId: questId, userId: userId);
      this.onSuccess(true);
    } catch (e, trace) {
      print("accept error: $e\n$trace");
      this.onError(e.toString());
    }
  }

  @action
  acceptCompletedWork({
    required String questId,
  }) async {
    try {
      this.onLoading();
      await _apiProvider.acceptCompletedWork(questId: questId);
      this.onSuccess(true);
    } catch (e, trace) {
      print("accept error: $e\n$trace");
      this.onError(e.toString());
    }
  }

  @action
  rejectCompletedWork({
    required String questId,
  }) async {
    try {
      this.onLoading();
      await _apiProvider.rejectCompletedWork(questId: questId);
      this.onSuccess(true);
    } catch (e, trace) {
      print("accept error: $e\n$trace");
      this.onError(e.toString());
    }
  }

  @action
  deleteQuest({
    required String questId,
  }) async {
    try {
      this.onLoading();
      await _apiProvider.deleteQuest(questId: questId);
      this.onSuccess(true);
    } catch (e, trace) {
      print("accept error: $e\n$trace");
      this.onError(e.toString());
    }
  }
}
