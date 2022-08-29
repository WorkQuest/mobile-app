import 'package:app/constants.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/utils/storage.dart';
import 'package:app/web3/repository/wallet_repository.dart';

abstract class IRegRepository {
  Future register({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
  });
}

class RegRepository extends IRegRepository {
  RegRepository(ApiProvider apiProvider) : _apiProvider = apiProvider;

  ApiProvider _apiProvider;

  @override
  Future register({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
  }) async {
    try {
      if (WalletRepository().networkName.value == null) {
        final _networkName =
            WalletRepository().notifierNetwork.value == Network.mainnet
                ? NetworkName.workNetMainnet
                : NetworkName.workNetTestnet;
        WalletRepository().setNetwork(_networkName);
      }
      final bearerToken = await _apiProvider.register(
        email: email,
        firstName: firstName,
        lastName: lastName,
        password: password,
      );
      Storage.writeRefreshToken(bearerToken.refresh);
      Storage.writeAccessToken(bearerToken.access);
    } catch (e) {
      print('RegRepository register | error: $e');
      throw RegException(e.toString());
    }
  }
}

class RegException implements Exception {
  final String message;

  const RegException([this.message = 'Unknown registration error']);

  @override
  String toString() => message;
}
