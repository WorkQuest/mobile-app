import 'dart:async';
import 'dart:convert';

import "package:app/observer_consumer.dart";
import 'package:app/ui/pages/pin_code_page/pin_code_page.dart';
import "package:app/ui/pages/sign_in_page/store/sign_in_store.dart";
import 'package:app/ui/pages/sign_up_page/confirm_email_page/confirm_email_page.dart';
import "package:app/ui/pages/sign_up_page/sign_up_page.dart";
import "package:app/ui/widgets/platform_activity_indicator.dart";
import 'package:easy_localization/easy_localization.dart';
import 'package:app/utils/validator.dart';
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:provider/provider.dart";
import 'package:webview_flutter/webview_flutter.dart';

const double _horizontalConstraints = 44.0;
const double _verticalConstraints = 24.0;

const _prefixConstraints = const BoxConstraints(
  maxHeight: _verticalConstraints,
  maxWidth: _horizontalConstraints,
  minHeight: _verticalConstraints,
  minWidth: _horizontalConstraints,
);

class SignInPage extends StatelessWidget {
  static const String routeName = "/";
  final _formKey = GlobalKey<FormState>();

  SignInPage();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final signInStore = context.read<SignInStore>();

    return Form(
      key: _formKey,
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: SizedBox(
            height: mq.size.height,
            child: SafeArea(
              top: false,
              bottom: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Color(0xFF103D7C),
                            BlendMode.color,
                          ),
                          image: AssetImage(
                            "assets/login_page_header.png",
                          ),
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 30.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "signIn.welcomeToWorkQuest".tr(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                "signIn.pleaseSignIn".tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 0.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: signInStore.setUsername,
                      validator: Validators.emailValidator,
                      decoration: InputDecoration(
                        prefixIconConstraints: _prefixConstraints,
                        prefixIcon: SvgPicture.asset(
                          "assets/user.svg",
                          color: Theme.of(context).iconTheme.color,
                        ),
                        hintText: "auth.signIn.username".tr(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
                    child: TextFormField(
                      onChanged: signInStore.setPassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIconConstraints: _prefixConstraints,
                        prefixIcon: SvgPicture.asset(
                          "assets/lock.svg",
                          color: Theme.of(context).iconTheme.color,
                        ),
                        hintText: "auth.password".tr(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 0.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ObserverListener<SignInStore>(
                        onSuccess: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            PinCodePage.routeName,
                            (_) => false,
                          );
                        },
                        onFailure: () {
                          if (signInStore.errorMessage == "unconfirmed") {
                            Navigator.pushNamed(context, ConfirmEmail.routeName,
                                arguments: signInStore.getUsername());
                            return true;
                          }
                          return false;
                        },
                        child: Observer(
                          builder: (context) {
                            return ElevatedButton(
                              onPressed: signInStore.canSignIn
                                  ? () async {
                                      if (_formKey.currentState!.validate()) {
                                        await signInStore.signInWithUsername();
                                      }
                                    }
                                  : null,
                              child: signInStore.isLoading
                                  ? PlatformActivityIndicator()
                                  : Text(
                                      "signIn.login".tr(),
                                    ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: Text(
                        "signIn.or".tr(),
                        style: TextStyle(
                          color: Color(0xFFCBCED2),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      top: 20.0,
                      right: 16,
                    ),
                    child: _iconsView(signInStore),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      top: 40.0,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "signIn.account".tr(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, SignUpPage.routeName);
                            },
                            child: Text(
                              "signIn.signUp".tr(),
                              style: TextStyle(
                                color: Color(0xFF0083C7),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      top: 10.0,
                      bottom: 40.0,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            onForgotPasswordClicked(context);
                          },
                          child: Text(
                            "signIn.forgotYourPass".tr(),
                            style: TextStyle(
                              color: Color(0xFF0083C7),
                            ),
                          ),
                        ),
                        Spacer(),
                        const Text("Version 1.0.24"),
                        const SizedBox(width: 15)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconsView(final SignInStore store) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _iconButton(
          store.signInWithTwitter,
          "assets/google_icon.svg",
          "https://www.instagram.com/zuck/?hl=ru",
        ),
        // _iconButton(
        //   "assets/instagram.svg",
        //   "https://www.instagram.com/zuck/?hl=ru",
        // ),
        _iconButton(
          () {},
          "assets/twitter_icon.svg",
          "https://www.instagram.com/zuck/?hl=ru",
        ),
        _iconButton(
          () {},
          "assets/facebook_icon.svg",
          "https://www.instagram.com/zuck/?hl=ru",
        ),
        _iconButton(
          () {},
          "assets/linkedin_icon.svg",
          "https://www.instagram.com/zuck/?hl=ru",
        ),
      ],
    );
  }

  Widget _iconButton(
    Function onTap,
    String iconPath,
    String link, [
    Color? color,
  ]) {
    return CupertinoButton(
      color: Color(0xFFF7F8FA),
      padding: EdgeInsets.zero,
      child: SvgPicture.asset(
        iconPath,
        color: color,
      ),
      onPressed: () {}

      // => Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => SocialNetworkLogin(),
      //   ),
      // ),
    );
  }

  void onForgotPasswordClicked(BuildContext context) {
    return;
  }
}

class SocialNetworkLogin extends StatelessWidget {
  SocialNetworkLogin({Key? key}) : super(key: key);

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: '',
      onWebViewCreated: (WebViewController webViewController) async {
        _controller.complete(webViewController);
        //_controller = webViewController;
        await loadHtmlFromAssets(
          'legal/privacy_policy.html',
          _controller,
        );
      },
    );
  }

  Future<void> loadHtmlFromAssets(
    String filename,
    controller,
  ) async {
    String fileText = await rootBundle.loadString(filename);
    controller.loadUrl(
      Uri.dataFromString(
        fileText,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ).toString(),
    );
  }
}
