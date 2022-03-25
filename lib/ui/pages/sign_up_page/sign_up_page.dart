import 'package:easy_localization/easy_localization.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/sign_up_page/confirm_email_page/confirm_email_page.dart';
import 'package:app/ui/pages/sign_up_page/store/sign_up_store.dart';
import 'package:app/utils/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

const _padding = const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0);
const double _horizontalConstraints = 44.0;
const double _verticalConstraints = 24.0;

const _prefixConstraints = const BoxConstraints(
  maxHeight: _verticalConstraints,
  maxWidth: _horizontalConstraints,
  minHeight: _verticalConstraints,
  minWidth: _horizontalConstraints,
);

class SignUpPage extends StatelessWidget {
  static const String routeName = '/signUpPage';
  final _signUpPageFormKey = GlobalKey<FormState>();

  SignUpPage();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final store = context.read<SignUpStore>();

    return Scaffold(
      appBar: CupertinoNavigationBar(
        previousPageTitle: "  " + "signUp.back".tr(),
        border: Border.fromBorderSide(BorderSide.none),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: SizedBox(
          height: mq.size.height -
              kToolbarHeight -
              mq.padding.top -
              mq.padding.bottom,
          child: AutofillGroup(
            child: Form(
              key: _signUpPageFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: _padding.copyWith(top: 40.0),
                    child: Text(
                      "signIn.signUp".tr(),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: _padding.copyWith(top: 30.0),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: store.setFirstName,
                      decoration: InputDecoration(
                        prefixIconConstraints: _prefixConstraints,
                        prefixIcon: SvgPicture.asset(
                          "assets/user.svg",
                          color: Theme.of(context).iconTheme.color,
                        ),
                        hintText: "labels.firstName".tr(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: _padding,
                    child: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: store.setLastName,
                      decoration: InputDecoration(
                        prefixIconConstraints: _prefixConstraints,
                        prefixIcon: SvgPicture.asset(
                          "assets/user.svg",
                          color: Theme.of(context).iconTheme.color,
                        ),
                        hintText: "labels.lastName".tr(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: _padding,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: store.setEmail,
                      validator: Validators.emailValidator,
                      decoration: InputDecoration(
                        prefixIconConstraints: _prefixConstraints,
                        prefixIcon: SizedBox(
                          height: 15,
                          width: 15,
                          child: SvgPicture.asset(
                            "assets/email_icon.svg",
                            fit: BoxFit.contain,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                        hintText: "signUp.email".tr(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: _padding,
                    child: TextFormField(
                      obscureText: true,
                      validator: Validators.signUpPasswordValidator,
                      onChanged: store.setPassword,
                      decoration: InputDecoration(
                        prefixIconConstraints: _prefixConstraints,
                        hintText: "signUp.password".tr(),
                        prefixIcon: SvgPicture.asset(
                          "assets/lock.svg",
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: _padding,
                    child: TextFormField(
                      obscureText: true,
                      validator: store.signUpConfirmPasswordValidator,
                      onChanged: store.setConfirmPassword,
                      decoration: InputDecoration(
                        prefixIcon: SvgPicture.asset(
                          "assets/lock.svg",
                          color: Theme.of(context).iconTheme.color,
                        ),
                        prefixIconConstraints: _prefixConstraints,
                        hintText: "signUp.confirmPassword".tr(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: _padding.copyWith(top: 30.0),
                    child: ObserverListener<SignUpStore>(
                      onSuccess: () {
                        Navigator.pushNamed(
                          context,
                          ConfirmEmail.routeName,
                          arguments: store.email
                        );
                      },
                      child: Observer(
                        builder: (context) {
                          return ElevatedButton(
                            onPressed: store.canSignUp
                                ? () async {
                                    if (_signUpPageFormKey.currentState!
                                        .validate()) {
                                      await store.register();
                                    }
                                  }
                                : null,
                            child: store.isLoading
                                ? CircularProgressIndicator.adaptive()
                                : Text(
                                    "signUp.create".tr(),
                                  ),
                          );
                        },
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      bottom: 20.0,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "signUp.haveAccount".tr(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "signIn.title".tr(),
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
          ),
        ),
      ),
    );
  }
}
