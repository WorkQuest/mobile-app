import 'package:app/ui/pages/sign_up_page/generate_wallet/create_wallet_page.dart';
import 'package:app/ui/pages/sign_up_page/generate_wallet/import_wallet_page.dart';
import 'package:app/ui/widgets/login_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class WalletsPage extends StatelessWidget {
  const WalletsPage({Key? key}) : super(key: key);

  static const String routeName = '/walletPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "wallet.chooseWallet".tr(),
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            LoginButton(
              title: "wallet.importWallet".tr(),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, ImportWalletPage.routeName);
              },
            ),
            const SizedBox(height: 10),
            LoginButton(
              title: "wallet.createWallet".tr(),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, CreateWalletPage.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
