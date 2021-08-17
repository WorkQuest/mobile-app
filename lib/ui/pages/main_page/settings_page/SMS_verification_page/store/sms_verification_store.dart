import 'package:app/http/api_provider.dart';
import 'package:injectable/injectable.dart';
import 'package:app/base_store/i_store.dart';
import 'package:mobx/mobx.dart';

part 'sms_verification_store.g.dart';

@injectable
@singleton
class SMSVerificationStore extends _SMSVerificationStore with _$SMSVerificationStore {
  SMSVerificationStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _SMSVerificationStore extends IStore<bool> with Store {
  final ApiProvider apiProvider;

  _SMSVerificationStore(this.apiProvider);

  @observable
  int index = 0;

  @observable
  String phone = '';

  @observable
  String code = '';

  @action
  void setPhone(String value) {
    phone = value;
  }

  @action
  void setCode(String value) {
    code = value;
  }

}
