import 'package:app/app_localizations.dart';
import 'package:app/constants.dart';
import 'package:app/login_page/sign_up_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ImageHeader(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 0.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: context.translate(LoginPageKeys.username),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: context.translate(LoginPageKeys.password),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CupertinoButton(
                  color: Color(0xFF0083C7),
                  borderRadius: BorderRadius.circular(6),
                  child: Text(context.translate(LoginPageKeys.login)),
                  onPressed: () {},
                ),
              ),
            ),
            Center(
              child: Text(
                "or",
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
                  Text(context.translate(LoginPageKeys.doNotHaveAccountText)),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        return Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) {
                              return SignUpPage();
                            },
                          ),
                        );
                      },
                      child: Text(
                        context.translate(LoginPageKeys.signUp),
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
                  context.translate(LoginPageKeys.forgotPasswordText),
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
      padding:
          const EdgeInsets.only(top: 20.0, bottom: 50, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _iconButton(
            "assets/google_icon.svg",
            "https://www.instagram.com/zuck/?hl=ru",
          ),
          _iconButton(
            "assets/google_icon.svg",
            "https://www.instagram.com/zuck/?hl=ru",
          ),
          _iconButton(
            "assets/google_icon.svg",
            "https://www.instagram.com/zuck/?hl=ru",
          ),
          _iconButton(
            "assets/google_icon.svg",
            "https://www.instagram.com/zuck/?hl=ru",
          ),
          _iconButton(
            "assets/google_icon.svg",
            "https://www.instagram.com/zuck/?hl=ru",
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

class ImageHeader extends StatelessWidget {
  const ImageHeader();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
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
                context.translate(LoginPageKeys.welcomeTo),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  context.translate(LoginPageKeys.pleaseSignIn),
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
    );
  }
}
