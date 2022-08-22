import 'dart:io';

import 'package:app/constants.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/restore_password_page/send_code.dart';
import 'package:app/ui/pages/sign_in_page/mnemonic_page.dart';
import "package:app/ui/pages/sign_in_page/store/sign_in_store.dart";
import 'package:app/ui/pages/sign_up_page/choose_role_page/choose_role_page.dart';
import 'package:app/ui/pages/sign_up_page/confirm_email_page/confirm_email_page.dart';
import "package:app/ui/pages/sign_up_page/sign_up_page.dart";
import 'package:app/ui/widgets/default_textfield.dart';
import 'package:app/ui/widgets/dropdown_adaptive_widget.dart';
import 'package:app/ui/widgets/login_button.dart';
import 'package:app/ui/widgets/web_view_page/web_view_page.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/deep_link_util.dart';
import 'package:app/utils/storage.dart';
import 'package:app/web3/repository/account_repository.dart';
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

class SignInPage extends StatefulWidget {
  static const String routeName = "/startPage";

  SignInPage();

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  late SignInStore store;

  final TextEditingController totpController = new TextEditingController();

  @override
  void initState() {
    store = context.read<SignInStore>();
    store.setPlatform(Platform.isIOS ? "iOS" : "Android");
    Storage.readDeepLinkCheck().then((value) {
      if (value != "0") return;
      print('init deep link is sign in');
      DeepLinkUtil().initDeepLink();
      Storage.writeDeepLinkCheck("1");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObserverListener<SignInStore>(
      onSuccess: () async {
        if (store.successData == SignInStoreState.unconfirmedProfile) {
          AlertDialogUtils.showSuccessDialog(context).then((value) {
            Navigator.pushNamed(
              context,
              ConfirmEmail.routeName,
              arguments: store.getUsername(),
            );
          });
        } else if (store.successData == SignInStoreState.needSetRole) {
          AlertDialogUtils.showSuccessDialog(context).then((value) {
            Navigator.pushNamed(
              context,
              ChooseRolePage.routeName,
            );
          });
        } else if (store.successData == SignInStoreState.signIn) {
          await AlertDialogUtils.showSuccessDialog(context);
          Navigator.pushNamed(
            context,
            MnemonicPage.routeName,
          );
        }
      },
      onFailure: () {
        if (store.errorMessage == "TOTP is invalid" || store.errorMessage == "User must pass 2FA") {
          _showAlertTotp(context, store);
          return true;
        }
        return false;
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
          body: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.44,
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
              SliverToBoxAdapter(
                child: _InputFieldsWidget(
                  signInStore: store,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 0.0),
                  child: Observer(
                    builder: (context) {
                      return LoginButton(
                        withColumn: true,
                        enabled: store.isLoading,
                        onTap: store.canSignIn ? _onPressedLogin : null,
                        title: "signIn.login".tr(),
                      );
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
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
              ),
              SliverToBoxAdapter(
                child: const _SocialLoginWidget(),
              ),
              SliverToBoxAdapter(
                child: const _HintsAccountWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onPressedLogin() {
    if (_formKey.currentState!.validate()) {
      store.signIn(Platform.isIOS ? "iOS" : "Android");
    }
  }

  _showAlertTotp(BuildContext context, SignInStore signInStore) {
    AlertDialogUtils.showAlertDialog(
      context,
      title: Text('modals.securityCheck'.tr()),
      content: Builder(
        builder: (context) {
          var width = MediaQuery.of(context).size.width;
          return Container(
            width: width - 20,
            child: _AlertTotpWidget(
              text: totpController.text,
              onChanged: signInStore.setTotp,
            ),
          );
        },
      ),
      needCancel: true,
      titleCancel: 'meta.cancel'.tr(),
      titleOk: 'OK',
      onTabCancel: null,
      onTabOk: () {
        store.signIn(Platform.isIOS ? "iOS" : "Android");
      },
      colorCancel: Colors.red,
      colorOk: AppColor.enabledButton,
    );
  }
}

class _HintsAccountWidget extends StatelessWidget {
  const _HintsAccountWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
    );
  }
}

class _SocialLoginWidget extends StatelessWidget {
  const _SocialLoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signInStore = context.read<SignInStore>();
    return Padding(
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
            signInStore,
          ),
          _iconButton(
            "assets/twitter_icon.svg",
            "twitter",
            context,
            signInStore,
          ),
          _iconButton(
            "assets/facebook_icon.svg",
            "facebook",
            context,
            signInStore,
          ),
          _iconButton(
            "assets/linkedin_icon.svg",
            "linkedin",
            context,
            signInStore,
          ),
        ],
      ),
    );
  }

  Widget _iconButton(
    String iconPath,
    String link,
    BuildContext context,
    SignInStore signInStore, [
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
        // signInStore.loginSocialMedia(link);
        Navigator.of(context, rootNavigator: true).pushNamed(
          WebViewPage.routeName,
          arguments: "api/v1/auth/login/main/$link/token",
        );
      },
    );
  }
}

class _InputFieldsWidget extends StatefulWidget {
  final SignInStore signInStore;

  const _InputFieldsWidget({
    Key? key,
    required this.signInStore,
  }) : super(key: key);

  @override
  _InputFieldsWidgetState createState() => _InputFieldsWidgetState();
}

class _InputFieldsWidgetState extends State<_InputFieldsWidget> {
  final TextEditingController usernameController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 0.0),
          child: DefaultTextField(
            controller: usernameController,
            keyboardType: TextInputType.emailAddress,
            onChanged: widget.signInStore.setUsername,
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
            onChanged: widget.signInStore.setPassword,
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
          padding: const EdgeInsets.only(top: 8.0, right: 16.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: SwitchNetworkWidget<Network>(
              colorText: Colors.black,
              items: Network.values,
              value: AccountRepository().notifierNetwork.value,
              onChanged: (value) {
                setState(() {
                  final _networkName =
                      (value as Network) == Network.mainnet ? NetworkName.workNetMainnet : NetworkName.workNetTestnet;
                  AccountRepository().setNetwork(_networkName);
                  Storage.write(StorageKeys.networkName.name, _networkName.name);
                });
                return value;
              },
            ),
          ),
        ),
      ],
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('securityCheck.confCode'.tr()),
              const SizedBox(
                height: 6,
              ),
              DefaultTextField(
                controller: _controller,
                onChanged: widget.onChanged,
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                autofillHints: [AutofillHints.password],
                prefixIconConstraints: _prefixConstraints,
                hint: "123456",
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                ],
                suffixIcon: null,
                validator: (_) {
                  if (_controller.text.length < 6) {
                    return 'errors.smallLength'.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                'securityCheck.enterDiginCodeGoogle'.tr(),
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }
}
