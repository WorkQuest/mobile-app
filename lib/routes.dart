import 'package:app/ui/pages/sign_in_page/sign_in_page.dart';
import 'package:app/ui/pages/sign_in_page/store/sign_in_store.dart';
import 'package:app/ui/pages/sign_up_page/sign_up_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SignInPage.routeName:
        return MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => SignInPage(
            store: SignInStore(),
          ),
        );

      case SignUpPage.routeName:
        return MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => SignUpPage(),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => Container(),
        );
    }
  }
}
