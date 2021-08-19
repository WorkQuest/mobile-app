import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/responded_model.dart';

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
  List<RespondedModel>? respondedList;

  @action
  getRespondedList(String id) async {
    respondedList = await _apiProvider.responsesQuest(id);
    print(this.respondedList!.length);
  }
}
