import 'dart:io';

import 'package:app/constants.dart';
import 'package:app/observer_consumer.dart';

import 'package:app/ui/pages/sign_in_page/mnemonic_page.dart';
import "package:app/ui/pages/sign_in_page/store/sign_in_store.dart";
import 'package:app/ui/pages/sign_in_page/widgets/alert_totp_widget.dart';
import 'package:app/ui/pages/sign_in_page/widgets/hints_account_widget.dart';
import 'package:app/ui/pages/sign_in_page/widgets/input_fields_widget.dart';
import 'package:app/ui/pages/sign_in_page/widgets/social_login_widget.dart';
import 'package:app/ui/pages/sign_up_page/choose_role_page/choose_role_page.dart';
import 'package:app/ui/pages/sign_up_page/confirm_email_page/confirm_email_page.dart';
import 'package:app/ui/pages/sign_up_page/generate_wallet/wallets_page.dart';
import 'package:app/ui/widgets/login_button.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/deep_link_util.dart';
import 'package:app/utils/storage.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:provider/provider.dart";

class SignInPage extends StatefulWidget {
  static const String routeName = "/startPage";

  SignInPage();

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  late SignInStore store;

  @override
  void initState() {
    store = context.read<SignInStore>();
    store.setPlatform(Platform.isIOS ? "iOS" : "Android");
    _initDeepLink();
    super.initState();
  }

  _initDeepLink() {
    Storage.readDeepLinkCheck().then((value) {
      if (value != "0") return;
      DeepLinkUtil().initDeepLink();
      Storage.writeDeepLinkCheck("1");
    });
  }

  _stateListener() async {
    if (store.successData == SignInStoreState.unconfirmedProfile) {
      AlertDialogUtils.showSuccessDialog(context).then((value) {
        Navigator.pushNamed(
          context,
          ConfirmEmail.routeName,
          arguments: ConfirmEmailArguments(email: store.getUsername()),
        );
      });
    } else if (store.successData == SignInStoreState.needSetRole) {
      AlertDialogUtils.showSuccessDialog(context).then((value) {
        Navigator.pushNamed(
          context,
          ChooseRolePage.routeName,
        );
      });
    } else if (store.successData == SignInStoreState.createWallet) {
      AlertDialogUtils.showSuccessDialog(context).then((value) {
        Navigator.pushNamed(
          context,
          WalletsPage.routeName,
        );
      });
    } else if (store.successData == SignInStoreState.signIn) {
      await AlertDialogUtils.showSuccessDialog(context);
      Navigator.pushNamed(
        context,
        MnemonicPage.routeName,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ObserverListener<SignInStore>(
      onSuccess: _stateListener,
      onFailure: () {
        if (store.errorMessage == "Invalid TOTP" ||
            store.errorMessage == "User must pass 2FA") {
          _showAlertTotp();
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
                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 30.0),
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
                child: InputFieldsWidget(signInStore: store),
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
                child: const SocialLoginWidget(),
              ),
              SliverToBoxAdapter(
                child: const HintsAccountWidget(),
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

  _showAlertTotp() {
    AlertDialogUtils.showAlertDialog(
      context,
      title: Text('modals.securityCheck'.tr()),
      content: Builder(
        builder: (context) {
          var width = MediaQuery.of(context).size.width;
          return Container(
            width: width - 20,
            child: AlertTotpWidget(
              onChanged: store.setTotp,
            ),
          );
        },
      ),
      needCancel: true,
      titleCancel: 'meta.cancel'.tr(),
      titleOk: 'OK',
      onTabCancel: () {
        store.setTotp('');
      },
      onTabOk: () {
        if (store.totp.length != 6) {
          store.setTotp('');
        } else {
          store.signIn(Platform.isIOS ? "iOS" : "Android");
        }
      },
      colorCancel: Colors.red,
      colorOk: AppColor.enabledButton,
    );
  }
}
