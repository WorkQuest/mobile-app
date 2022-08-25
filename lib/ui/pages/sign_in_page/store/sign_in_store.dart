import 'dart:convert';
import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/http/web3_extension.dart';
import 'package:app/model/bearer_token.dart';
import 'package:app/utils/profile_util.dart';
import 'package:app/utils/storage.dart';
import 'package:app/web3/repository/wallet_repository.dart';
import 'package:app/web3/wallet.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'sign_in_store.g.dart';

@injectable
class SignInStore extends _SignInStore with _$SignInStore {
  SignInStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _SignInStore extends IStore<SignInStoreState> with Store {
  final ApiProvider _apiProvider;

  _SignInStore(this._apiProvider);

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
      String? token = await Storage.readRefreshToken();
      BearerToken bearerToken = await _apiProvider.refreshToken(token!, platform);
      await Storage.writeRefreshToken(bearerToken.refresh);
      await Storage.writeAccessToken(bearerToken.access);
      this.onSuccess(SignInStoreState.refreshToken);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  signInWallet() async {
    try {
      onLoading();
      Wallet? wallet = await Wallet.derive(mnemonic);
      WalletRepository().connectClient();
      final signature = await WalletRepository().getClient().getSignature(wallet.privateKey!);
      final userMe = await _apiProvider.getProfileMe();
      final _address = await _apiProvider.walletLogin(signature, wallet.address!);
      if (_address != userMe.walletAddress) {
        throw FormatException("Incorrect mnemonic");
      }
      WalletRepository().setWallet(wallet);
      await Storage.write(StorageKeys.wallet.name, jsonEncode(wallet.toJson()));
      await Storage.write(StorageKeys.networkName.name, WalletRepository().networkName.value!.name);
      onSuccess(SignInStoreState.signInWallet);
    } on FormatException catch (e, trace) {
      print('signInWallet FormatException: $e\n$trace');
      this.onError(e.message);
    } catch (e, trace) {
      print('signInWallet catch: $e\n$trace');
      this.onError(e.toString());
    }
  }

  @action
  signIn(String platform) async {
    try {
      this.onLoading();
      BearerToken bearerToken = await _apiProvider.login(
        email: _username.trim(),
        password: _password,
        platform: platform,
        totp: totp,
      );

      await Storage.writeRefreshToken(bearerToken.refresh);
      await Storage.writeAccessToken(bearerToken.access);
      if (bearerToken.status == ProfileConstants.unconfirmedStatus) {
        onSuccess(SignInStoreState.unconfirmedProfile);
        return;
      }
      if (bearerToken.status == ProfileConstants.needSetRoleStatus) {
        onSuccess(SignInStoreState.needSetRole);
        return;
      }
      if (bearerToken.address == null) {
        onSuccess(SignInStoreState.createWallet);
        return;
      }
      if (totp.isNotEmpty) {
        if (!await _apiProvider.validateTotp(totp: totp)) {
          this.onError("Invalid TOTP");
          totp = '';
          return;
        }
      } else {
        if (bearerToken.totpIsActive != null && bearerToken.totpIsActive!) {
          this.onError("User must pass 2FA");
          totp = '';
          return;
        }
      }
      onSuccess(SignInStoreState.signIn);
    } on FormatException catch (e, trace) {
      print('e: $e\ntrace: $trace');
      this.onError(e.message);
    } catch (e, trace) {
      print('e: $e\ntrace: $trace');
      this.onError(e.toString());
    }
  }

  Future<void> deletePushToken() async {
    try {
      this.onLoading();
      print('deletePushToken');
      final token = await Storage.readPushToken();
      if (token != null) await _apiProvider.deletePushToken(token: token);
      FirebaseMessaging.instance.deleteToken();
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
