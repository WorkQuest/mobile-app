import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/sign_up/pages/choose_role/pages/choose_role_page/choose_role_page.dart';
import 'package:app/ui/pages/sign_up/pages/choose_role/pages/choose_role_page/store/choose_role_store.dart';
import 'package:app/ui/widgets/alert_dialog.dart';
import 'package:app/ui/widgets/login_button.dart';
import 'package:app/ui/widgets/timer.dart';
import 'package:app/utils/storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';


const TextStyle _style = TextStyle(
  color: Color(0xFF1D2127),
  fontSize: 16.0,
);

const SizedBox _divider = SizedBox(height: 10);

class ConfirmEmail extends StatefulWidget {
  final ConfirmEmailArguments arguments;

  const ConfirmEmail(this.arguments);

  static const String routeName = '/confirmEmailPage';

  @override
  State<ConfirmEmail> createState() => _ConfirmEmailState();
}

class _ConfirmEmailState extends State<ConfirmEmail> {
  late ChooseRoleStore store;

  @override
  void initState() {
    store = context.read<ChooseRoleStore>();
    if (widget.arguments.code != null) {
      store.setCode(widget.arguments.code!);
      store.confirmEmail();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObserverListener<ChooseRoleStore>(
      onSuccess: () {
        Navigator.pushNamed(
          context,
          ChooseRolePage.routeName,
        );
      },
      onFailure: () => false,
      child: WillPopScope(
        onWillPop: () async {
          return alertDialog(context);
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: CupertinoNavigationBar(
            previousPageTitle: "  " + "meta.back".tr(),
            border: Border.fromBorderSide(BorderSide.none),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Observer(
                builder: (context) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "registration.confirmYourEmail".tr(),
                        style: TextStyle(
                          color: Color(0xFF1D2127),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "registration.emailConfirm".tr(),
                        style: _style,
                      ),
                      _divider,
                      Text(
                        "${widget.arguments.email}",
                        style: _style.copyWith(
                          color: Colors.blue,
                        ),
                      ),
                      _divider,
                      Text(
                        "registration.emailConfirmTitle".tr(),
                        style: _style,
                      ),
                      const SizedBox(height: 5),
                      TimerWidget(
                        startTimer: () => store.startTimer(widget.arguments.email!),
                        seconds: store.secondsCodeAgain,
                        isActiveTimer: store.timer != null && store.timer!.isActive,
                      ),
                      const SizedBox(height: 40.0),
                      TextFormField(
                        onChanged: store.setCode,
                        decoration: InputDecoration(
                          hintText: "modals.code".tr(),
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      Observer(
                        builder: (context) {
                          return LoginButton(
                            onTap: store.canSubmitCode && !store.isLoading ? _onPressedSubmit : null,
                            title: "meta.submit".tr(),
                          );
                        },
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(left: 16.0, bottom: 20.0),
                        child: Row(
                          children: [
                            Text(
                              "signUp.didntCode".tr(),
                              style: _style,
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: _onPressedChangeEmail,
                              child: Text(
                                "signUp.changeEmail".tr(),
                                style: _style.copyWith(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onPressedSubmit() {
    store.confirmEmail();
  }

  _onPressedChangeEmail() {
    Navigator.pop(context);
  }

  Future<bool> alertDialog(BuildContext context) async {
    dialog(
      context,
      title: "modals.attention".tr(),
      message: "modals.goBack".tr(),
      confirmAction: () {
        Storage.deleteAllFromSecureStorage();
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
    return true;
  }
}

class ConfirmEmailArguments {
  ConfirmEmailArguments({this.email, this.code});

  String? email;
  String? code;
}
