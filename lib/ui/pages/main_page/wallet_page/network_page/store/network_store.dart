import 'package:app/constants.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:app/web3/repository/account_repository.dart';
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

  @action
  changeNetwork(Network newNetwork) async {
    try {
      onLoading();
      final _wallet = AccountRepository().userWallet!;
      final signature = await AccountRepository().client!.getSignature(_wallet.privateKey!);
      /// TODO reconnect session
      // await _apiProvider.login(signature, AccountRepository().userAddress, isMain: newNetwork == Network.mainnet);
      final _newNetworkName = Web3Utils.getNetworkNameSwap(AccountRepository().networkName.value!);
      AccountRepository().notifierNetwork.value = newNetwork;
      AccountRepository().changeNetwork(_newNetworkName);
      network = newNetwork;
      onSuccess(true);
    } on FormatException catch (e) {
      onError(e.message);
    } catch (e) {
      onError(e.toString());
    }
  }
}
