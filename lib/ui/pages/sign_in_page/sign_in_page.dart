import 'package:app/constants.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/pin_code_page/pin_code_page.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/pages/restore_password_page/send_code.dart';
import "package:app/ui/pages/sign_in_page/store/sign_in_store.dart";
import 'package:app/ui/pages/sign_up_page/confirm_email_page/confirm_email_page.dart';
import "package:app/ui/pages/sign_up_page/sign_up_page.dart";
import 'package:app/ui/widgets/default_textfield.dart';
import 'package:app/ui/widgets/login_button.dart';
import 'package:app/ui/widgets/web_view_page/web_view_page.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
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

  final TextEditingController usernameController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController totpController = new TextEditingController();
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
                crossAxisAlignment: CrossAxisAlignment.center,
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
                          padding: const EdgeInsets.fromLTRB(
                            16.0,
                            0.0,
                            16.0,
                            30.0,
                          ),
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
                    child: DefaultTextField(
                      controller: usernameController,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: signInStore.setUsername,
                      validator: Validators.emailValidator,
                      autofillHints: [AutofillHints.email],
                      prefixIconConstraints: _prefixConstraints,
                      prefixIcon: SvgPicture.asset(
                        "assets/user.svg",
                        color: Theme.of(context).iconTheme.color,
                      ),
                      hint: "signIn.username".tr(),
                      inputFormatters: [],
                      suffixIcon: null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
                    child: DefaultTextField(
                      controller: passwordController,
                      isPassword: true,
                      onChanged: signInStore.setPassword,
                      inputFormatters: [],
                      prefixIconConstraints: _prefixConstraints,
                      autofillHints: [AutofillHints.password],
                      prefixIcon: SvgPicture.asset(
                        "assets/lock.svg",
                        color: Theme.of(context).iconTheme.color,
                      ),
                      hint: "signIn.password".tr(),
                      suffixIcon: null,
                    ),
                  ),
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
                          onTap: signInStore.canSignIn
                              ? signInStore.isLoading
                                  ? () {}
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        _onPressedSignIn(
                                          context,
                                          signInStore: signInStore,
                                          profile: profile,
                                        );
                                      }
                                    }
                              : null,
                          title: "signIn.login".tr(),
                          enabled: signInStore.isLoading,
                        );
                      },
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
                                context,
                                SignUpPage.routeName,
                              );
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

  _onPressedSignIn(
    BuildContext context, {
    required SignInStore signInStore,
    required ProfileMeStore profile,
  }) async {
    await signInStore.signIn();
    if (signInStore.isSuccess)
      await profile.getProfileMe();
    else {
      _errorHandler(context, signInStore: signInStore);
      return;
    }
    if (profile.error.isEmpty)
      await signInStore.signInWallet();
    else {
      _errorMessage(context, profile.error);
      return;
    }
    if (signInStore.isSuccess && signInStore.error.isEmpty) {
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

  _errorHandler(
    BuildContext context, {
    required SignInStore signInStore,
  }) async {
    print('error handler: ${signInStore.errorMessage}');
    if (signInStore.errorMessage == "unconfirmed") {
      print("error");
      await AlertDialogUtils.showSuccessDialog(context);
      Navigator.pushNamed(context, ConfirmEmail.routeName,
          arguments: signInStore.getUsername());
    } else if (signInStore.errorMessage == "TOTP is invalid") {
      AlertDialogUtils.showAlertDialog(
        context,
        title: Text('Warning'),
        content: Builder(
          builder: (context) {
            var width = MediaQuery.of(context).size.width;
            return Container(
              width: width - 100,
              child: _AlertTotpWidget(
                text: totpController.text,
                onChanged: signInStore.setTotp,
              ),
            );
          },
        ),
        needCancel: true,
        titleCancel: 'Cancel',
        titleOk: 'OK',
        onTabCancel: null,
        onTabOk: () {
          _onPressedSignIn(context,
              signInStore: signInStore, profile: context.read<ProfileMeStore>());
        },
        colorCancel: Colors.red,
        colorOk: AppColor.enabledButton,
      );
    } else {
      _errorMessage(context, signInStore.error);
    }
  }

  Future<void> _errorMessage(BuildContext context, String msg) =>
      AlertDialogUtils.showAlertDialog(
        context,
        title: Text("Error"),
        content: Text(
          msg,
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
      onPressed: () async {
        Navigator.of(context, rootNavigator: true).pushNamed(
          WebViewPage.routeName,
          arguments: "api/v1/auth/login/$link",
        );
  }
}

class _AlertTotpWidget extends StatefulWidget {
  final String text;
  final Function(String)? onChanged;

  const _AlertTotpWidget({
    Key? key,
    required this.text,
    required this.onChanged,
  }) : super(key: key);

  @override
  _AlertTotpWidgetState createState() => _AlertTotpWidgetState();
}

class _AlertTotpWidgetState extends State<_AlertTotpWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
          child: DefaultTextField(
            controller: _controller,
            onChanged: widget.onChanged,
            isPassword: true,
            autofillHints: [AutofillHints.password],
            prefixIconConstraints: _prefixConstraints,
            prefixIcon: SvgPicture.asset(
              "assets/lock.svg",
              color: Theme.of(context).iconTheme.color,
            ),
            hint: "signIn.totp".tr(),
            inputFormatters: [],
            suffixIcon: null,
          ),
        );
      },
    );
  }
}
