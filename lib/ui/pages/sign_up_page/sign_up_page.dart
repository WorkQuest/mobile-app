import 'package:app/app_localizations.dart';
import 'package:app/constants.dart';
import 'package:app/log_service.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/sign_up_page/store/sign_up_store.dart';
import 'package:app/ui/widgets/platform_activity_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

const _padding = const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0);

class SignUpPage extends StatelessWidget {
  static const String routeName = '/signUpPage';

  const SignUpPage();

  @override
  Widget build(BuildContext context) {
    final store = context.read<SignUpStore>();

    return Scaffold(
      appBar: CupertinoNavigationBar(
        previousPageTitle: "back",
        border: Border.fromBorderSide(BorderSide.none),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: _padding.copyWith(top: 40.0),
              child: Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: _padding.copyWith(top: 30.0),
              child: TextFormField(
                onChanged: store.setFirstName,
                decoration: InputDecoration(
                  hintText: context.translate(AuthLangKeys.firstName),
                ),
              ),
            ),
            Padding(
              padding: _padding,
              child: TextFormField(
                onChanged: store.setLastName,
                decoration: InputDecoration(
                  hintText: context.translate(AuthLangKeys.lastName),
                ),
              ),
            ),
            Padding(
              padding: _padding,
              child: TextFormField(
                onChanged: store.setEmail,
                decoration: InputDecoration(
                  hintText: context.translate(AuthLangKeys.email),
                ),
              ),
            ),
            Padding(
              padding: _padding,
              child: TextFormField(
                onChanged: store.setPassword,
                decoration: InputDecoration(
                  hintText: context.translate(AuthLangKeys.password),
                ),
              ),
            ),
            Padding(
              padding: _padding,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: context.translate(AuthLangKeys.repeatPassword),
                ),
              ),
            ),
            Padding(
              padding: _padding.copyWith(top: 30.0),
              child: ObserverListener<SignUpStore>(
                onSuccess: () {
                  println("SignUpPage => SignUp success!");
                },
                child: Observer(
                  builder: (context) {
                    return ElevatedButton(
                      onPressed: store.canSignUp ? store.register : null,
                      child: store.isLoading
                          ? PlatformActivityIndicator()
                          : Text(
                              context.translate(AuthLangKeys.login),
                            ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                children: [
                  Text(
                    context.translate(AuthLangKeys.alreadyHaveAccount),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        context.translate(AuthLangKeys.signIn),
                        style: TextStyle(
                          color: Color(0xFF0083C7),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
