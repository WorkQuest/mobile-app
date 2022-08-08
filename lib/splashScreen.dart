import 'package:app/ui/pages/pin_code_page/pin_code_page.dart';
import 'package:app/ui/pages/start_page/start_page.dart';
import 'package:app/utils/deep_link_util.dart';
import 'package:app/utils/storage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen();

  static const String routeName = "/splashScreen";

  @override
  Widget build(BuildContext context) {
    _initPage(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Image.asset("assets/logo_splash.png"),
        ),
      ),
    );
  }

  void _initPage(BuildContext context) {
    Storage.toLoginCheck().then((value) {
      if (value)
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          _initDeepLinks(context);
          return PinCodePage();
        }), (route) => false);
      else
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          _initDeepLinks(context);
          return StartPage();
        }), (route) => false);
    });
  }

  void _initDeepLinks(BuildContext context) =>
      DeepLinkUtil().initDeepLink(context: context);
}
