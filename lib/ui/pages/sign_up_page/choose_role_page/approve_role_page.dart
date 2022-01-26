import 'package:app/enums.dart';
import 'package:app/ui/pages/sign_up_page/generate_wallet/create_wallet_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class ApproveRolePage extends StatelessWidget {
  final store;

  const ApproveRolePage(this.store);

  static const String routeName = '/approveRolePage';

  final String _baseUrl = "https://app-ver1.workquest.co/";

  @override
  Widget build(BuildContext ctx) {
    print('store: ${this.store.userRole}');
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
                  "role.yourRole".tr() +
                      " ${store.userRole.toString().split(".").last} " +
                      "role.right".tr(),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                store.userRole == UserRole.Worker
                    ? getWorkerCard()
                    : getEmployerCard(),
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
                  child: ElevatedButton(
                    onPressed: store.canApprove
                        ? () async {
                            await store.approveRole();
                            Navigator.push(
                                ctx,
                                MaterialPageRoute(
                                    builder: (_) => CreateWalletPage()));
                            //Navigator.pushNamed(ctx, PinCodePage.routeName);
                          }
                        : null,
                    child: store.isLoading
                        ? CircularProgressIndicator.adaptive()
                        : Text(
                            "meta.iAgree".tr()),
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

  Widget getWorkerCard() {
    return Center(
      child: Stack(
        children: [
          Image.asset(
            "assets/worker.jpg",
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, top: 20),
            width: 146,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "role.worker".tr(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "role.workerWant".tr(),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getEmployerCard() {
    return Center(
      child: Stack(
        children: [
          Image.asset(
            "assets/employer.jpg",
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, top: 20),
            width: 146,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "role.employer".tr(),
                  style: TextStyle(
                      color: Color(0xFF1D2127),
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "role.employerWant".tr(),
                  style: TextStyle(color: Color(0xFF1D2127)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
