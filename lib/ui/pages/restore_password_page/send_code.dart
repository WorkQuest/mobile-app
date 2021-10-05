import 'package:app/ui/pages/restore_password_page/restore_password_page.dart';
import 'package:app/ui/pages/restore_password_page/store.dart';
import 'package:app/ui/widgets/platform_activity_indicator.dart';
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
  const SendEmail();

  @override
  Widget build(BuildContext context) {
    final _store = context.read<RestorePasswordStore>();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(
              "restore.enterEmail".tr(),
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
                        hintText: 'email@yahoo.com',
                      ),
                    ),
                  ),
                  spacer,
                  SizedBox(
                    width: double.infinity,
                    child: ObserverListener<RestorePasswordStore>(
                      onSuccess: () {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).push(
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
                                ? PlatformActivityIndicator()
                                : Text("meta.submit".tr()),
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
