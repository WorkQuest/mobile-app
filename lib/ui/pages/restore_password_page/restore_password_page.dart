import 'package:app/ui/pages/restore_password_page/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:app/ui/widgets/platform_activity_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:easy_localization/easy_localization.dart';

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

final spacer = const SizedBox(
  height: 20.0,
);

class RestorePasswordPage extends StatelessWidget {
  final RestorePasswordStore _store;
  const RestorePasswordPage(this._store);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        body: CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: Text(
                "Restore Password",
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 20.0,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text("Code from Email"),
                  const SizedBox(
                    height: 5.0,
                  ),
                  TextFormField(
                    onChanged: _store.setCode,
                    decoration: InputDecoration(
                      hintText: 'code',
                    ),
                  ),
                  spacer,
                  titledTextField(
                    title: "modals.newPassword".tr(),
                    hint: "modals.newPassword".tr(),
                    onChanged: _store.setPassword,
                  ),
                  spacer,
                  SizedBox(
                    width: double.infinity,
                    child: Observer(
                      builder: (context) {
                        return ElevatedButton(
                          onPressed:() async =>
                              _store.canSubmit ? await  _store.restorePassword().then((value) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }) : null,
                          child: _store.isLoading
                              ? PlatformActivityIndicator()
                              : Text("meta.submit".tr()),
                        );
                      },
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
}
