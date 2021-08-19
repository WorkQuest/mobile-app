import 'package:app/ui/pages/main_page/settings_page/store/settings_store.dart';
import 'package:app/ui/widgets/platform_activity_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";

import '../../../../../observer_consumer.dart';

final spacer = const SizedBox(
  height: 20.0,
);

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  static const String routeName = "/changePasswordPage";

  @override
  Widget build(BuildContext context) {
    final settingsStore = context.read<SettingsPageStore>();
    return Observer(
      builder: (_) => Scaffold(
        appBar: CupertinoNavigationBar(
          automaticallyImplyLeading: true,
          middle: Text("Change Password"),
        ),
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  titledTextField(
                    title: "Old Password",
                    hint: "Old Password",
                    onChanged: settingsStore.setPassword,
                  ),
                  spacer,
                  titledTextField(
                    title: "New Password",
                    hint: "New Password",
                    onChanged: settingsStore.setNewPassword,
                  ),
                  spacer,
                  titledTextField(
                    title: "Confirm Password",
                    hint: "Confirm new password",
                    onChanged: settingsStore.setConfirmNewPassword,
                  ),
                  spacer,
                  SizedBox(
                    width: double.infinity,
                    child: ObserverListener<SettingsPageStore>(
                      onSuccess: () {
                        Navigator.pop(context);
                      },
                      child: Observer(
                        builder: (context) {
                          return ElevatedButton(
                            onPressed: settingsStore.canSubmit
                                ? () async {
                                    await settingsStore.changePassword();
                                  }
                                : null,
                            child: settingsStore.isLoading
                                ? PlatformActivityIndicator()
                                : Text("Submit"),
                          );
                        },
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget titledTextField({
    required String title,
    required String hint,
    required Function(String) onChanged,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(
            height: 5.0,
          ),
          TextFormField(
            onChanged: onChanged,
            obscureText: true,
            decoration: InputDecoration(
              hintText: hint,
            ),
          ),
        ],
      );
}
