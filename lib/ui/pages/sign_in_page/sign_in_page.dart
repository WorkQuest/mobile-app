import 'package:app/app_localizations.dart';
import 'package:app/constants.dart';
import 'package:app/ui/pages/sign_in_page/store/sign_in_store.dart';
import 'package:app/ui/pages/sign_up_page/sign_up_page.dart';
import 'package:app/ui/widgets/platform_activity_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  static const String routeName = '/loginPage';

  final SignInStore _store;

  const SignInPage({
    Key? key,
    required SignInStore store,
  })   : _store = store,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                onChanged: _store.setUsername,
                decoration: InputDecoration(
                  hintText: context.translate(
                    AuthLangKeys.username,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
              child: TextFormField(
                onChanged: _store.setPassword,
                decoration: InputDecoration(
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
                child: Observer(
                  builder: (context) {
                    final bool canSignIn = _store.canSignIn;

                    return AnimatedOpacity(
                      duration: Duration(milliseconds: 150),
                      opacity: canSignIn ? 1.0 : 0.3,
                      child: CupertinoButton(
                        color: Color(0xFF0083C7),
                        disabledColor: Color(0xFF0083C7),
                        borderRadius: BorderRadius.circular(6),
                        onPressed: canSignIn ? _store.signInWithUsername : null,
                        child: _store.isLoading
                            ? PlatformActivityIndicator()
                            : Text(
                                context.translate(
                                  AuthLangKeys.login,
                                ),
                              ),
                      ),
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
                        Navigator.pushReplacementNamed(context, SignUpPage.routeName);
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
            'assets/google_icon.svg',
            'https://www.instagram.com/zuck/?hl=ru',
          ),
          _iconButton(
            'assets/google_icon.svg',
            'https://www.instagram.com/zuck/?hl=ru',
          ),
          _iconButton(
            'assets/google_icon.svg',
            'https://www.instagram.com/zuck/?hl=ru',
          ),
          _iconButton(
            'assets/google_icon.svg',
            'https://www.instagram.com/zuck/?hl=ru',
          ),
        ],
      ),
    );
  }

  Widget _iconButton(String iconPath, String link) {
    return IconButton(
      icon: SvgPicture.asset(iconPath),
      iconSize: 19,
      onPressed: () {},
    );
  }

  void onForgotPasswordClicked() {
    return;
  }
}
