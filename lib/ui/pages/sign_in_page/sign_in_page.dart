import 'package:app/app_localizations.dart';
import 'package:app/constants.dart';
import 'package:app/log_service.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/sign_in_page/store/sign_in_store.dart';
import 'package:app/ui/pages/sign_up_page/sign_up_page.dart';
import 'package:app/ui/widgets/action_button.dart';
import 'package:app/ui/widgets/platform_activity_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  static const String routeName = '/';

  const SignInPage();

  @override
  Widget build(BuildContext context) {
    final store = context.read<SignInStore>();

    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
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
                        'assets/login_page_header.png',
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
                  onChanged: store.setUsername,
                  decoration: InputDecoration(
                    prefixIcon: SvgPicture.asset(
                      'assets/user.svg',
                      fit: BoxFit.scaleDown,
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
                  onChanged: store.setPassword,
                  decoration: InputDecoration(
                    prefixIcon: SvgPicture.asset(
                      'assets/lock.svg',
                      fit: BoxFit.scaleDown,
                    ),
                    hintText: context.translate(
                      AuthLangKeys.password,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ObserverConsumer<SignInStore>(
                    onSuccess: () {
                      println('SignInPage => onSuccess called.');
                      Navigator.pushNamed(context, SignUpPage.routeName);
                    },
                    builder: (context) {
                      println('SignInPage => builder called.');
                      return ActionButton(
                        titleLangKey: AuthLangKeys.login,
                        isEnable: store.canSignIn,
                        isLoading: store.isLoading,
                        onPressed: store.signInWithUsername,
                      );
                    },
                  ),
                ),
              ),
              Center(
                child: Text(
                  'or',
                  style: TextStyle(
                    color: Color(0xFFCBCED2),
                  ),
                ),
              ),
              _iconsView(),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  children: [
                    Text(
                      context.translate(AuthLangKeys.doNotHaveAccountText),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, SignUpPage.routeName);
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
                padding: const EdgeInsets.only(left: 16.0, top: 10, bottom: 40),
                child: GestureDetector(
                  onTap: onForgotPasswordClicked,
                  child: Text(
                    context.translate(AuthLangKeys.forgotPasswordText),
                    style: TextStyle(color: Color(0xFF0083C7)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconsView() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 50, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _iconButton(
            'assets/google_icon.svg',
            'https://www.instagram.com/zuck/?hl=ru',
          ),
          _iconButton(
            'assets/instagram_icon.svg',
            'https://www.instagram.com/zuck/?hl=ru',
          ),
          _iconButton(
            'assets/twitter_icon.svg',
            'https://www.instagram.com/zuck/?hl=ru',
          ),
          _iconButton(
            'assets/facebook_icon.svg',
            'https://www.instagram.com/zuck/?hl=ru',
          ),
          _iconButton(
            'assets/linkedin_icon.svg',
            'https://www.instagram.com/zuck/?hl=ru',
          ),
        ],
      ),
    );
  }

  Widget _iconButton(String iconPath, String link) {
    return CupertinoButton(
      color: Color(0xFFF7F8FA),
      padding: EdgeInsets.zero,
      child: SvgPicture.asset(iconPath),
      onPressed: () {},
    );
  }

  void onForgotPasswordClicked() {
    return;
  }
}
