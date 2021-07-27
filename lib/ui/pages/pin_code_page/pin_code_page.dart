import "package:app/app_localizations.dart";
import "package:app/constants.dart";
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
  final _formKey = GlobalKey<FormState>();

  PinCodePage();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final pinCodeStore = context.read<PinCodeStore>();

    return Form(
      key: _formKey,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 0.0),
            child: SizedBox(
              width: double.infinity,
              child: ObserverListener<PinCodeStore>(
                onSuccess: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    MainPage.routeName,
                    (_) => false,
                  );
                },
                child: Observer(
                  builder: (context) {
                    return ElevatedButton(
                      onPressed: () async {
                        await pinCodeStore.signIn();
                      },
                      child: pinCodeStore.isLoading
                          ? PlatformActivityIndicator()
                          : Text(
                              context.translate(AuthLangKeys.login),
                            ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
