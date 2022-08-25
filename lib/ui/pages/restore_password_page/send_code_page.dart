import 'package:app/ui/pages/restore_password_page/restore_password_page.dart';
import 'package:app/ui/pages/restore_password_page/store/restore_password_store.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import '../../../observer_consumer.dart';
import 'package:easy_localization/easy_localization.dart';

final spacer = const SizedBox(
  height: 20.0,
);

class SendEmailPage extends StatefulWidget {
  static const String routeName = "/sendEmail";

  const SendEmailPage();

  @override
  State<SendEmailPage> createState() => _SendEmailPageState();
}

class _SendEmailPageState extends State<SendEmailPage> {
  late final RestorePasswordStore _store;

  @override
  void initState() {
    _store = context.read<RestorePasswordStore>();
    super.initState();
  }

  _stateListener() {
    if (_store.successData == RestorePasswordState.requestCode) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Provider(
            create: (_) => _store,
            child: RestorePasswordPage(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ObserverListener<RestorePasswordStore>(
      onSuccess: _stateListener,
      onFailure: () => false,
      child: Scaffold(
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
                      child: Observer(
                        builder: (context) {
                          return ElevatedButton(
                            onPressed: _store.email.isNotEmpty ? _store.requestCode : null,
                            child: _store.isLoading ? CircularProgressIndicator.adaptive() : Text("meta.submit".tr()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
