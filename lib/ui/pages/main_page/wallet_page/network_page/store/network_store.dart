import 'package:app/constants.dart';
import 'package:app/http/api_provider.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/base_store/i_store.dart';

part 'network_store.g.dart';

@injectable
class NetworkStore extends _NetworkStoreBase with _$NetworkStore {
  NetworkStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _NetworkStoreBase extends IStore<bool> with Store {
  _NetworkStoreBase(this._apiProvider);

  final ApiProvider _apiProvider;

  @observable
  Network? network;

  @action
  setNetwork(Network value) => network = value;
}
