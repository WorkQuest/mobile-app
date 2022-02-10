import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/SMS_verification_page/store/sms_verification_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/utils/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              child: IndexedStack(
                index: store.index,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "modals.phoneNumber".tr(),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF7F8FA),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 15,
                            ),
                            Text("+"),
                            Expanded(
                              child: TextFormField(
                                maxLines: 1,
                                validator: Validators.phoneNumberValidator,
                                onChanged: store.setPhone,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]'),
                                  ),
                                  LengthLimitingTextInputFormatter(13),
                                ],
                                decoration: InputDecoration(
                                  hintText: "International format",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: store.phone.length < 11
                            ? null
                            : () async {
                                await store.submitPhoneNumber();
                                if (store.validate) store.index = 1;
                              },
                        child: store.isLoading
                            ? Center(
                                child: CircularProgressIndicator.adaptive(),
                              )
                            : Text(
                                "meta.submit".tr(),
                              ),
                      ),
                    ],
                  ),
                  Column(
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
                            onPressed: () => store.index = 0,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
