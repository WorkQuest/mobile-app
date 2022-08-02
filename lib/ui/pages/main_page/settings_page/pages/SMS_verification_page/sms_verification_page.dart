import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/SMS_verification_page/store/sms_verification_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/default_textfield.dart';
import 'package:app/ui/widgets/login_button.dart';
import 'package:app/ui/widgets/timer.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';

class SMSVerificationPage extends StatefulWidget {
  static const String routeName = "/smsVerificationPage";

  @override
  State<SMSVerificationPage> createState() => _SMSVerificationPageState();
}

class _SMSVerificationPageState extends State<SMSVerificationPage> {
  late SMSVerificationStore smsStore;
  late ProfileMeStore profileStore;

  late TextEditingController _smsController;

  @override
  void initState() {
    _smsController = TextEditingController();
    smsStore = context.read<SMSVerificationStore>();
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
                  TimerWidget(
                    startTimer: () => smsStore.startTimer(),
                    seconds: smsStore.secondsCodeAgain,
                    isActiveTimer: smsStore.timer != null && smsStore.timer!.isActive,
                  ),
                  Text(
                    "modals.codeFromSMS".tr(),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  DefaultTextField(
                    controller: _smsController,
                    onChanged: smsStore.setCode,
                    keyboardType: TextInputType.phone,
                    hint: "modals.codeFromSMS".tr(),
                    inputFormatters: [],
                    suffixIcon: null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
