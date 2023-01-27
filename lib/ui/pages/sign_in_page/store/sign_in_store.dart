import 'dart:convert';
import 'package:app/base_store/i_store.dart';
import 'package:app/constants.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/http/web3_extension.dart';
import 'package:app/model/bearer_token.dart';
import 'package:app/utils/profile_util.dart';
import 'package:app/utils/storage.dart';
import 'package:app/web3/repository/account_repository.dart';
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
  bool get canSignIn =>
      !isLoading && _username.isNotEmpty && _password.isNotEmpty;

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
  signInWallet({bool isMain = false, String? walletAddress}) async {
    try {
      onLoading();
      await _checkWallet(isMain: isMain);
      onSuccess(SignInStoreState.signInWallet);
    } on FormatException catch (e) {
      this.onError(e.message);
      AccountRepository().clearData();
    } catch (e) {
      this.onError(e.toString());
      AccountRepository().clearData();
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
      AccountRepository().clearData();
    } catch (e, trace) {
      print('e: $e\ntrace: $trace');
      this.onError(e.toString());
      AccountRepository().clearData();
    }
  }

  _checkWallet({bool isMain = false, String? walletAddress}) async {
    Wallet? wallet = await Wallet.derive(mnemonic);
    if (AccountRepository().networkName.value == null) {
      final _networkName = AccountRepository().notifierNetwork.value == Network.mainnet
          ? NetworkName.workNetMainnet
          : NetworkName.workNetTestnet;
      AccountRepository().setNetwork(_networkName);
    }
    AccountRepository().setWallet(wallet);
    AccountRepository().connectClient();
    if (isMain) {
      final signature =
          await AccountRepository().getClient().getSignature(wallet.privateKey!);
      await _apiProvider.walletLogin(signature, wallet.address!);
    } else {
      if (wallet.address != walletAddress) {
        throw FormatException("Incorrect mnemonic");
      }
    }
    await Storage.write(StorageKeys.wallet.name, jsonEncode(wallet.toJson()));
    await Storage.write(
        StorageKeys.networkName.name, AccountRepository().networkName.value!.name);
  }

  Future<void> deletePushToken() async {
    try {
      this.onLoading();
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
  signInWallet
}
