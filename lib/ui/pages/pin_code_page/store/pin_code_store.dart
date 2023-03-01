import 'package:app/base_store/i_store.dart';
import 'package:app/di/injector.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/bearer_token.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/utils/storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  ProfileMeResponse? userData;

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
      canCheckBiometrics = await auth.canCheckBiometrics;
      if (canCheckBiometrics) {
        final _typesBiometric = await auth.getAvailableBiometrics();
        isFaceId = _typesBiometric.contains(BiometricType.face);
      }
      if (value == null)
        statePin = StatePinCode.Create;
      else {
        statePin = StatePinCode.Check;
        bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Login authorization',
        );
        if (didAuthenticate) signIn(isBiometric: true);
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

  @observable
  bool isFaceId = false;

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
      final _typesBiometric = await localAuth.getAvailableBiometrics();
      isFaceId = _typesBiometric.contains(BiometricType.face);
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

  Future<void> getProfile(String id) async {
    try {
      this.onLoading();
      userData = await _apiProvider.getProfileUser(userId: id);
      this.onSuccess(StatePinCode.Success);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  changeState(StatePinCode state, {errorAnimation = false}) {
    statePin = state;
    if (errorAnimation)
      this.onError("");
    else
      this.onSuccess(state);
  }

  Future<void> onWillPop() async {
    await deletePushToken();
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
                await deletePushToken();
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
            break;
          case StatePinCode.Success:
            break;
          case StatePinCode.NaN:
            break;
        }
      }
      String? token = await Storage.readRefreshToken();
      if (token == null) {
        await deletePushToken();
        await Storage.deleteAllFromSecureStorage();
        this.onSuccess(StatePinCode.ToLogin);
        return;
      }

      BearerToken bearerToken =
          await _apiProvider.refreshToken(token, platform);
      await Storage.writeRefreshToken(bearerToken.refresh);
      await Storage.writeAccessToken(bearerToken.access);
      await getIt.get<ProfileMeStore>().getProfileMe();
      totpValid = true;
      this.onSuccess(StatePinCode.Success);
      await Future.delayed(const Duration(milliseconds: 500));
      Future.delayed(const Duration(seconds: 1)).then((value) {
        startAnimation = false;
        startSwitch = false;
      });
    } catch (e) {
      if (e.toString() == "Token invalid" ||
          e.toString() == "Token expired" ||
          e.toString() == "Session not found") {
        await deletePushToken();
        await Storage.deleteAllFromSecureStorage();
        this.onSuccess(StatePinCode.ToLogin);
        startAnimation = false;
        return;
      }
      totpValid = false;
      pin = "";
      changeState(StatePinCode.Check, errorAnimation: true);
      startAnimation = false;
      this.onError(e.toString());
    }
  }

  Future<void> checkPushToken() async {
    try {
      final firebaseToken = await FirebaseMessaging.instance.getToken();
      final pushToken = await Storage.readPushToken();
      if (pushToken != firebaseToken) {
        if (pushToken != null)
          await _apiProvider.deletePushToken(token: pushToken);
        await _apiProvider.registerPushToken(token: firebaseToken ?? "");
        Storage.writePushToken(firebaseToken ?? "");
      }
    } catch (e) {
      // this.onError(e.toString());
    }
  }

  Future<void> deletePushToken() async {
    try {
      final token = await Storage.readPushToken();
      if (token != null) _apiProvider.deletePushToken(token: token);
      FirebaseMessaging.instance.deleteToken();
    } catch (e) {
      this.onError(e.toString());
    }
  }
}

enum StatePinCode { Create, Repeat, Check, ToLogin, Success, NaN }
