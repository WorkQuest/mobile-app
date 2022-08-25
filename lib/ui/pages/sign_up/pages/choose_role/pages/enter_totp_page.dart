import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/sign_in_page/sign_in_page.dart';
import 'package:app/ui/pages/sign_up/pages/choose_role/pages/choose_role_page/store/choose_role_store.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class EnterTotpPage extends StatefulWidget {
  static const String routeName = '/enterTotpPade';

  const EnterTotpPage();

  @override
  State<EnterTotpPage> createState() => _EnterTotpPageState();
}

class _EnterTotpPageState extends State<EnterTotpPage> {
  late final ChooseRoleStore store;

  @override
  void initState() {
    store = context.read<ChooseRoleStore>();
    super.initState();
  }

  @override
  void dispose() {
    store.clearData();
    super.dispose();
  }

  _stateListener() async {
    if (store.successData == ChooseRoleState.changeRole) {
      store.deletePushToken();
    } else if (store.successData == ChooseRoleState.deletePushToken) {
      await AlertDialogUtils.showSuccessDialog(context);
      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        SignInPage.routeName,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ObserverListener<ChooseRoleStore>(
      onSuccess: _stateListener,
      onFailure: () => false,
      child: Scaffold(
        appBar: CupertinoNavigationBar(
          previousPageTitle: "  " + "meta.back".tr(),
          border: Border.fromBorderSide(BorderSide.none),
        ),
        body: Observer(
          builder: (_) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "modals.enter2FaCode".tr(),
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    maxLines: 1,
                    onChanged: store.setTotp,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "signIn.totp".tr(),
                    ),
                  ),
                  Spacer(),
                  SafeArea(
                    child: ElevatedButton(
                      onPressed: store.totp.isNotEmpty ? _onPressedAccept : null,
                      child: store.isLoading ? CircularProgressIndicator() : Text("meta.accept".tr()),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _onPressedAccept() {
    store.changeRole();
  }
}
