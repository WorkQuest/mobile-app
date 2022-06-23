import 'dart:convert';
import 'package:app/base_store/i_store.dart';
import 'package:app/di/injector.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/http/web3_extension.dart';
import 'package:app/model/bearer_token.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/utils/storage.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:app/web3/wallet.dart';
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

  @observable
  String error = "";

  @action
  setPlatform(String value) => platform = value;

  @action
  setMnemonic(String value) => mnemonic = value;

  @action
  setTotp(String value) => totp = value;

  @computed
  bool get canSignIn =>
      !isLoading &&
      _username.isNotEmpty &&
      _password.isNotEmpty &&
      mnemonic.isNotEmpty;

  @action
  void setUsername(String value) => _username = value;

  @action
  String getUsername() => _username;

  @action
  void setPassword(String value) => _password = value;

  @action
  Future loginSocialMedia(String link) async {
    try {
      this.onLoading();
      await _apiProvider.loginSocialMedia(link);
      // String? token = await Storage.readRefreshToken();
      // BearerToken bearerToken = await _apiProvider.refreshToken(token!);
      // await Storage.writeRefreshToken(bearerToken.refresh);
      // await Storage.writeAccessToken(bearerToken.access);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future refreshToken() async {
    try {
      this.onLoading();
      String? token = await Storage.readRefreshToken();
      BearerToken bearerToken =
          await _apiProvider.refreshToken(token!, platform);
      await Storage.writeRefreshToken(bearerToken.refresh);
      await Storage.writeAccessToken(bearerToken.access);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  signInWallet() async {
    error = "";
    final walletAddress = getIt.get<ProfileMeStore>().userData?.walletAddress;
    if (walletAddress == null) this.onError("Profile not found");
    try {
      Wallet? wallet = await Wallet.derive(mnemonic);
      AccountRepository().connectClient();
      AccountRepository().setWallet(wallet);
      if (wallet.address != walletAddress)
        throw FormatException("Incorrect mnemonic");
      final signature =
          await AccountRepository().getClient().getSignature(wallet.privateKey!);
      await _apiProvider.walletLogin(signature, wallet.address!);
      await Storage.write(Storage.wallet, jsonEncode(wallet.toJson()));
      await Storage.write(Storage.activeAddress, wallet.address!);
      this.onSuccess(true);
    } on FormatException catch (e) {
      this.onError(e.message);
      AccountRepository().clearData();
      error = e.toString();
    } catch (e, tr) {
      AccountRepository().clearData();
      print("error $e $tr");
      this.onError(e.toString());
    }
  }

  @action
  Future signIn(String platform) async {
    try {
      this.onLoading();
      await Future.delayed(const Duration(seconds: 1));
      error = "";
      BearerToken bearerToken = await _apiProvider.login(
        email: _username.trim(),
        password: _password,
        platform: platform,
        totp: totp,
      );

      if (bearerToken.status == 0) {
        error = 'unconfirmed';
        this.onError("unconfirmed");
        return;
      }
      await Storage.writeRefreshToken(bearerToken.refresh);
      await Storage.writeAccessToken(bearerToken.access);
      if (totp.isNotEmpty) if (!await _apiProvider.validateTotp(totp: totp)) {
        error = "Invalid TOTP";
        this.onError("Invalid TOTP");
        return;
      }

      // throw FormatException("Invalid TOTP");
      // await getIt.get<ProfileMeStore>().getProfileMe();
      // await signInWallet();
      this.successData = true;
      this.errorMessage = null;
    } on FormatException catch (e, trace) {
      print('e: $e\ntrace: $trace');
      error = e.message;
      this.onError(e.message);
    } catch (e, trace) {
      print('e: $e\ntrace: $trace');
      error = e.toString();
      this.onError(e.toString());
    }
  }

  Future<void> deletePushToken() async {
    try {
      this.onLoading();
      final token = await Storage.readPushToken();
      if (token != null) await _apiProvider.deletePushToken(token: token);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
