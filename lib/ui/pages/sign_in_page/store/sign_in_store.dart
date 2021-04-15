import 'package:mobx/mobx.dart';

part 'sign_in_store.g.dart';

class SignInStore = _SignInStore with _$SignInStore;

abstract class _SignInStore with Store {
  @observable
  String _username = '';

  @observable
  String _password = '';

  @computed
  bool get canSignIn => _username.isNotEmpty && _password.isNotEmpty;

  @observable
  bool isSuccess = false;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @action
  void setUsername(String value) {
    _username = value;
  }

  @action
  void setPassword(String value) {
    _password = value;
  }

  @action
  Future signInWithUsername() async {
    isLoading = true;
    await Future.delayed(Duration(seconds: 3));
    isLoading = false;
  }

}
