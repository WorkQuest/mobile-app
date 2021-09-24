import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/bearer_token.dart';
import 'package:app/utils/storage.dart';
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
  Future signInWithUsername() async {
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

  @action
  Future signInWithTwitter() async {
    try {
      this.onLoading();
      print("called");
      var page =await _apiProvider.loginWithGoogle();
      return page;
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
