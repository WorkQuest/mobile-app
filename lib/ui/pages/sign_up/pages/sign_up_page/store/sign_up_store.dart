import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/repository/reg_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'sign_up_store.g.dart';

@injectable
class SignUpStore extends _SignUpStore with _$SignUpStore {
  SignUpStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _SignUpStore extends IStore<SignUpState> with Store {
  final IRegRepository _repository;

  _SignUpStore(ApiProvider apiProvider)
      : _repository = RegRepository(apiProvider);

  @observable
  String _email = '';

  @observable
  String _firstName = '';

  @observable
  String _lastName = '';

  @observable
  String _password = '';

  @observable
  String _confirmPassword = '';

  @computed
  bool get canSignUp =>
      !isLoading &&
      _email.isNotEmpty &&
      _firstName.isNotEmpty &&
      _lastName.isNotEmpty &&
      _password.isNotEmpty &&
      _confirmPassword.isNotEmpty;

  @action
  void setEmail(String value) => _email = value;

  @action
  void setFirstName(String value) => _firstName = value;

  @action
  void setLastName(String value) => _lastName = value;

  @action
  void setPassword(String value) => _password = value;

  @action
  void setConfirmPassword(String value) => _confirmPassword = value;

  @computed
  String get email => _email;

  @computed
  String get password => _password;

  @action
  Future register() async {
    try {
      this.onLoading();
      await _repository.register(
          email: email,
          firstName: _firstName,
          lastName: _lastName,
          password: _password);
      this.onSuccess(SignUpState.register);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}

enum SignUpState { register }
