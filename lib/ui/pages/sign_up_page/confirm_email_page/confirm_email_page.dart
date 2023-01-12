import 'package:app/ui/pages/sign_up_page/choose_role_page/choose_role_page.dart';
import 'package:app/ui/pages/sign_up_page/choose_role_page/store/choose_role_store.dart';
import 'package:app/ui/widgets/alert_dialog.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../observer_consumer.dart';

const TextStyle _style = TextStyle(
  color: Color(0xFF1D2127),
  fontSize: 16.0,
);

const SizedBox _divider = SizedBox(
  height: 10,
);

class ConfirmEmail extends StatelessWidget {
  final email;

  const ConfirmEmail(this.email);

  static const String routeName = '/confirmEmailPage';

  Widget build(BuildContext context) {
    final store = context.read<ChooseRoleStore>();

    return WillPopScope(
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
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "registration.confirmYourEmail".tr(),
                      style: TextStyle(
                        color: Color(0xFF1D2127),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "registration.emailConfirm".tr(),
                      style: _style,
                    ),
                    _divider,
                    Text(
                      "$email",
                      style: _style.copyWith(
                        color: Colors.blue,
                      ),
                    ),
                    _divider,
                    Text(
                      "registration.emailConfirmTitle".tr(),
                      style: _style,
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    TextFormField(
                      onChanged: store.setCode,
                      decoration: InputDecoration(
                        hintText: "modals.code".tr(),
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    ObserverListener<ChooseRoleStore>(
                      onSuccess: () {
                        Navigator.pushNamed(
                          context,
                          ChooseRolePage.routeName,
                        );
                      },
                      child: Observer(
                        builder: (context) {
                          return ElevatedButton(
                            onPressed: store.canSubmitCode
                                ? () async {
                                    await store.confirmEmail();
                                  }
                                : null,
                            child: store.isLoading
                                ? CircularProgressIndicator.adaptive()
                                : Text(
                                    "meta.submit".tr(),
                                  ),
                          );
                        },
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, bottom: 20.0),
                      child: Row(
                        children: [
                          Text(
                            "Didn't get code?",
                            style: _style,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Change Email",
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
    );
  }

  Future<bool> alertDialog(BuildContext context) async {
    dialog(
      context,
      title: "modals.attention".tr(),
      message: "modals.goBack".tr(),
      confirmAction: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
    return true;
  }
}
