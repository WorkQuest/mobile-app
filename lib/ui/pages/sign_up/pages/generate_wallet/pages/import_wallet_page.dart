import 'package:app/constants.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/pin_code_page/pin_code_page.dart';
import 'package:app/ui/pages/sign_up/pages/generate_wallet/pages/create_wallet_page/store/create_wallet_store.dart';
import 'package:app/ui/widgets/default_textfield.dart';
import 'package:app/ui/widgets/login_button.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/validator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImportWalletPage extends StatefulWidget {
  const ImportWalletPage({Key? key}) : super(key: key);

  static const String routeName = '/importWalletPage';

  @override
  _ImportWalletPageState createState() => _ImportWalletPageState();
}

class _ImportWalletPageState extends State<ImportWalletPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _mnemonicController;
  late CreateWalletStore store;

  @override
  void initState() {
    super.initState();
    _mnemonicController = TextEditingController();
    store = context.read<CreateWalletStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "wallet.importWallet".tr(),
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          centerTitle: true,
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: AppColor.enabledButton,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "signIn.mnemonic".tr(),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                DefaultTextField(
                  controller: _mnemonicController,
                  hint: "signIn.enterMnemonicPhrase".tr(),
                  isPassword: true,
                  onChanged: store.setMnemonic,
                  validator: Validators.mnemonicValidator,
                  inputFormatters: [],
                  suffixIcon: null,
                ),
                const SizedBox(
                  height: 10,
                ),
                Spacer(),
                ObserverListener<CreateWalletStore>(
                  onFailure: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    return false;
                  },
                  onSuccess: () async {
                    Navigator.of(context, rootNavigator: true).pop();
                    await AlertDialogUtils.showSuccessDialog(context);
                    Navigator.pushNamed(
                      context,
                      PinCodePage.routeName,
                    );
                  },
                  child: LoginButton(
                    withColumn: true,
                    enabled: store.isLoading,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        AlertDialogUtils.showLoadingDialog(context);
                        store.openWallet();
                      }
                    },
                    title: "wallet.importWallet".tr(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
