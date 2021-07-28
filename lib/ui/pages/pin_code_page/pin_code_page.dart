import "package:app/observer_consumer.dart";
import "package:app/ui/pages/main_page/main_page.dart";
import 'package:app/ui/pages/pin_code_page/store/pin_code_store.dart';
import "package:app/ui/widgets/platform_activity_indicator.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:provider/provider.dart";

class PinCodePage extends StatelessWidget {
  static const String routeName = "/PinCode";

  @override
  Widget build(BuildContext context) {
    final pinCodeStore = context.read<PinCodeStore>();

    return Scaffold(
      body: ObserverListener<PinCodeStore>(
        onSuccess: () {
          if (pinCodeStore.statePin == StatePinCode.Check)
            Navigator.pushNamedAndRemoveUntil(
              context,
              MainPage.routeName,
              (_) => false,
            );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(59.0, 114.0, 59.0, 0.0),
          child: Observer(
            builder: (_) => Column(
              children: [
                Text(
                  pinCodeStore.statePin == StatePinCode.Create
                      ? "Придумайте пинкод"
                      : pinCodeStore.statePin == StatePinCode.Repeat
                          ? "Повторите пинкод"
                          : "Please, write your PIN-code",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                pinCodeStore.isLoading
                    ? PlatformActivityIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 1; i < 5; i++)
                            Container(
                              height: 10,
                              width: 10,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 7.5),
                              decoration: BoxDecoration(
                                color: pinCodeStore.pin.length >= i
                                    ? Color(0xFF0083C7)
                                    : Color(0xFFE9EDF2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                            )
                        ],
                      ),
                PinCodeKeyboard(pinCodeStore.inputPin,
                    onTabRemove: pinCodeStore.popPin),
              ],
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
  PinCodeKeyboard(this.onTabNumber, {this.onTabSensor, this.onTabRemove});
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
        KeyboardButton(
            const Text("1", style: buttonText), () => onTabNumber(1)),
        KeyboardButton(
            const Text("2", style: buttonText), () => onTabNumber(2)),
        KeyboardButton(
            const Text("3", style: buttonText), () => onTabNumber(3)),
        KeyboardButton(
            const Text("4", style: buttonText), () => onTabNumber(4)),
        KeyboardButton(
            const Text("5", style: buttonText), () => onTabNumber(5)),
        KeyboardButton(
            const Text("6", style: buttonText), () => onTabNumber(6)),
        KeyboardButton(
            const Text("7", style: buttonText), () => onTabNumber(7)),
        KeyboardButton(
            const Text("8", style: buttonText), () => onTabNumber(8)),
        KeyboardButton(
            const Text("9", style: buttonText), () => onTabNumber(9)),
        KeyboardButton(
            const Icon(
              Icons.fingerprint,
              size: 20,
            ),
            onTabSensor),
        KeyboardButton(
            const Text("0", style: buttonText), () => onTabNumber(0)),
        KeyboardButton(
            const Icon(
              Icons.clear,
              size: 20,
            ),
            onTabRemove),
      ],
    ));
  }
}

const TextStyle buttonText =
    TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w400);

class KeyboardButton extends StatelessWidget {
  final Widget child;
  final Function()? onTab;
  KeyboardButton(this.child, [this.onTab]);
  @override
  Widget build(BuildContext context) {
    return (TextButton(
      onPressed: onTab,
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
    ));
  }
}
