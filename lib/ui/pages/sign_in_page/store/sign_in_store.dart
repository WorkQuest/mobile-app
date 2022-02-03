import 'dart:convert';

import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/http/web3_extension.dart';
import 'package:app/model/bearer_token.dart';
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
  bool walletSuccess = false;

  @observable
  String _username = '';

  @observable
  String _password = '';

  @observable
  String mnemonic = '';

  @action
  setMnemonic(String value) => mnemonic = value;

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
  loginWallet() async {
    try {
      this.onLoading();
      Wallet? wallet = await Wallet.derive(mnemonic);
      final signature =
          await ClientService().getSignature(wallet.privateKey!);
      await _apiProvider.walletLogin(signature, wallet.address!);
      //await Storage.write(Storage.refreshKey, result!.data['result']['refresh']);
      await Storage.write(Storage.wallets, jsonEncode([wallet.toJson()]));
      await Storage.write(Storage.activeAddress, wallet.address!);
      AccountRepository().userAddress = wallet.address;
      AccountRepository().addWallet(wallet);
      walletSuccess = true;
      print("wallet sauccess$walletSuccess");
    } on FormatException catch (e) {
      onError(e.message);
    } catch (e) {
      print("wallet sauccess 2$walletSuccess");
      onError(e.toString());
    }
  }

  @action
  Future signInWithUsername() async {
    if (walletSuccess)
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
      Storage.writeRefreshToken(bearerToken.refresh);
      Storage.writeAccessToken(bearerToken.access);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
