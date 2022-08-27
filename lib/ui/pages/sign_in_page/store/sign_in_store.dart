import 'package:app/base_store/i_store.dart';
import 'package:app/enums.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/repository/auth_repository.dart';
import 'package:app/utils/profile_util.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'sign_in_store.g.dart';

@injectable
class SignInStore extends _SignInStore with _$SignInStore {
  SignInStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _SignInStore extends IStore<SignInStoreState> with Store {
  final IAuthRepository _repository;

  _SignInStore(ApiProvider apiProvider) : _repository = AuthRepository(apiProvider);

  @observable
  String platform = '';

  @observable
  String _username = '';

  @observable
  String _password = '';

  @observable
  String mnemonic = '';

  @observable
  String totp = '';

  @action
  setPlatform(String value) => platform = value;

  @action
  setMnemonic(String value) => mnemonic = value;

  @action
  setTotp(String value) => totp = value;

  @computed
  bool get canSignIn => !isLoading && _username.isNotEmpty && _password.isNotEmpty;

  @action
  void setUsername(String value) => _username = value;

  @action
  String getUsername() => _username;

  @action
  void setPassword(String value) => _password = value;

  @action
  refreshToken() async {
    try {
      this.onLoading();
      await _repository.refreshToken();
      this.onSuccess(SignInStoreState.refreshToken);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  signInWallet() async {
    try {
      onLoading();
      await _repository.signInWallet(mnemonic);
      onSuccess(SignInStoreState.signInWallet);
    } on FormatException catch (e) {
      this.onError(e.message);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  signIn(String platform) async {
    try {
      this.onLoading();
      final bearerToken = await _repository.signInEmailPassword(username: _username.trim(), password: _password);

      if (bearerToken.status == ProfileConstants.userStatuses[UserStatuses.Unconfirmed]) {
        onSuccess(SignInStoreState.unconfirmedProfile);
        return;
      }
      if (bearerToken.status == ProfileConstants.userStatuses[UserStatuses.NeedSetRole]) {
        onSuccess(SignInStoreState.needSetRole);
        return;
      }
      if (bearerToken.address == null) {
        onSuccess(SignInStoreState.createWallet);
        return;
      }

      if (bearerToken.totpIsActive) {
        if (totp.isEmpty) {
          totp = '';
          throw FormatException('User must pass 2FA');
        }

        final validate = await _repository.validateTotp(totp);
        if (!validate) {
          totp = '';
          throw FormatException('Invalid TOTP');
        }
      }
      totp = '';
      onSuccess(SignInStoreState.signIn);
    } on FormatException catch (e) {
      this.onError(e.message);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  Future<void> deletePushToken() async {
    try {
      this.onLoading();
      await _repository.deletePushToken();
      this.onSuccess(SignInStoreState.deletePushToken);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}

enum SignInStoreState {
  refreshToken,
  signIn,
  unconfirmedProfile,
  needSetRole,
  deletePushToken,
  signInWallet,
  createWallet
}
