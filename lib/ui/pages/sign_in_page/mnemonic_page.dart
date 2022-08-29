import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/pin_code_page/pin_code_page.dart';
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
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

import '../../../constants.dart';
import '../../widgets/login_button.dart';

class MnemonicPage extends StatefulWidget {
  MnemonicPage({
    Key? key,
  }) : super(key: key);

  static const String routeName = '/mnemonicPage';

  @override
  State<MnemonicPage> createState() => _MnemonicPageState();
}

class _MnemonicPageState extends State<MnemonicPage> {
  late final SignInStore store;
  late final TextEditingController mnemonicController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    mnemonicController = TextEditingController();
    store = context.read<SignInStore>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObserverListener<SignInStore>(
      onSuccess: () async {
        if (store.successData == SignInStoreState.signInWallet) {
          await AlertDialogUtils.showSuccessDialog(context);
          Navigator.pushNamedAndRemoveUntil(
            context,
            PinCodePage.routeName,
            (_) => false,
          );
        } else if (store.successData == SignInStoreState.refreshToken) {
          store.signInWallet();
        }
      },
      onFailure: () => false,
      child: WillPopScope(
        onWillPop: () async {
          await _onBackPressed();
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
                      await _onBackPressed();
                      Navigator.pop(context);
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
                    onChanged: store.setMnemonic,
                    validator: Validators.mnemonicValidator,
                    suffixIcon: CupertinoButton(
                      minSize: 22.0,
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        ClipboardData? data =
                            await Clipboard.getData(Clipboard.kTextPlain);
                        mnemonicController.text = data?.text ?? "";
                        store.setMnemonic(data?.text ?? "");
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
                        enabled: store.isLoading,
                        onTap:
                            store.mnemonic.isNotEmpty ? _onPressedLogin : null,
                        title: "signIn.login".tr(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onBackPressed() async {
    WebviewCookieManager().clearCookies();
    await store.deletePushToken();
    Storage.deleteAllFromSecureStorage();
  }

  _onPressedLogin() {
    if (_formKey.currentState!.validate()) {
      store.refreshToken();
    }
  }
}
