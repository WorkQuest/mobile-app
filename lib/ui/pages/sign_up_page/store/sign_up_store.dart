import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/utils/storage.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'sign_up_store.g.dart';

@injectable
class SignUpStore extends _SignUpStore with _$SignUpStore {
  SignUpStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _SignUpStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _SignUpStore(this._apiProvider);

  @observable
  String _email = '';

  @observable
  String _firstName = '';

  @observable
  String _lastName = '';

  @observable
  String _password = '';

  @computed
  bool get canSignUp =>
      !isLoading &&
      _email.isNotEmpty &&
      _firstName.isNotEmpty &&
      _lastName.isNotEmpty &&
      _password.isNotEmpty;

  @action
  void setEmail(String value) => _email = value;

  @action
  void setFirstName(String value) => _firstName = value;

  @action
  void setLastName(String value) => _lastName = value;

  @action
  void setPassword(String value) => _password = value;

  @action
  Future register() async {
    try {
      this.onLoading();
      String refreshToken = await _apiProvider.register(
        email: _email,
        firstName: _firstName,
        lastName: _lastName,
        password: _password,
      );
      Storage.writeRefreshToken(refreshToken);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
