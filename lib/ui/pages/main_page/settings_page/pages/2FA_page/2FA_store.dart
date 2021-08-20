import 'package:app/http/api_provider.dart';
import 'package:injectable/injectable.dart';
import 'package:app/base_store/i_store.dart';
import 'package:mobx/mobx.dart';

part '2FA_store.g.dart';

@injectable
@singleton
class TwoFAStore extends _TwoFAStore
    with _$TwoFAStore {
  TwoFAStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _TwoFAStore extends IStore<bool> with Store {
  final ApiProvider apiProvider;

  _TwoFAStore(this.apiProvider);

  @observable
  int index = 1;

  @observable
  String codeFromEmail = '';

  @observable
  String codeFromAuthenticator = '';

  @action
  void setCodeFromAuthenticator(String value) {
    codeFromAuthenticator = value;
  }

  @action
  void setCode(String value) {
    codeFromEmail =value;
  }

 /* @action
  Future submitCode() async {
    try {
      this.onLoading();
      await apiProvider.submitCode(
        confirmCode: code,
      );
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }*/
}
