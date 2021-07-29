import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/bearer_token.dart';
import 'package:app/utils/storage.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';
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
      LocalAuthentication()
          .canCheckBiometrics
          .then((check) => canCheckBiometrics = check);
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

  @observable
  bool canCheckBiometrics = false;

  @action
  inputPin(int num) {
    if (pin.length < 4) pin += num.toString();
    if (pin.length == 4) signIn();
  }

  @action
  popPin() {
    if (pin.isNotEmpty) pin = pin.substring(0, pin.length - 1);
  }

  biometricScan() async {
    var localAuth = LocalAuthentication();
    // late List<BiometricType> availableBiometrics;
    // try {
    //   availableBiometrics =
    //       await localAuth.getAvailableBiometrics();
    // } catch (e) {
    //   availableBiometrics = <BiometricType>[];
    //   print(e);
    // }
    try {
      bool didAuthenticate = await localAuth.authenticate(
        localizedReason: 'Login authorization',
      );
      if (didAuthenticate) {
        signIn(isBiometric: true);
      }
    } catch (e) {
      print(e);
    }
  }

  @action
  Future signIn({bool isBiometric = false}) async {
    try {
      this.onLoading();
      if (isBiometric) {
        pin = "";
      } else if (statePin == StatePinCode.Create) {
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
