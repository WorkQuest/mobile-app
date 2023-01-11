import 'dart:async';

import 'package:app/http/api_provider.dart';
import 'package:injectable/injectable.dart';
import 'package:app/base_store/i_store.dart';
import 'package:mobx/mobx.dart';

part 'sms_verification_store.g.dart';

@singleton
class SMSVerificationStore extends _SMSVerificationStore
    with _$SMSVerificationStore {
  SMSVerificationStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _SMSVerificationStore extends IStore<SMSVerificationStatus> with Store {
  final ApiProvider apiProvider;

  _SMSVerificationStore(this.apiProvider);

  @observable
  Timer? timer;

  @observable
  int secondsCodeAgain = 60;

  @action
  startTimer() {
    try {
      //TODO Add request resending code
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (secondsCodeAgain == 0) {
          timer.cancel();
          secondsCodeAgain = 60;
        } else {
          secondsCodeAgain--;
        }
      });
      onSuccess(SMSVerificationStatus.resending_code);
    } catch (e) {
      onError(e.toString());
    }
  }

  @action
  stopTimer() {
    if (timer != null) {
      timer!.cancel();
    }
    secondsCodeAgain = 60;
  }

  @observable
  String code = '';

  @action
  void setCode(String value) {
    code = value;
  }

  @action
  Future submitCode() async {
    try {
      this.onLoading();
      await apiProvider.submitCode(
        confirmCode: code,
      );
      this.onSuccess(SMSVerificationStatus.send_code);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}

enum SMSVerificationStatus {
  send_code, resending_code
}
