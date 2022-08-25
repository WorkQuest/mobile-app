import 'dart:async';

import 'package:app/base_store/i_store.dart';
import 'package:app/utils/storage.dart';
import 'package:injectable/injectable.dart';
import 'package:app/http/api_provider.dart';
import 'package:mobx/mobx.dart';

part 'confirm_email_store.g.dart';

@injectable
class ConfirmEmailStore extends _ConfirmEmailStore with _$ConfirmEmailStore {
  ConfirmEmailStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _ConfirmEmailStore extends IStore<ConfirmEmailState> with Store {
  final ApiProvider _apiProvider;

  _ConfirmEmailStore(this._apiProvider);

  @observable
  String _codeFromEmail = "";

  Timer? timer;

  @observable
  int secondsCodeAgain = 60;

  @computed
  bool get canSubmitCode =>
      _codeFromEmail.isNotEmpty && _codeFromEmail.length > 4;

  @action
  void setCode(String value) => _codeFromEmail = value;

  @action
  confirmEmail() async {
    try {
      this.onLoading();
      await _apiProvider.confirmEmail(code: _codeFromEmail.trim());
      this.onSuccess(ConfirmEmailState.confirmEmail);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  startTimer(String email) async {
    try {
      await _apiProvider.resendEmail(email);
      final timerTime = await Storage.readTimeEmailTimer();
      if ((timerTime ?? "0") != "0")
        secondsCodeAgain = int.parse(timerTime!);
      else
        await Storage.writeTimerEmailTime(secondsCodeAgain.toString());
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (secondsCodeAgain == 0) {
          timer.cancel();
          secondsCodeAgain = 60;
        } else {
          secondsCodeAgain--;
          Storage.writeTimerEmailTime(secondsCodeAgain.toString());
        }
      });
      onSuccess(ConfirmEmailState.startTimer);
    } catch (e) {
      onError(e.toString());
    }
  }
}

enum ConfirmEmailState { confirmEmail, startTimer }
