import 'package:app/ui/pages/pin_code_page/pin_code_page.dart';
import 'package:app/ui/pages/sign_in_page/sign_in_page.dart';
import 'package:app/ui/pages/sign_in_page/store/sign_in_store.dart';
import 'package:app/ui/widgets/default_textfield.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/storage.dart';
import 'package:app/utils/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../constants.dart';
import '../../widgets/login_button.dart';
import '../profile_me_store/profile_me_store.dart';

class MnemonicPage extends StatelessWidget {
  MnemonicPage();

  static const String routeName = '/mnemonicPage';
  final TextEditingController mnemonicController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final signInStore = context.read<SignInStore>();
    final profile = context.read<ProfileMeStore>();

    return WillPopScope(
      onWillPop: () async {
        Storage.deleteAllFromSecureStorage();
        signInStore.deletePushToken();
        Navigator.of(context, rootNavigator: true)
            .pushNamedAndRemoveUntil(SignInPage.routeName, (route) => false);
        return true;
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: CupertinoNavigationBar(
            leading: Container(
              width: 50,
              height: 50,
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () async {
                    await signInStore.deletePushToken();
                    Storage.deleteAllFromSecureStorage();
                    Navigator.of(context, rootNavigator: true)
                        .pushNamedAndRemoveUntil(
                      SignInPage.routeName,
                      (route) => false,
                    );
                  },
                  child: SvgPicture.asset("assets/arrow_back.svg"),
                ),
              ),
            ),
            middle: Text("signIn.enterMnemonicPhrase".tr()),
            border: Border.fromBorderSide(BorderSide.none),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
                child: DefaultTextField(
                  controller: mnemonicController,
                  isPassword: true,
                  onChanged: signInStore.setMnemonic,
                  validator: Validators.mnemonicValidator,
                  suffixIcon: CupertinoButton(
                    minSize: 22.0,
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      ClipboardData? data =
                          await Clipboard.getData(Clipboard.kTextPlain);
                      mnemonicController.text = data?.text ?? "";
                      signInStore.setMnemonic(data?.text ?? "");
                    },
                    child: Icon(
                      Icons.paste,
                      size: 22.0,
                      color: AppColor.primary,
                    ),
                  ),
                  hint: "signIn.enterMnemonicPhrase".tr(),
                  inputFormatters: [],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 0.0),
                child: Observer(
                  builder: (context) {
                    return LoginButton(
                      onTap: signInStore.mnemonic.isNotEmpty
                          ? signInStore.isLoading
                              ? () {}
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    await signInStore.refreshToken();
                                    await profile.getProfileMe();
                                    await signInStore.signInWallet();

                                    if (signInStore.isSuccess &&
                                        signInStore.error.isEmpty) {
                                      await AlertDialogUtils.showSuccessDialog(
                                          context);
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        PinCodePage.routeName,
                                        (_) => false,
                                      );
                                    } else {
                                      _errorMessage(context, signInStore.error);
                                    }
                                  }
                                }
                          : null,
                      title: "signIn.login".tr(),
                      enabled: signInStore.isLoading,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _errorMessage(BuildContext context, String msg) =>
      AlertDialogUtils.showAlertDialog(
        context,
        title: Text("Error"),
        content: Text(msg),
        needCancel: false,
        titleCancel: null,
        titleOk: null,
        onTabCancel: null,
        onTabOk: null,
        colorCancel: null,
        colorOk: null,
      );
}
