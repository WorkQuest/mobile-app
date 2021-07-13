import 'package:app/ui/pages/sign_up_page/choose_role_page/choose_role_page.dart';
import 'package:app/ui/pages/sign_up_page/choose_role_page/store/choose_role_store.dart';
import 'package:app/ui/widgets/platform_activity_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CupertinoNavigationBar(
        previousPageTitle: "  back",
        border: Border.fromBorderSide(BorderSide.none),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Observer(builder: (context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Confirm your email",
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
                  "Code has been sent to your email",
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
                  "Check your email.",
                  style: _style,
                ),
                SizedBox(
                  height: 40.0,
                ),
                TextFormField(
                  onChanged: store.setCode,
                  decoration: InputDecoration(hintText: "Code"),
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
                            ? PlatformActivityIndicator()
                            : Text("Submit"),
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
          }),
        ),
      ),
    );
  }
}
