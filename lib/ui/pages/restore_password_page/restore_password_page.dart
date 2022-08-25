import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/restore_password_page/store/restore_password_store.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

final spacer = const SizedBox(
  height: 20.0,
);

class RestorePasswordPage extends StatefulWidget {
  const RestorePasswordPage();

  @override
  State<RestorePasswordPage> createState() => _RestorePasswordPageState();
}

class _RestorePasswordPageState extends State<RestorePasswordPage> {
  late final RestorePasswordStore _store;

  @override
  void initState() {
    _store = context.read<RestorePasswordStore>();
    super.initState();
  }

  _stateListener() {
    if (_store.successData == RestorePasswordState.restorePassword) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      AlertDialogUtils.showSuccessDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ObserverListener<RestorePasswordStore>(
      onSuccess: _stateListener,
      onFailure: () => false,
      child: Observer(
        builder: (_) => Scaffold(
          body: CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: Text(
                  "restore.title".tr(),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 20.0,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Text("modals.codeFromEmail".tr()),
                    const SizedBox(
                      height: 5.0,
                    ),
                    TextFormField(
                      onChanged: _store.setCode,
                      decoration: InputDecoration(
                        hintText: 'modals.code'.tr(),
                      ),
                    ),
                    spacer,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("modals.newPassword".tr()),
                        const SizedBox(
                          height: 5.0,
                        ),
                        TextFormField(
                          onChanged: _store.setPassword,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "modals.newPassword".tr(),
                          ),
                        ),
                      ],
                    ),
                    spacer,
                    SizedBox(
                      width: double.infinity,
                      child: Observer(
                        builder: (context) {
                          return ElevatedButton(
                            onPressed: _store.canSubmit ? _onPressedSubmit : null,
                            child: _store.isLoading ? CircularProgressIndicator.adaptive() : Text("meta.submit".tr()),
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
      ),
    );
  }

  _onPressedSubmit() {
    _store.restorePassword();
  }
}
