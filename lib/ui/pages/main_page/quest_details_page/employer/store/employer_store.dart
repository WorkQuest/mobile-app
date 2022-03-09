import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
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
  List<RespondModel> respondedList = [];

  @observable
  RespondModel? selectedResponders;

  @observable
  bool isValid = false;

  @observable
  String totp = "";

  Observable<BaseQuestResponse?> quest = Observable(null);

  @action
  setTotp(String value) => totp = value;

  @action
  getRespondedList(String id, String idWorker) async {
    respondedList = await _apiProvider.responsesQuest(id);
    for (int index = 0; index < respondedList.length; index++)
      if (respondedList[index].workerId == idWorker ||
          respondedList[index].status == -1 ||
          respondedList[index].status == 0 ||
          (respondedList[index].type == 1 && respondedList[index].status != 1))
        respondedList.removeAt(index);
  }

  _getQuest() async {
    final newQuest = await _apiProvider.getQuest(id: quest.value!.id);
    quest.value!.update(newQuest);
    quest.reportChanged();
  }

  @action
  startQuest({
    required String questId,
    required String userId,
  }) async {
    try {
      this.onLoading();
      await _apiProvider.startQuest(questId: questId, userId: userId);
      // ClientService().handleEvent(
      //   WQContractFunctions.assignJob,
      //   [EthereumAddress.fromHex("0xc1203cd24b9ab6f942261e0d74729bbfdf36eb89")],
      // );
      await _getQuest();
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
      // ClientService().handleEvent(WQContractFunctions.acceptJobResult);
      await _getQuest();
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
      await _getQuest();
      // ClientService().handleEvent(WQContractFunctions.cancelJob);
      this.onSuccess(true);
    } catch (e, trace) {
      print("accept error: $e\n$trace");
      this.onError(e.toString());
    }
  }

  @action
  Future<void> validateTotp() async {
    try {
      this.onLoading();
      isValid = await _apiProvider.validateTotp(totp: totp);
      if (isValid == false) {
        this.onError("Invalid TOTP");
        return;
      }
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
