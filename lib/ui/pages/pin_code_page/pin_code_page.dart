import 'package:app/di/injector.dart';
import "package:app/observer_consumer.dart";
import "package:app/ui/pages/main_page/main_page.dart";
import 'package:app/ui/pages/pin_code_page/store/pin_code_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/pages/sign_in_page/sign_in_page.dart';
import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import 'package:flutter_svg/flutter_svg.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';

class PinCodePage extends StatefulWidget {
  static const String routeName = "/PinCode";
  final bool isRecheck;

  PinCodePage({this.isRecheck = false});

  @override
  State<StatefulWidget> createState() => _PinCodePageState();
}

class _PinCodePageState extends State<PinCodePage>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;

  @override
  void initState() {
    context.read<PinCodeStore>().initPage();
    controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pinCodeStore = context.read<PinCodeStore>();
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 24.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(controller!)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller!.reverse();
        }
      });
    return WillPopScope(
      onWillPop: () async {
        if (widget.isRecheck) return false;
        pinCodeStore.onWillPop();
        return true;
      },
      child: ObserverListener<PinCodeStore>(
        onFailure: () {
          controller!.forward(from: 0.0);
          if (pinCodeStore.errorMessage != null) if (pinCodeStore
              .errorMessage!.isNotEmpty) return false;
          return true;
        },
        onSuccess: () async {
          if (pinCodeStore.successData == StatePinCode.Success) {
            if (widget.isRecheck) {
              Navigator.pop(context);
            } else {
              await getIt.get<ProfileMeStore>().getProfileMe();
              Navigator.pushNamedAndRemoveUntil(
                context,
                MainPage.routeName,
                (_) => false,
              );
            }
          } else if (pinCodeStore.successData == StatePinCode.ToLogin) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              SignInPage.routeName,
              (_) => false,
            ).then((value) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Token Expired, Please login"))));
          }
        },
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.fromLTRB(59.0, 114.0, 59.0, 0.0),
            child: Observer(
              builder: (_) {
                return pinCodeStore.statePin == StatePinCode.NaN
                    ? Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : Column(
                        children: [
                          Text(
                            pinCodeStore.statePin == StatePinCode.Create
                                ? "pinCode.comeUp".tr()
                                : pinCodeStore.statePin == StatePinCode.Repeat
                                    ? "pinCode.repeat".tr()
                                    : "pinCode.writePinCode".tr(),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          pinCodeStore.isLoading
                              ? CircularProgressIndicator.adaptive()
                              : AnimatedBuilder(
                                  animation: offsetAnimation,
                                  builder: (buildContext, child) {
                                    return Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 24.0,
                                      ),
                                      padding: EdgeInsets.only(
                                        left: offsetAnimation.value + 24.0,
                                        right: 24.0 - offsetAnimation.value,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          for (int i = 1; i < 5; i++)
                                            Observer(
                                              builder: (_) => Container(
                                                height: 10,
                                                width: 10,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 7.5,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: !offsetAnimation
                                                          .isDismissed
                                                      ? Colors.red
                                                      : pinCodeStore
                                                                  .pin.length >=
                                                              i
                                                          ? Color(0xFF0083C7)
                                                          : Color(0xFFE9EDF2),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(5.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                          PinCodeKeyboard(
                            pinCodeStore.inputPin,
                            onTabRemove: pinCodeStore.popPin,
                            onTabSensor:
                                (pinCodeStore.statePin == StatePinCode.Check &&
                                        pinCodeStore.canCheckBiometrics)
                                    ? pinCodeStore.biometricScan
                                    : null,
                            canBiometric: pinCodeStore.canCheckBiometrics,
                          ),
                        ],
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class PinCodeKeyboard extends StatelessWidget {
  final Function(int) onTabNumber;
  final Function()? onTabSensor;
  final Function()? onTabRemove;
  final bool canBiometric;

  PinCodeKeyboard(
    this.onTabNumber, {
    this.onTabSensor,
    this.onTabRemove,
    this.canBiometric = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.count(
        padding: const EdgeInsets.only(top: 40),
        crossAxisCount: 3,
        primary: false,
        crossAxisSpacing: 30,
        mainAxisSpacing: 30,
        children: <Widget>[
          for (var i = 1; i < 10; i++)
            KeyboardButton(
              Text(
                i.toString(),
                style: buttonText,
              ),
              () => onTabNumber(i),
            ),
          KeyboardButton(
            SvgPicture.asset(
              "assets/biometric.svg",
              width: 20,
              height: 20,
              color: canBiometric ? Color(0xFF0083C7) : Colors.grey[500],
            ),
            onTabSensor,
          ),
          KeyboardButton(
            const Text(
              "0",
              style: buttonText,
            ),
            () => onTabNumber(0),
          ),
          KeyboardButton(
            SvgPicture.asset(
              "assets/remove.svg",
              width: 20,
              height: 12,
              color: Color(0xFF0083C7),
            ),
            onTabRemove,
          ),
        ],
      ),
    );
  }
}

const TextStyle buttonText = TextStyle(
  fontSize: 20,
  color: Colors.black,
  fontWeight: FontWeight.w400,
);

class KeyboardButton extends StatelessWidget {
  final Widget child;
  final Function()? onTab;

  KeyboardButton(this.child, [this.onTab]);

  @override
  Widget build(BuildContext context) {
    final store = context.read<PinCodeStore>();
    return TextButton(
      onPressed: store.isLoading ? null : onTab,
      child: child,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed))
              return Theme.of(context).colorScheme.primary.withOpacity(0.5);
            return const Color(0xFFF7F8FA);
          },
        ),
      ),
    );
  }
}
