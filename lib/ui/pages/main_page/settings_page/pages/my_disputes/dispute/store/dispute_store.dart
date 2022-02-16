import 'package:app/http/api_provider.dart';
import 'package:app/base_store/i_store.dart';
import 'package:app/model/dispute_model.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'dispute_store.g.dart';

@injectable
class DisputeStore extends _DisputeStore with _$DisputeStore {
  DisputeStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _DisputeStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _DisputeStore(this._apiProvider);

  @observable
  String status = "";

  @observable
  ObservableList<DisputeModel> disputes = ObservableList.of([]);

  String getStatus(int value) {
    switch (value) {
      case 0:
        return status = "dispute.statuses.pending";
      case 1:
        return status = "dispute.statuses.inProgress";
      case 2:
        return status = "dispute.statuses.closed";
    }
    return status;
  }
}
