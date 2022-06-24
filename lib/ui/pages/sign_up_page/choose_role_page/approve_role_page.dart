import 'package:app/constants.dart';
import 'package:app/di/injector.dart';
import 'package:app/enums.dart';
import 'package:app/ui/pages/sign_up_page/choose_role_page/enter_totp_page.dart';
import 'package:app/ui/pages/sign_up_page/generate_wallet/create_wallet_page.dart';
import 'package:app/ui/pages/sign_up_page/generate_wallet/create_wallet_store.dart';
import 'package:app/ui/pages/sign_up_page/generate_wallet/import_wallet_page.dart';
import 'package:app/ui/widgets/login_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class ApproveRolePage extends StatelessWidget {
  final store;

  const ApproveRolePage(this.store);

  static const String routeName = '/approveRolePage';

  final String _baseUrl = "https://testnet-app.workquest.co/";

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        previousPageTitle: "  " + "meta.back".tr(),
        border: Border.fromBorderSide(BorderSide.none),
      ),
      body: Observer(
        builder: (ctx) {
          print('store: ${this.store.userRole}');
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  !store.isChange
                      ? "role.yourRole".tr() +
                          " ${store.userRole.toString().split(".").last} " +
                          "role.right".tr()
                      : "role.change".tr() + " ${store.getRole()} " + "role.right".tr(),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                getCard(
                  store.isChange
                      ? store.userRole == UserRole.Worker
                          ? UserRole.Employer
                          : UserRole.Worker
                      : store.userRole == UserRole.Worker
                          ? UserRole.Worker
                          : UserRole.Employer,
                ),
                CheckboxListTile(
                  contentPadding: const EdgeInsets.all(0),
                  value: store.privacyPolicy,
                  onChanged: (value) => store.setPrivacyPolicy(value!),
                  controlAffinity: ListTileControlAffinity.leading,
                  title: checkBoxText(
                    ctx,
                    urlLink: "docs/privacy.pdf",
                    title: 'privacy.privacyLink'.tr(),
                  ),
                ),
                CheckboxListTile(
                  contentPadding: const EdgeInsets.all(0),
                  value: store.termsAndConditions,
                  onChanged: (value) => store.setTermsAndConditions(value!),
                  controlAffinity: ListTileControlAffinity.leading,
                  title: checkBoxText(
                    ctx,
                    urlLink: "docs/terms.pdf",
                    title: 'privacy.termsLink'.tr(),
                  ),
                ),
                CheckboxListTile(
                  contentPadding: const EdgeInsets.all(0),
                  value: store.amlAndCtfPolicy,
                  onChanged: (value) => store.setAmlAndCtfPolicy(value!),
                  controlAffinity: ListTileControlAffinity.leading,
                  title: checkBoxText(
                    ctx,
                    urlLink: "docs/aml.pdf",
                    title: 'privacy.amlLink'.tr(),
                  ),
                ),
                Spacer(),
                SafeArea(
                  child: LoginButton(
                    enabled: store.isLoading,
                    withColumn: true,
                    onTap: store.canApprove
                        ? () async {
                            if (!store.isChange) await store.approveRole();
                            !store.isChange
                                ? showDialog(
                                    context: ctx,
                                    builder: (context) {
                                      return AlertDialog(
                                        scrollable: true,
                                        title: Text("Wallet"),
                                        content: Text("Choose a way to add a wallet"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => Provider(
                                                    create: (context) =>
                                                        getIt.get<CreateWalletStore>(),
                                                    child: ImportWalletPage(),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              "Import Wallet",
                                              style: TextStyle(
                                                  color: AppColor.enabledButton),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => Provider(
                                                    create: (context) =>
                                                        getIt.get<CreateWalletStore>(),
                                                    child: CreateWalletPage(),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              "Create Wallet",
                                              style: TextStyle(
                                                  color: AppColor.enabledButton),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  )
                                : Navigator.of(ctx, rootNavigator: true)
                                    .pushNamed(EnterTotpPage.routeName);

                            //Navigator.pushNamed(ctx, PinCodePage.routeName);
                          }
                        : null,
                    title: "meta.iAgree".tr(),
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

  Widget checkBoxText(
    BuildContext context, {
    required String urlLink,
    required String title,
  }) {
    return Row(
      children: [
        Text(
          'privacy.agree'.tr() + ' ',
          style: TextStyle(
            fontSize: 16.0,
            color: Color(0xFF1D2127),
          ),
        ),
        GestureDetector(
          onTap: () async {
            await launch(_baseUrl + urlLink);
          },
          child: Text(
            title,
            style: TextStyle(
              color: Color(0xFF0083C7),
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget getCard(UserRole role) {
    return Center(
      child: Stack(
        children: [
          Image.asset(
            "assets/${role.name.toLowerCase()}.jpg",
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, top: 20),
            width: 146,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "role.${role.name.toLowerCase()}".tr(),
                  style: TextStyle(
                      color: role == UserRole.Worker ? Colors.white : Color(0xFF1D2127),
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "role.${role.name.toLowerCase()}Want".tr(),
                  style: TextStyle(
                    color: role == UserRole.Worker ? Colors.white : Color(0xFF1D2127),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
