import 'package:app/app_localizations.dart';
import 'package:app/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(),
      body: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: context.translate(SignUpPageKeys.firstName),
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: context.translate(SignUpPageKeys.lastName),
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: context.translate(SignUpPageKeys.email),
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: context.translate(SignUpPageKeys.password),
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: context.translate(SignUpPageKeys.repeatPassword),
            ),
          ),
        ],
      ),
    );
  }
}
