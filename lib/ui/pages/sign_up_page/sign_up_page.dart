import 'package:app/app_localizations.dart';
import 'package:app/constants.dart';
import 'package:app/log_service.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/sign_up_page/store/sign_up_store.dart';
import 'package:app/ui/widgets/action_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
              child: ObserverConsumer<SignUpStore>(
                onSuccess: () {
                  println('SignUpPage => onSuccess called.');
                  //Navigator.pushNamed(context, SignUpPage.routeName);
                },
                builder: (context) {
                  println('SignUpPage => builder called.');
                  return ActionButton(
                    titleLangKey: "Create Account",
                    isEnable: store.canSignUp,
                    isLoading: store.isLoading,
                    onPressed: store.register,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
