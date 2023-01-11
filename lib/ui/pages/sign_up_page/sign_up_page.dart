import 'package:app/ui/widgets/default_textfield.dart';
import 'package:app/ui/widgets/login_button.dart';
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

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordRepeatController = TextEditingController();

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
          height: mq.size.height - kToolbarHeight - mq.padding.top - mq.padding.bottom,
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
                    child: DefaultTextField(
                      controller: _firstNameController,
                      onChanged: store.setFirstName,
                      keyboardType: TextInputType.name,
                      prefixIconConstraints: _prefixConstraints,
                      prefixIcon: SvgPicture.asset(
                        "assets/user.svg",
                        color: Theme.of(context).iconTheme.color,
                      ),
                      hint: "labels.firstName".tr(),
                      inputFormatters: [],
                      suffixIcon: null,
                    ),
                  ),
                  Padding(
                    padding: _padding,
                    child: DefaultTextField(
                      controller: _lastNameController,
                      keyboardType: TextInputType.name,
                      onChanged: store.setLastName,
                      prefixIconConstraints: _prefixConstraints,
                      prefixIcon: SvgPicture.asset(
                        "assets/user.svg",
                        color: Theme.of(context).iconTheme.color,
                      ),
                      hint: "labels.lastName".tr(),
                      inputFormatters: [],
                      suffixIcon: null,
                    ),
                  ),
                  Padding(
                    padding: _padding,
                    child: DefaultTextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: store.setEmail,
                      validator: Validators.emailValidator,
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
                      hint: "signUp.email".tr(),
                      inputFormatters: [],
                      suffixIcon: null,
                    ),
                  ),
                  Padding(
                    padding: _padding,
                    child: DefaultTextField(
                      controller: _passwordController,
                      isPassword: true,
                      validator: Validators.signUpPasswordValidator,
                      onChanged: store.setPassword,
                      prefixIconConstraints: _prefixConstraints,
                      hint: "signUp.password".tr(),
                      prefixIcon: SvgPicture.asset(
                        "assets/lock.svg",
                        color: Theme.of(context).iconTheme.color,
                      ),
                      inputFormatters: [],
                      suffixIcon: null,
                    ),
                  ),
                  Padding(
                    padding: _padding,
                    child: DefaultTextField(
                      controller: _passwordRepeatController,
                      isPassword: true,
                      validator: store.signUpConfirmPasswordValidator,
                      onChanged: store.setConfirmPassword,
                      prefixIcon: SvgPicture.asset(
                        "assets/lock.svg",
                        color: Theme.of(context).iconTheme.color,
                      ),
                      prefixIconConstraints: _prefixConstraints,
                      hint: "signUp.confirmPassword".tr(),
                      inputFormatters: [],
                      suffixIcon: null,
                    ),
                  ),
                  Padding(
                    padding: _padding.copyWith(top: 30.0),
                    child: ObserverListener<SignUpStore>(
                      onSuccess: () {
                        Navigator.pushNamed(context, ConfirmEmail.routeName,
                            arguments: store.email);
                      },
                      child: Observer(
                        builder: (context) {
                          return LoginButton(
                            withColumn: true,
                            enabled: store.isLoading,
                            onTap: store.canSignUp
                                ? () async {
                                    if (_signUpPageFormKey.currentState!.validate()) {
                                      await store.register();
                                    }
                                  }
                                : null,
                          title: "signUp.create".tr(),
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
