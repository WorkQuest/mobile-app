import 'package:app/ui/pages/sign_up_page/generate_wallet/create_wallet_store.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants.dart';
import '../../../../observer_consumer.dart';
import '../../../../utils/alert_dialog.dart';
import '../../../../utils/validator.dart';
import '../../../widgets/default_textfield.dart';
import '../../../widgets/login_button.dart';
import '../../pin_code_page/pin_code_page.dart';

class ImportWalletPage extends StatefulWidget {
  const ImportWalletPage({Key? key}) : super(key: key);

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
            "Import Wallet",
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
                  "Mnemonic",
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
                    title: "Import",
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
