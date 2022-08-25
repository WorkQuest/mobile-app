import 'package:app/ui/pages/restore_password_page/send_code_page.dart';
import 'package:app/ui/pages/sign_up/pages/sign_up_page/sign_up_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HintsAccountWidget extends StatelessWidget {
  const HintsAccountWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            top: 40.0,
          ),
          child: Row(
            children: [
              Text(
                "signIn.dontHaveAnAccount".tr(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      SignUpPage.routeName,
                    );
                  },
                  child: Text(
                    "signIn.signUp".tr(),
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
          padding: const EdgeInsets.only(
            left: 16.0,
            top: 10.0,
            bottom: 40.0,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  SendEmailPage.routeName,
                ),
                child: Text(
                  "signIn.forgotYourPass".tr(),
                  style: TextStyle(
                    color: Color(0xFF0083C7),
                  ),
                ),
              ),
              Spacer(),
              //const Text("Version 1.0.26"),
              const SizedBox(width: 15)
            ],
          ),
        ),
      ],
    );
  }
}