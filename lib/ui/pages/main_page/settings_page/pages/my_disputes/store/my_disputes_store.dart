import 'package:app/http/api_provider.dart';
import 'package:app/base_store/i_store.dart';
import 'package:app/model/dispute_model.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'my_disputes_store.g.dart';

@injectable
class MyDisputesStore extends _MyDisputesStore with _$MyDisputesStore {
  MyDisputesStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _MyDisputesStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _MyDisputesStore(this._apiProvider);

  int _offset = 0;

  @observable
  ObservableList<DisputeModel> disputes = ObservableList.of([]);

  String status = "";

  String getStatus(int value) {
    switch (value) {
      case 0:
        return status = "dispute.statuses.pending";
      case 1:
        return status = "dispute.statuses.created";
      case 2:
        return status = "dispute.statuses.inProgress";
      case 3:
        return status = "dispute.statuses.closed";
    }
    return status;
  }

  Future<void> getDisputes() async {
    try {
      if (disputes.length >= _offset) {
        this.onLoading();
        disputes.addAll(await _apiProvider.getDisputes(offset: _offset));
        _offset += 10;
        this.onSuccess(true);
      }
    } catch (e, trace) {
      print("ERROR: $e");
      print("ERROR: $trace");
      this.onError(e.toString());
    }
  }
}
