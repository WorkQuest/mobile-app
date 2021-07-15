import "package:app/app_localizations.dart";
import "package:app/constants.dart";
import "package:app/observer_consumer.dart";
import "package:app/ui/pages/main_page/main_page.dart";
import "package:app/ui/pages/sign_in_page/store/sign_in_store.dart";
import "package:app/ui/pages/sign_up_page/sign_up_page.dart";
import "package:app/ui/widgets/platform_activity_indicator.dart";
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
                        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 30.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.translate(AuthLangKeys.welcomeTo),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                context.translate(AuthLangKeys.pleaseSignIn),
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
                        hintText: context.translate(
                          AuthLangKeys.username,
                        ),
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
                        hintText: context.translate(
                          AuthLangKeys.password,
                        ),
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
                            MainPage.routeName,
                            (_) => false,
                          );
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
                                      context.translate(AuthLangKeys.login),
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
                        "or",
                        style: TextStyle(
                          color: Color(0xFFCBCED2),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, top: 20.0, right: 16),
                    child: _iconsView(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      top: 40.0,
                    ),
                    child: Row(
                      children: [
                        Text(
                          context.translate(AuthLangKeys.doNotHaveAccount),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, SignUpPage.routeName);
                            },
                            child: Text(
                              context.translate(AuthLangKeys.signUp),
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
                    child: GestureDetector(
                      onTap: onForgotPasswordClicked,
                      child: Text(
                        context.translate(AuthLangKeys.forgotPassword),
                        style: TextStyle(
                          color: Color(0xFF0083C7),
                        ),
                      ),
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

  Widget _iconsView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _iconButton(
          "assets/google_icon.svg",
          "https://www.instagram.com/zuck/?hl=ru",
        ),
        // _iconButton(
        //   "assets/instagram.svg",
        //   "https://www.instagram.com/zuck/?hl=ru",
        // ),
        _iconButton(
          "assets/twitter_icon.svg",
          "https://www.instagram.com/zuck/?hl=ru",
        ),
        _iconButton(
          "assets/facebook_icon.svg",
          "https://www.instagram.com/zuck/?hl=ru",
        ),
        _iconButton(
          "assets/linkedin_icon.svg",
          "https://www.instagram.com/zuck/?hl=ru",
        ),
      ],
    );
  }

  Widget _iconButton(String iconPath, String link, [Color? color]) {
    return CupertinoButton(
      color: Color(0xFFF7F8FA),
      padding: EdgeInsets.zero,
      child: SvgPicture.asset(iconPath, color: color),
      onPressed: () {},
    );
  }

  void onForgotPasswordClicked() {
    return;
  }
}
