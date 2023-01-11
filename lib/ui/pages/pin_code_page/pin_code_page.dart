import 'dart:math';

import "package:app/observer_consumer.dart";
import "package:app/ui/pages/main_page/main_page.dart";
import 'package:app/ui/pages/pin_code_page/store/pin_code_store.dart';
import 'package:app/ui/pages/sign_in_page/sign_in_page.dart';
import 'package:app/ui/widgets/animation_compression.dart';
import 'package:app/ui/widgets/animation_switch.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/snack_bar.dart';
import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import 'package:flutter_svg/flutter_svg.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';

import '../../../constants.dart';
import '../../../utils/storage.dart';
import '../../../web3/repository/account_repository.dart';

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
    Future.delayed(Duration.zero,(){
      context.read<PinCodeStore>().initPage();
    });
    controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.read<PinCodeStore>();

    return WillPopScope(
      onWillPop: () async {
        if (widget.isRecheck) return false;
        store.onWillPop();
        return true;
      },
      child: ObserverListener<PinCodeStore>(
        onFailure: () {
          controller!.forward(from: 0.0);
          if (store.errorMessage != null) if (store.errorMessage!.isNotEmpty)
            return false;
          return true;
        },
        onSuccess: () async {
          if (store.successData == StatePinCode.Success) {
            if (widget.isRecheck) {
              Navigator.pop(context);
            } else {
              await AlertDialogUtils.showSuccessDialog(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                MainPage.routeName,
                (_) => false,
              );
            }
          } else if (store.successData == StatePinCode.ToLogin) {
            AccountRepository().clearData();
            Storage.deleteAllFromSecureStorage();
            Navigator.pushNamedAndRemoveUntil(
              context,
              SignInPage.routeName,
              (_) => false,
            ).then((value) => SnackBarUtils.success(
                  context,
                  title: "Token Expired, Please login",
                ));
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Observer(
            builder: (_) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: double.infinity,
                    height: 110,
                  ),
                  if (store.statePin == StatePinCode.Check)
                    _elementField(
                      title: 'pinCode.comeUp'.tr(),
                      pinCode: store.pin,
                      isLoading: store.startAnimation,
                      activateAnimation: true,
                    )
                  else
                    AnimationSwitchWidget(
                      first: _elementField(
                        title: 'pinCode.comeUp'.tr(),
                        pinCode: store.pin,
                        isLoading: store.startAnimation,
                      ),
                      second: _elementField(
                        title: 'pinCode.repeat'.tr(),
                        pinCode: store.pin,
                        isLoading: store.startAnimation,
                        activateAnimation: true,
                      ),
                      enabled: store.startSwitch,
                    ),
                  if (store.attempts != 0)
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "pinCode.incorrectly".tr() +
                            "${3 - store.attempts}" +
                            "pinCode.left".tr(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  SizedBox(
                    height: store.attempts != 0 ? 15 : 20,
                  ),
                  PinCodeKeyboard(
                    store.inputPin,
                    onTabRemove: store.popPin,
                    onTabSensor: (store.statePin == StatePinCode.Check &&
                            store.canCheckBiometrics)
                        ? store.biometricScan
                        : null,
                    canBiometric: store.canCheckBiometrics,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _elementField({
    required String title,
    required String pinCode,
    required bool isLoading,
    bool activateAnimation = false,
  }) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xff353C47),
            ),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        if (activateAnimation)
          AnimationCompression(
            first: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: PasswordField(
                animationController: controller,
                pinCode: pinCode,
              ),
            ),
            second: const CircularProgressIndicator(),
            enabled: isLoading,
          )
        else
          PasswordField(
            animationController: controller,
            pinCode: pinCode,
          ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class PasswordField extends StatefulWidget {
  final AnimationController? animationController;
  final String pinCode;

  const PasswordField({
    Key? key,
    required this.animationController,
    required this.pinCode,
  }) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (context, child) {
        final sineValue = sin(4 * 2 * pi * widget.animationController!.value);
        return Transform.translate(
          offset: Offset(sineValue * 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 1; i < 5; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 10,
                  width: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 7.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.pinCode.length >= i
                        ? AppColor.enabledButton
                        : const Color(0xffE9EDF2),
                  ),
                )
            ],
          ),
        );
      },
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
