import 'dart:convert';
import 'package:app/base_store/i_store.dart';
import 'package:app/constants.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/http/web3_extension.dart';
import 'package:app/model/bearer_token.dart';
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

abstract class _SignInStore extends IStore<bool> with Store {
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
      !isLoading && _username.isNotEmpty && _password.isNotEmpty && mnemonic.isNotEmpty;

  @action
  void setUsername(String value) => _username = value;

  @action
  String getUsername() => _username;

  @action
  void setPassword(String value) => _password = value;

  @action
  Future refreshToken() async {
    try {
      this.onLoading();
      String? token = await Storage.readRefreshToken();
      BearerToken bearerToken = await _apiProvider.refreshToken(token!, platform);
      await Storage.writeRefreshToken(bearerToken.refresh);
      await Storage.writeAccessToken(bearerToken.access);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  signInWallet({bool isMain = false, String? walletAddress}) async {
    if (isMain) {
      try {
        await _checkWallet(isMain: isMain);
      } on FormatException catch (e) {
        this.onError(e.message);
        AccountRepository().clearData();
      } catch (e) {
        this.onError(e.toString());
        AccountRepository().clearData();
      }
    } else {
      await _checkWallet(walletAddress: walletAddress);
    }
  }

  @action
  Future signIn(String platform) async {
    try {
      this.onLoading();
      print('totp test: $totp');
      BearerToken bearerToken = await _apiProvider.login(
        email: _username.trim(),
        password: _password,
        platform: platform,
        totp: totp,
      );

      if (bearerToken.status == 0) {
        this.onError("unconfirmed");
        return;
      }
      await signInWallet(walletAddress: bearerToken.address!);
      await Storage.writeRefreshToken(bearerToken.refresh);
      await Storage.writeAccessToken(bearerToken.access);
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
      onSuccess(true);
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
      final signature = await AccountRepository()
          .getClient()
          .getSignature(wallet.privateKey!);
      await _apiProvider.walletLogin(signature, wallet.address!);
    } else {
      if (wallet.address != walletAddress) {
        throw FormatException("Incorrect mnemonic");
      }
    }
    await Storage.write(StorageKeys.wallet.name, jsonEncode(wallet.toJson()));
  }

  Future<void> deletePushToken() async {
    try {
      this.onLoading();
      final token = await Storage.readPushToken();
      if (token != null) await _apiProvider.deletePushToken(token: token);
      FirebaseMessaging.instance.deleteToken();
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
