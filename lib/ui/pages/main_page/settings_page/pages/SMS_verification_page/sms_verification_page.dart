import 'package:app/constants.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/SMS_verification_page/store/sms_verification_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/login_button.dart';
import 'package:app/ui/widgets/timer.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';
import 'package:sms_autofill/sms_autofill.dart';

class SMSVerificationPage extends StatefulWidget {
  static const String routeName = "/smsVerificationPage";

  @override
  State<SMSVerificationPage> createState() => _SMSVerificationPageState();
}

class _SMSVerificationPageState extends State<SMSVerificationPage> {
  late SMSVerificationStore smsStore;
  late ProfileMeStore profileStore;

  @override
  void initState() {
    smsStore = context.read<SMSVerificationStore>();
    if (!(smsStore.timer?.isActive ?? false)) {
      smsStore.submitPhoneNumber();
      smsStore.startTimer();
    }
    smsStore.setCode("");
    profileStore = context.read<ProfileMeStore>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObserverListener<SMSVerificationStore>(
      onSuccess: () async {
        if (smsStore.successData == SMSVerificationStatus.submitCode) {
          await AlertDialogUtils.showSuccessDialog(context);
          await profileStore.getProfileMe();
          Navigator.pop(context);
        }
      },
      onFailure: () => false,
      child: Observer(
        builder: (_) => Scaffold(
          appBar: CupertinoNavigationBar(
            automaticallyImplyLeading: true,
            middle: Text("modals.smsVerification".tr()),
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
                  TimerWidget(
                    startTimer: () => smsStore.startTimer(),
                    seconds: smsStore.secondsCodeAgain,
                    isActiveTimer:
                        smsStore.timer != null && smsStore.timer!.isActive,
                  ),
                  Text("modals.codeFromSMS".tr()),
                  const SizedBox(height: 10.0),
                  PinFieldAutoFill(
                    decoration: BoxLooseDecoration(
                      strokeColorBuilder: PinListenColorBuilder(
                        AppColor.enabledButton,
                        Colors.grey,
                      ),
                    ),
                    cursor: Cursor(
                      width: 2,
                      color: Colors.lightBlue,
                      radius: Radius.circular(1),
                      enabled: true,
                    ),
                    textInputAction: TextInputAction.go,
                    currentCode: smsStore.code,
                    onCodeChanged: smsStore.setCode,
                    codeLength: 6,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                  const SizedBox(height: 10),
                  Spacer(),
                  LoginButton(
                    withColumn: true,
                    enabled: smsStore.isLoading,
                    onTap: smsStore.canSubmitCode ? smsStore.submitCode : null,
                    title: "meta.send".tr(),
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
