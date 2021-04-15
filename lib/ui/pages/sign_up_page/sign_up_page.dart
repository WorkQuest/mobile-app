import 'package:app/app_localizations.dart';
import 'package:app/constants.dart';
import 'package:app/ui/pages/sign_in_page/sign_in_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  static const String routeName = '/signUpPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(),
      body: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: context.translate(AuthLangKeys.firstName),
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: context.translate(AuthLangKeys.lastName),
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: context.translate(AuthLangKeys.email),
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: context.translate(AuthLangKeys.password),
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: context.translate(AuthLangKeys.repeatPassword),
            ),
          ),
          CupertinoButton(
            child: Text('ToSignIn'),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, SignInPage.routeName),
          )
        ],
      ),
    );
  }
}
