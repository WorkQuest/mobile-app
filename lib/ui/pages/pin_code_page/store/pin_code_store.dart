import 'package:app/base_store/i_store.dart';
import 'package:app/di/injector.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/bearer_token.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/utils/storage.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

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
    statePin = StatePinCode.NaN;
    Storage.readPinCode().then((value) async {
      var auth = LocalAuthentication();
      if (value == null) {
        statePin = StatePinCode.Create;
      } else {
        statePin = StatePinCode.Check;
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
  bool totpValid = false;

  @observable
  String platform = "";

  @observable
  String pin = "";

  @observable
  int attempts = 0;

  @observable
  StatePinCode statePin = StatePinCode.Check;

  @observable
  String newPinCode = "";

  @observable
  bool startSwitch = false;

  @observable
  bool startAnimation = false;

  @observable
  bool canCheckBiometrics = false;

  @action
  setPlatform(String value) => platform = value;

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

  ///TODO:clear password field on error password

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
        startAnimation = true;
        await Future.delayed(const Duration(seconds: 1));
      } else {
        switch (statePin) {
          case StatePinCode.Create:
            newPinCode = pin;
            pin = "";
            changeState(StatePinCode.Repeat);
            startSwitch = true;
            return;
          case StatePinCode.Repeat:
            if (pin != newPinCode) {
              pin = "";
              changeState(StatePinCode.Create, errorAnimation: true);
              return;
            }
            await Storage.writePinCode(pin);
            startAnimation = true;
            await Future.delayed(const Duration(seconds: 1));
            break;
          case StatePinCode.Check:
            if (await Storage.readPinCode() != pin) {
              pin = "";
              attempts += 1;
              if (attempts >= 3) {
                await Storage.deleteAllFromSecureStorage();
                final cookieManager = WebviewCookieManager();
                cookieManager.clearCookies();
                this.onSuccess(StatePinCode.ToLogin);
                return;
              }
              changeState(StatePinCode.Check, errorAnimation: true);
              return;
            }
            startAnimation = true;
            await Future.delayed(const Duration(seconds: 1));
            break;
          case StatePinCode.ToLogin:
            // TODO: Handle this case.
            break;
          case StatePinCode.Success:
            // TODO: Handle this case.
            break;
          case StatePinCode.NaN:
            // TODO: Handle this case.
            break;
        }
      }
      String? token = await Storage.readRefreshToken();
      if (token == null) {
        await Storage.deleteAllFromSecureStorage();
        this.onSuccess(StatePinCode.ToLogin);
        return;
      }

      BearerToken bearerToken = await _apiProvider.refreshToken(token, platform);
      await Storage.writeRefreshToken(bearerToken.refresh);
      await Storage.writeAccessToken(bearerToken.access);
      await getIt.get<ProfileMeStore>().getProfileMe();
      totpValid = true;
      this.onSuccess(StatePinCode.Success);
      await Future.delayed(const Duration(milliseconds: 500));
      startAnimation = false;
      startSwitch = false;
    } catch (e) {
      if (e.toString() == "Token invalid" ||
          e.toString() == "Token expired" ||
          e.toString() == "Session not found") {

        await Storage.deleteAllFromSecureStorage();
        this.onSuccess(StatePinCode.ToLogin);
        return;
      }
      totpValid = false;
      startAnimation = false;
      this.onError(e.toString());
    }
  }
}

enum StatePinCode { Create, Repeat, Check, ToLogin, Success, NaN }
