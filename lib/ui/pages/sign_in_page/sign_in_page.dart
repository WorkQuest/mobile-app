import 'package:app/constants.dart';
import 'package:app/ui/pages/pin_code_page/pin_code_page.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/pages/restore_password_page/send_code.dart';
import "package:app/ui/pages/sign_in_page/store/sign_in_store.dart";
import 'package:app/ui/pages/sign_up_page/confirm_email_page/confirm_email_page.dart';
import "package:app/ui/pages/sign_up_page/sign_up_page.dart";
import 'package:app/utils/alert_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:app/utils/validator.dart';
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:provider/provider.dart";

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

  final TextEditingController mnemonicController = new TextEditingController();

  SignInPage();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final signInStore = context.read<SignInStore>();
    final profile = context.read<ProfileMeStore>();

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
                  AutofillGroup(
                    child: Expanded(
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
                                "modals.welcomeToWorkQuest".tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
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
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 0.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: signInStore.setUsername,
                      validator: Validators.emailValidator,
                      autofillHints: [AutofillHints.email],
                      decoration: InputDecoration(
                        prefixIconConstraints: _prefixConstraints,
                        prefixIcon: SvgPicture.asset(
                          "assets/user.svg",
                          color: Theme.of(context).iconTheme.color,
                        ),
                        hintText: "signIn.username".tr(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
                    child: TextFormField(
                      onChanged: signInStore.setPassword,
                      obscureText: true,
                      autofillHints: [AutofillHints.password],
                      decoration: InputDecoration(
                        prefixIconConstraints: _prefixConstraints,
                        prefixIcon: SvgPicture.asset(
                          "assets/lock.svg",
                          color: Theme.of(context).iconTheme.color,
                        ),
                        hintText: "signIn.password".tr(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
                    child: TextFormField(
                      onChanged: signInStore.setTotp,
                      obscureText: true,
                      autofillHints: [AutofillHints.password],
                      decoration: InputDecoration(
                        prefixIconConstraints: _prefixConstraints,
                        prefixIcon: SvgPicture.asset(
                          "assets/lock.svg",
                          color: Theme.of(context).iconTheme.color,
                        ),
                        hintText: "signIn.totp".tr(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
                    child: TextFormField(
                      onChanged: signInStore.setMnemonic,
                      validator: Validators.mnemonicValidator,
                      controller: mnemonicController,
                      decoration: InputDecoration(
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
                        hintText: "signIn.enterMnemonicPhrase".tr(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 0.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Observer(
                        builder: (context) {
                          return ElevatedButton(
                            onPressed: signInStore.canSignIn
                                ? () async {
                                    if (_formKey.currentState!.validate()) {
                                      await signInStore.signIn();
                                      if (signInStore.isSuccess)
                                        await profile.getProfileMe();
                                      else {
                                        signInStore.onSuccess(false);
                                        _errorMessage(
                                            context, signInStore.errorMessage);
                                        return;
                                      }
                                      if (profile.isSuccess)
                                        await signInStore.signInWallet();
                                      if (signInStore.isSuccess) {
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          PinCodePage.routeName,
                                          (_) => false,
                                        );
                                      } else {
                                        signInStore.onSuccess(false);
                                        _errorMessage(
                                            context, profile.errorMessage);
                                        if (signInStore.errorMessage ==
                                            "unconfirmed") {
                                          print("error");
                                          Navigator.pushNamed(
                                              context, ConfirmEmail.routeName,
                                              arguments:
                                                  signInStore.getUsername());
                                        }
                                      }
                                    }
                                  }
                                : null,
                            child: signInStore.isLoading
                                ? CircularProgressIndicator.adaptive()
                                : Text(
                                    "signIn.login".tr(),
                                  ),
                          );
                        },
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _iconButton(
                          "assets/google_icon.svg",
                          "google",
                          context,
                        ),
                        // _iconButton(
                        //   "assets/instagram.svg",
                        //   "https://www.instagram.com/zuck/?hl=ru",
                        // ),
                        _iconButton(
                          "assets/twitter_icon.svg",
                          "twitter",
                          context,
                        ),
                        _iconButton(
                          "assets/facebook_icon.svg",
                          "facebook",
                          context,
                        ),
                        _iconButton(
                          "assets/linkedin_icon.svg",
                          "linkedin",
                          context,
                        ),
                      ],
                    ),

                    //_iconsView(signInStore),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      top: 40.0,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "signIn.dontHaveAnAccount".tr(),
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
                          onTap: () => Navigator.pushNamed(
                            context,
                            SendEmail.routeName,
                          ),
                          child: Text(
                            "signIn.forgotYourPass".tr(),
                            style: TextStyle(
                              color: Color(0xFF0083C7),
                            ),
                          ),
                        ),
                        Spacer(),
                        //const Text("Version 1.0.26"),
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

  // Widget _iconsView(final SignInStore store) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       _iconButton(
  //         store.signInWithTwitter(),
  //         "assets/google_icon.svg",
  //         "https://www.instagram.com/zuck/?hl=ru",
  //       ),
  //       // _iconButton(
  //       //   "assets/instagram.svg",
  //       //   "https://www.instagram.com/zuck/?hl=ru",
  //       // ),
  //       _iconButton(
  //         () {},
  //         "assets/twitter_icon.svg",
  //         "https://www.instagram.com/zuck/?hl=ru",
  //       ),
  //       _iconButton(
  //         () {},
  //         "assets/facebook_icon.svg",
  //         "https://www.instagram.com/zuck/?hl=ru",
  //       ),
  //       _iconButton(
  //         () {},
  //         "assets/linkedin_icon.svg",
  //         "https://www.instagram.com/zuck/?hl=ru",
  //       ),
  //     ],
  //   );
  // }

  Future<void> _errorMessage(BuildContext context, String? msg) =>
      AlertDialogUtils.showAlertDialog(
        context,
        title: Text("Error"),
        content: Text(
          msg??"",
        ),
        needCancel: false,
        titleCancel: null,
        titleOk: null,
        onTabCancel: null,
        onTabOk: null,
        colorCancel: null,
        colorOk: null,
      );

  Widget _iconButton(
    String iconPath,
    String link,
    BuildContext context, [
    Color? color,
  ]) {
    return CupertinoButton(
        color: Color(0xFFF7F8FA),
        padding: EdgeInsets.zero,
        child: SvgPicture.asset(
          iconPath,
          color: color,
        ),
        onPressed: () async => await launch(
              link == "google"
                  ? 'https://app.workquest.co/api/v1/auth/login/google/token'
                  : link == "twitter"
                      ? 'https://app.workquest.co/api/v1/auth/login/twitter/token'
                      : link == "facebook"
                          ? 'https://app.workquest.co/api/v1/auth/login/facebook/token'
                          : 'https://app.workquest.co/api/v1/auth/login/linkedin/token',
              customTabsOption: CustomTabsOption(
                toolbarColor: Theme.of(context).primaryColor,
                enableDefaultShare: true,
                enableUrlBarHiding: true,
                showPageTitle: true,
                // animation: CustomTabsAnimation.slideIn(),
                // // or user defined animation.
                // animation: const CustomTabsAnimation(
                //   startEnter: 'slide_up',
                //   startExit: 'android:anim/fade_out',
                //   endEnter: 'android:anim/fade_in',
                //   endExit: 'slide_down',
                // ),
                extraCustomTabs: const <String>[
                  // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
                  'org.mozilla.firefox',
                  // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
                  'com.microsoft.emmx',
                ],
              ),
              safariVCOption: SafariViewControllerOption(
                preferredBarTintColor: Theme.of(context).primaryColor,
                preferredControlTintColor: Colors.white,
                barCollapsingEnabled: true,
                entersReaderIfAvailable: false,
                dismissButtonStyle:
                    SafariViewControllerDismissButtonStyle.close,
              ),
            )
        // } catch (e) {
        // // An exception is thrown if browser app is not installed on Android device.
        // debugPrint(e.toString());
        // }

        //     Navigator.pushNamed(
        //   context,
        //   WebViewPage.routeName,
        //   arguments: "api/v1/auth/login/$link/token",
        // ),
        );
  }
}
