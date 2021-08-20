import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/SMS_verification_page/store/sms_verification_store.dart';
import 'package:app/ui/widgets/platform_activity_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";

class SMSVerificationPage extends StatelessWidget {
  static const String routeName = "/smsVerificationPage";

  @override
  Widget build(BuildContext context) {
    final store = context.read<SMSVerificationStore>();
    return ObserverListener<SMSVerificationStore>(
      onSuccess: (){},
      child: Observer(
        builder: (_) => Scaffold(
          appBar: CupertinoNavigationBar(
            automaticallyImplyLeading: true,
            middle: Text("SMS Verification"),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
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
                        maxLines: 1,
                        initialValue: store.phone,
                        onChanged: store.setPhone,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: "+7 *** *** ** **",
                        ),
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: store.phone.length < 7
                            ? null
                            : () async {
                                await store.submitPhoneNumber();
                                store.index = 1;
                              },
                        child: store.isLoading
                            ? Center(
                                child: PlatformActivityIndicator(),
                              )
                            : Text("Submit"),
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
                        maxLines: 1,
                        onChanged: store.setCode,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: "Code",
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: () => store.index = 0,
                            child: Text("Back"),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                width: 1.0,
                                color: Color(0xFF0083C7).withOpacity(0.1),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: store.code.length < 4
                                  ? null
                                  : () async {
                                      await store.submitCode();
                                      if (store.isSuccess)
                                        Navigator.pop(context);
                                    },
                              child: store.isLoading
                                  ? Center(
                                      child: PlatformActivityIndicator(),
                                    )
                                  : Text("Send Code"),
                            ),
                          ),
                        ],
                      ),
                    ],
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
