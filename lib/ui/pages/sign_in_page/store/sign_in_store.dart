import 'dart:convert';
import 'package:app/base_store/i_store.dart';
import 'package:app/di/injector.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/http/web3_extension.dart';
import 'package:app/model/bearer_token.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/utils/storage.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:app/web3/service/client_service.dart';
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
  String _username = '';

  @observable
  String _password = '';

  @observable
  String mnemonic = '';

  @observable
  String totp = '';

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
  signInWallet() async {
    final walletAddress = getIt.get<ProfileMeStore>().userData?.walletAddress;
    if (walletAddress == null) this.onError("Profile not found");
    try {
      Wallet? wallet = await Wallet.derive(mnemonic);
      if (wallet.address != walletAddress)
        throw FormatException("Incorrect mnemonic");
      final signature = await ClientService().getSignature(wallet.privateKey!);
      await _apiProvider.walletLogin(signature, wallet.address!);
      await Storage.write(Storage.wallets, jsonEncode([wallet.toJson()]));
      await Storage.write(Storage.activeAddress, wallet.address!);
      AccountRepository().clearData();
      AccountRepository().userAddress = wallet.address;
      AccountRepository().addWallet(wallet);
      this.onSuccess(true);
    } on FormatException catch (e) {
      onError(e.message);
    } catch (e, tr) {
      print("error $e $tr");
      onError(e.toString());
    }
  }

  @action
  Future signIn() async {
    try {
      this.onLoading();
      BearerToken bearerToken = await _apiProvider.login(
        email: _username.trim(),
        password: _password,
      );
      if (bearerToken.status == 0) {
        this.onError("unconfirmed");
        return;
      }
      await Storage.writeRefreshToken(bearerToken.refresh);
      await Storage.writeNotificationToken(bearerToken.access);
      await Storage.writeAccessToken(bearerToken.access);
      if (totp.isNotEmpty) if (!await _apiProvider.validateTotp(totp: totp)){

        this.onError("Invalid TOTP");
        return;
      }
      this.onSuccess(true);
        // throw FormatException("Invalid TOTP");
      // await getIt.get<ProfileMeStore>().getProfileMe();
      // await signInWallet();
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
