import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/bearer_token.dart';
import 'package:app/utils/storage.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'pin_code_store.g.dart';

@injectable
class PinCodeStore extends _PinCodeStore with _$PinCodeStore {
  PinCodeStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _PinCodeStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;
  _PinCodeStore(this._apiProvider) {
    Storage.readPinCode().then((value) {
      print("WKLOG $value");
      if (value == null) {
        statePin = StatePinCode.Create;
      }
    });
  }

  @observable
  String pin = "";

  @observable
  StatePinCode statePin = StatePinCode.Check;

  @observable
  String newPinCode = "";

  @action
  inputPin(int num) {
    if (pin.length < 4) pin += num.toString();
    if (pin.length == 4) signIn();
  }

  @action
  popPin() {
    if (pin.isNotEmpty) pin = pin.substring(0, pin.length - 1);
  }

  @action
  Future signIn() async {
    try {
      this.onLoading();
      if (statePin == StatePinCode.Create) {
        newPinCode = pin;
        pin = "";
        statePin = StatePinCode.Repeat;
        this.onSuccess(true);
        return;
      } else if (statePin == StatePinCode.Repeat) {
        if (pin == newPinCode) {
          await Storage.writePinCode(pin);
          statePin = StatePinCode.Check;
        } else {
          statePin = StatePinCode.Create;
          pin = "";
          this.onError("Пин код не совпал");
          return;
        }
      } else {
        if (await Storage.readPinCode() != pin) {
          pin = "";
          this.onError("Неверный пинкод");
          return;
        }
      }

      String? token = await Storage.readRefreshToken();

      BearerToken bearerToken = await _apiProvider.refreshToken(token!);

      Storage.writeRefreshToken(bearerToken.refresh);
      Storage.writeAccessToken(bearerToken.access);

      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}

enum StatePinCode { Create, Repeat, Check }
