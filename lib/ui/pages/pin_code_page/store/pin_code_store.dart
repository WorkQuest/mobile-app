import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/bearer_token.dart';
import 'package:app/utils/storage.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobx/mobx.dart';

part 'pin_code_store.g.dart';

@singleton
class PinCodeStore extends _PinCodeStore with _$PinCodeStore {
  PinCodeStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _PinCodeStore extends IStore<StatePinCode> with Store {
  final ApiProvider _apiProvider;

  _PinCodeStore(this._apiProvider);

  @action
  initPage() {
    attempts = 0;
    pin = "";
    newPinCode = "";
    canCheckBiometrics = false;
    statePin = StatePinCode.Check;
    Storage.readPinCode().then((value) async {
      var auth = LocalAuthentication();
      if (value == null) {
        statePin = StatePinCode.Create;
      } else {
        canCheckBiometrics = await auth.canCheckBiometrics;
        if (canCheckBiometrics) {
          bool didAuthenticate = await auth.authenticate(
            localizedReason: 'Login authorization',
          );
          if (didAuthenticate) signIn(isBiometric: true);
        }
      }
    });
  }

  @observable
  String pin = "";

  @observable
  int attempts = 0;

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

  ///TODO:check why refresh token not working
  ///TODO:clear password field on error password
  ///

  changeState(StatePinCode state, {errorAnimation = false}) {
    statePin = state;
    if (errorAnimation)
      this.onError("");
    else
      this.onSuccess(state);
  }

  Future<void> onWillPop() async {
    await Storage.deleteAllFromSecureStorage();
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
        changeState(StatePinCode.Repeat);
        return;
      } else if (statePin == StatePinCode.Repeat) {
        if (pin != newPinCode) {
          pin = "";
          changeState(StatePinCode.Create, errorAnimation: true);
          return;
        }
        await Storage.writePinCode(pin);
      } else {
        if (await Storage.readPinCode() != pin) {
          print("object");
          pin = "";
          attempts += 1;
          if (attempts >= 3) {
            await Storage.deleteAllFromSecureStorage();
            this.onSuccess(StatePinCode.ToLogin);
            return;
          }
          changeState(StatePinCode.Check, errorAnimation: true);
          return;
        }
      }

      String? token = await Storage.readRefreshToken();
      if (token == null) {
        await Storage.deleteAllFromSecureStorage();
        this.onSuccess(StatePinCode.ToLogin);
        return;
      }

      BearerToken bearerToken = await _apiProvider.refreshToken(token);
      await Storage.writeRefreshToken(bearerToken.refresh);
      await Storage.writeAccessToken(bearerToken.access);

      this.onSuccess(StatePinCode.Success);
    } catch (e) {
      if (e.toString() == "Token invalid") {
        await Storage.deleteAllFromSecureStorage();
        this.onSuccess(StatePinCode.ToLogin);
        return;
      }
      this.onError(e.toString());
    }
  }
}

enum StatePinCode { Create, Repeat, Check, ToLogin, Success }
