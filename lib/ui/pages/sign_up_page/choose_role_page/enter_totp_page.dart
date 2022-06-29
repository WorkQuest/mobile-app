import 'package:app/ui/pages/sign_in_page/sign_in_page.dart';
import 'package:app/ui/pages/sign_up_page/choose_role_page/store/choose_role_store.dart';
import 'package:app/ui/widgets/error_dialog.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class EnterTotpPage extends StatelessWidget {
  static const String routeName = '/enterTotpPade';

  const EnterTotpPage();

  @override
  Widget build(BuildContext context) {
    final store = context.read<ChooseRoleStore>();

    return Scaffold(
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
                    onPressed: store.totp.isNotEmpty
                        ? () async {
                            await store.changeRole();
                            if (store.isSuccess) {
                              Storage.deleteAllFromSecureStorage();
                              await store.deletePushToken();
                              await AlertDialogUtils.showSuccessDialog(context);
                              Navigator.of(context, rootNavigator: true)
                                  .pushNamedAndRemoveUntil(
                                SignInPage.routeName,
                                (route) => false,
                              );
                            } else
                              await errorAlert(context, "errors.wrongCode".tr());
                          }
                        : null,
                    child: store.isLoading
                        ? CircularProgressIndicator()
                        : Text("meta.accept".tr()),
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
    );
  }
}
