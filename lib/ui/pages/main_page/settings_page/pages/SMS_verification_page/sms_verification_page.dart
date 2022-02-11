import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/SMS_verification_page/store/sms_verification_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SMSVerificationPage extends StatelessWidget {
  static const String routeName = "/smsVerificationPage";

  final MaskTextInputFormatter formatter =
      MaskTextInputFormatter(mask: "+# (###) ###-##-##");

  @override
  Widget build(BuildContext context) {
    final store = context.read<SMSVerificationStore>();
    final profileMeStore = context.read<ProfileMeStore>();
    return ObserverListener<SMSVerificationStore>(
      onSuccess: () {},
      child: Observer(
        builder: (_) => Scaffold(
          appBar: CupertinoNavigationBar(
            automaticallyImplyLeading: true,
            middle: Text(
              "modals.smsVerification".tr(),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "modals.codeFromSMS".tr(),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    maxLines: 1,
                    onChanged: store.setCode,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "modals.codeFromSMS".tr(),
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "meta.back".tr(),
                        ),
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
                                    profileMeStore.getProfileMe();
                                    Navigator.pop(context);
                                },
                          child: store.isLoading
                              ? Center(
                                  child: CircularProgressIndicator.adaptive(),
                                )
                              : Text(
                                  "meta.send".tr(),
                                ),
                        ),
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
