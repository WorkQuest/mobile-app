import 'dart:io';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/2FA_page/2FA_store.dart';
import 'package:app/ui/widgets/platform_activity_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import "package:provider/provider.dart";
import 'package:url_launcher/url_launcher.dart';

final _spacer = Spacer();

class TwoFAPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = context.read<TwoFAStore>();
    return ObserverListener<TwoFAStore>(
      onSuccess: () {},
      child: Observer(
        builder: (_) => Scaffold(
          appBar: CupertinoNavigationBar(
            automaticallyImplyLeading: true,
            middle: Text("2FA"),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20.0,
                    alignment: AlignmentDirectional.centerStart,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFF7F8FA),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) => Observer(
                        builder: (_) => AnimatedContainer(
                          width: constraints.maxWidth * (store.index + 1) / 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue,
                          ),
                          duration: const Duration(
                            milliseconds: 150,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "Step ${store.index + 1}",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 23.0,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Expanded(
                    child: IndexedStack(
                      index: store.index,
                      children: [
                        ///Step 1
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Download and install the Google Authenticator app",
                            ),
                            IconButton(
                              onPressed: () {
                                try {
                                  Platform.isIOS
                                      ? launch("market://details?id=" +
                                          "id388497605")
                                      : launch(
                                          "https://play.google.com/store/apps/details?id=" +
                                              "com.google.android.apps.authenticator2");
                                } catch (e) {
                                  print(e);
                                }
                              },
                              iconSize: 150,
                              icon: SvgPicture.asset(
                                Platform.isIOS
                                    ? "assets/open_ios_appstore.svg"
                                    : "assets/open_google_play.svg",
                              ),
                            ),
                            Text(
                              "Continue to next step if you already have Google Authenticator app",
                            ),
                            _spacer,
                            buttonRow(
                              store,
                              forward: "Next",
                              back: "Cancel",
                            ),
                          ],
                        ),

                        ///Step 2
                        Column(
                          children: [
                            Text("Please keep this key on paper."
                                " This key will allow you to restore your "
                                "Google Authenticator in case of phone loss."),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                    "assets/2FA_attention_icon.svg"),

                                Text(
                                  store.googleAuthenticatorSecretCode,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF7F8FA),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: InkWell(
                                    onTap: () => Clipboard.setData(
                                      new ClipboardData(
                                        text: "email",
                                      ),
                                    ).then((_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 1),
                                          content: Text(
                                            "Code copied to clipboard",
                                          ),
                                        ),
                                      );
                                    }),
                                    child: SvgPicture.asset(
                                        "assets/copy_icon.svg"),
                                  ),
                                ),
                              ],
                            ),
                            _spacer,
                            buttonRow(
                              store,
                              forward: "Next",
                              back: "Cancel",
                            ),
                          ],
                        ),

                        /// Step 3
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                "Open the Google Authenticator app and paste your secret code"),
                            const SizedBox(
                              height: 10.0,
                            ),
                            _spacer,
                            buttonRow(
                              store,
                              forward: "Open App",
                              back: "Back",
                            ),
                          ],
                        ),

                        ///Step 4
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Enable Google Authenticator"),
                            const SizedBox(
                              height: 25.0,
                            ),
                            Text("Code from email"),
                            const SizedBox(
                              height: 5.0,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: "5MYKZEJFNNXHYWXT",
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "Enter the 6-digit code received at 1234***@gmail.com.",
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Text("Code from Google Authenticator"),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: "5MYKZEJFNNXHYWXT",
                              ),
                            ),
                            Text(
                              "Enter the 6-digit code from the Google Authenticator app.",
                            ),
                            _spacer,
                            buttonRow(
                              store,
                              forward: "Finish",
                              back: "Back",
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///Bottom row buttons
  Widget buttonRow(
    TwoFAStore store, {
    required String forward,
    required String back,
  }) =>
      Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 45.0,
              child: OutlinedButton(
                onPressed: () {
                  if (store.index > 0) store.index--;
                },
                child: Text(back),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    width: 1.0,
                    color: Color(0xFF0083C7).withOpacity(0.1),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                if (store.index == 0) {
                  await store.enable2FA();
                }
                if (store.index < 3) store.index++;
                //print("${store.index}");
              },
              child: store.isLoading
                  ? Center(
                      child: PlatformActivityIndicator(),
                    )
                  : Text(forward),
            ),
          ),
        ],
      );
}
