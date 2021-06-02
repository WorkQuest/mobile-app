import 'package:app/di/injector.dart';
import 'package:app/enums.dart';
import 'package:app/ui/pages/sign_up_page/choose_role_page/store/choose_role_store.dart';
import 'package:app/ui/widgets/platform_activity_indicator.dart';
import 'package:app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';

class ApproveRolePage extends StatefulWidget {
  const ApproveRolePage();

  static const String routeName = '/approveRolePage';

  @override
  _ApproveRolePageState createState() => _ApproveRolePageState();
}

class _ApproveRolePageState extends State<ApproveRolePage> {
  @override
  Widget build(BuildContext ctx) {
    final store = ctx.read<ChooseRoleStore>();

    return Scaffold(
      appBar: AppBar(),
      body: Observer(
        builder: (ctx) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your role is ${Utils.getUserRoleString(store.userRole)} right?",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                store.userRole == UserRole.Worker
                    ? getWorkerCard()
                    : getEmployerCard(),
                SizedBox(
                  height: 0,
                ),
                CheckboxListTile(
                  contentPadding: const EdgeInsets.all(0),
                  value: store.privacyPolicy,
                  onChanged: (value) => store.setPrivacyPolicy(value!),
                  controlAffinity: ListTileControlAffinity.leading,
                  title: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color(0xFF1D2127),
                      ),
                      children: <TextSpan>[
                        TextSpan(text: 'I agree with '),
                        TextSpan(
                          text: 'Privacy policy',
                          style: TextStyle(
                            color: Color(0xFF0083C7),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                CheckboxListTile(
                  contentPadding: const EdgeInsets.all(0),
                  value: store.termsAndConditions,
                  onChanged: (value) => store.setTermsAndConditions(value!),
                  controlAffinity: ListTileControlAffinity.leading,
                  title: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color(0xFF1D2127),
                      ),
                      children: <TextSpan>[
                        TextSpan(text: 'I agree with '),
                        TextSpan(
                          text: 'Terms & Conditions',
                          style: TextStyle(
                            color: Color(0xFF0083C7),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                CheckboxListTile(
                  contentPadding: const EdgeInsets.all(0),
                  value: store.amlAndCtfPolicy,
                  onChanged: (value) => store.setAmlAndCtfPolicy(value!),
                  controlAffinity: ListTileControlAffinity.leading,
                  title: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color(0xFF1D2127),
                      ),
                      children: <TextSpan>[
                        TextSpan(text: 'I agree with '),
                        TextSpan(
                          text: 'AML & CTF Policy',
                          style: TextStyle(
                            color: Color(0xFF0083C7),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: (){},
                  child: store.isLoading
                      ? PlatformActivityIndicator()
                      : Text(
                          "I agree",
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget getWorkerCard() {
    return Stack(
      children: [
        Image.asset(
          "assets/worker.jpg",
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, top: 20),
          width: 146,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Worker",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                "I want to search a tasks and working on freelance",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getEmployerCard() {
    return Stack(
      children: [
        Image.asset(
          "assets/employer.jpg",
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, top: 20),
          width: 146,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Employer",
                style: TextStyle(
                    color: Color(0xFF1D2127),
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                "I want to make a tasks and looking for a workers",
                style: TextStyle(color: Color(0xFF1D2127)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
