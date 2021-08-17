import 'package:app/ui/pages/main_page/settings_page/SMS_verification_page/store/sms_verification_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";

class SMSVerificationPage extends StatelessWidget {
  static const String routeName = "/smsVerificationPage";

  @override
  Widget build(BuildContext context) {
    final store = context.read<SMSVerificationStore>();
    return Observer(
      builder: (_) => Scaffold(
        appBar: CupertinoNavigationBar(
          automaticallyImplyLeading: true,
          middle: Text("SMS Verification"),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: IndexedStack(
              index: store.index,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Phone"),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      onChanged: store.setPhone,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "Phone",
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: store.phone.isEmpty
                          ? null
                          : () {
                              store.index = 1;
                            },
                      child: Text("Submit"),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Code"),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      onChanged: store.setCode,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "Code",
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: null,
                      child: Text("Send Code"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
