import 'package:app/ui/pages/restore_password_page/restore_password_page.dart';
import 'package:app/ui/pages/restore_password_page/store.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import '../../../observer_consumer.dart';
import 'package:easy_localization/easy_localization.dart';

final spacer = const SizedBox(
  height: 20.0,
);

class SendEmail extends StatelessWidget {

  static const String routeName = "/sendEmail";
  const SendEmail();

  @override
  Widget build(BuildContext context) {
    final _store = context.read<RestorePasswordStore>();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            heroTag: "restoreNavbar",
            largeTitle: Text(
              "login.forgot".tr(),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 20.0,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Text(
                    "restore.code".tr(),
                  ),
                  spacer,
                  Observer(
                    builder: (_) => TextFormField(
                      onChanged: _store.setEmail,
                      decoration: InputDecoration(
                        hintText: 'placeholders.email'.tr(),
                      ),
                    ),
                  ),
                  spacer,
                  SizedBox(
                    width: double.infinity,
                    child: ObserverListener<RestorePasswordStore>(
                      onSuccess: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RestorePasswordPage(_store),
                          ),
                        );
                      },
                      child: Observer(
                        builder: (context) {
                          return ElevatedButton(
                            onPressed: _store.email.isNotEmpty
                                ? _store.requestCode
                                : null,
                            child: _store.isLoading
                                ? CircularProgressIndicator.adaptive()
                                : Text(
                                    "meta.submit".tr(),
                                  ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
