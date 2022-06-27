import 'dart:io';
import 'package:app/di/injector.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/2FA_page/2FA_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/alert_dialog.dart';
import 'package:app/ui/widgets/dismiss_keyboard.dart';
import 'package:app/ui/widgets/login_button.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import "package:provider/provider.dart";
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

final _spacer = Spacer();

class TwoFAPage extends StatelessWidget {
  static const String routeName = "/2FAPage";

  @override
  Widget build(BuildContext context) {
    final store = context.read<TwoFAStore>();
    final userStore = context.read<ProfileMeStore>();
    final mail = userStore.userData!.email!.split("@");
    final isActiveTotp = userStore.userData?.isTotpActive;

    return DismissKeyboard(
      child: ObserverListener<TwoFAStore>(
        onSuccess: () {},
        child: WillPopScope(
          onWillPop: () async {
            if (isActiveTotp ?? false) return true;
            await dialog(
              context,
              title: "modals.2FaActivation".tr(),
              message: "modals.cancel2Fa".tr(),
              confirmAction: () {
                Navigator.popUntil(
                  context,
                  (route) => route.isFirst,
                );
              },
            );
            return false;
          },
          child: Observer(
            builder: (_) => Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: CupertinoNavigationBar(
                automaticallyImplyLeading: true,
                middle: Text(
                  "settings.2FA".tr(),
                ),
              ),
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  child: isActiveTotp ?? false
                      ? Disable2FA(store)
                      : _Enable2FA(
                          userStore: userStore,
                          mail: mail,
                          store: store,
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Enable2FA extends StatelessWidget {
  final ProfileMeStore userStore;
  final TwoFAStore store;
  final List<String> mail;

  const _Enable2FA({
    Key? key,
    required this.mail,
    required this.store,
    required this.userStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 20.0,
          alignment: AlignmentDirectional.centerStart,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xFFF7F8FA),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) => Observer(
              builder: (_) => AnimatedContainer(
                width: constraints.maxWidth * (store.index + 1) / 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                duration: const Duration(
                  milliseconds: 150,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        LayoutBuilder(
          builder: (context, constraints) => Observer(
            builder: (_) => Text(
              "modals.step".tr() + " ${store.index + 1}",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 23.0,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Expanded(
          child: Confirm2FAPages(
            store: store,
            userStore: userStore,
            mail: mail,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
      ],
    );
  }
}

class Disable2FA extends StatelessWidget {
  final TwoFAStore store;

  const Disable2FA(this.store);

  @override
  Widget build(BuildContext context) {
    return ObserverListener<TwoFAStore>(
      onSuccess: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "modals.enterCodeToDisable2Fa".tr(),
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            onChanged: store.setCodeFromAuthenticator,
            decoration: InputDecoration(
              hintText: "*****",
              //errorText: "InCorrect Code",
            ),
          ),
          Spacer(),
          Observer(
            builder: (_) => ElevatedButton(
              onPressed: store.codeFromAuthenticator.isNotEmpty
                  ? () async {
                      await store.disable2FA();
                      if (store.isSuccess) {
                        await getIt.get<ProfileMeStore>().getProfileMe();
                        Navigator.pop(context);
                        await AlertDialogUtils.showSuccessDialog(context);
                      }
                    }
                  : null,
              child: store.isLoading
                  ? CircularProgressIndicator.adaptive()
                  : Text(
                      "meta.submit".tr(),
                    ),
            ),
          )
        ],
      ),
    );
  }
}

class Confirm2FAPages extends StatefulWidget {
  final TwoFAStore store;
  final ProfileMeStore userStore;
  final List<String> mail;

  const Confirm2FAPages({
    required this.store,
    required this.userStore,
    required this.mail,
  });

  @override
  State<Confirm2FAPages> createState() => _Confirm2FAPagesState();
}

class _Confirm2FAPagesState extends State<Confirm2FAPages> {
  @override
  void initState() {
    widget.store.index = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => IndexedStack(
        index: widget.store.index,
        children: [
          ///Step 1
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "modals.installGoogleAuth".tr(),
              ),
              CupertinoButton(
                onPressed: () async {
                  try {
                    await StoreRedirect.redirect(
                        androidAppId: "com.google.android.apps.authenticator2",
                        iOSAppId: "388497605");
                  } catch (e) {
                    print(e);
                  }
                },
                child: SvgPicture.asset(
                  Platform.isIOS
                      ? "assets/open_ios_appstore.svg"
                      : "assets/open_google_play.svg",
                ),
              ),
              Text(
                "modals.continue2Fa".tr(),
              ),
              _spacer,
              buttonRow(
                widget.store,
                forward: "meta.next",
                back: "meta.cancel",
                context: context,
              ),
            ],
          ),

          ///Step 2
          Column(
            children: [
              Text(
                "modals.pleaseSaveThisKey".tr(),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                height: 50.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                    color: const Color(0xFFF7F8FA), // red as border color
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: SvgPicture.asset("assets/2FA_attention_icon.svg"),
                    ),
                    Expanded(
                      child: Text(
                        widget.store.googleAuthenticatorSecretCode,
                      ),
                    ),
                    IconButton(
                      splashRadius: 20.0,
                      onPressed: () => Clipboard.setData(
                        new ClipboardData(
                          text: widget.store.googleAuthenticatorSecretCode,
                        ),
                      ).then(
                        (_) => SnackBarUtils.success(
                          context,
                          title: "modals.codeCopy".tr(),
                        ),
                      ),
                      icon: SvgPicture.asset(
                        "assets/copy_icon.svg",
                        color: Color(0xFFAAB0B9),
                      ),
                    ),
                  ],
                ),
              ),
              _spacer,
              buttonRow(
                widget.store,
                forward: "meta.next",
                back: "meta.back",
                context: context,
              ),
            ],
          ),

          /// Step 3
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "securityCheck.confCodeDesc".tr(),
              ),
              const SizedBox(
                height: 10.0,
              ),
              _spacer,
              buttonRow(
                widget.store,
                forward: "modals.openApp",
                back: "meta.back",
                context: context,
              ),
            ],
          ),

          ///Step 4
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "settings.enableTwoStepAuth".tr(),
              ),
              const SizedBox(
                height: 25.0,
              ),
              Text(
                "modals.codeFromEmail".tr(),
              ),
              const SizedBox(
                height: 5.0,
              ),
              TextFormField(
                onChanged: widget.store.setCodeFromEmail,
                decoration: InputDecoration(
                  hintText: "*****",
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                widget.mail[0].length > 3
                    ? "modals.6-digitCode".tr() +
                        " ${widget.mail[0][0]}${widget.mail[0][1]}${widget.mail[0][2]}***@${widget.mail[1]}"
                    : "modals.6-digitCode".tr() +
                        " ${widget.mail[0][0]}${widget.mail[0][1]}***@${widget.mail[1]}",
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                "modals.googleConfCode".tr(),
              ),
              TextFormField(
                onChanged: widget.store.setCodeFromAuthenticator,
                decoration: InputDecoration(
                  hintText: "*****",
                ),
              ),
              Text(
                "securityCheck.confCodeDesc".tr(),
              ),
              _spacer,
              buttonRow(
                widget.store,
                forward: "meta.finish",
                back: "meta.back",
                userStore: widget.userStore,
                context: context,
              ),
            ],
          )
        ],
      ),
    );
  }

  ///Bottom row buttons
  Widget buttonRow(
    TwoFAStore store, {
    required String forward,
    required String back,
    ProfileMeStore? userStore,
    required BuildContext context,
  }) =>
      Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 45.0,
              child: OutlinedButton(
                onPressed: () async {
                  if (store.index == 0)
                    await dialog(
                      context,
                      title: "modals.2FaActivation".tr(),
                      message: "modals.cancel2Fa".tr(),
                      confirmAction: () {
                        Navigator.popUntil(
                          context,
                          (route) => route.isFirst,
                        );
                      },
                    );
                  if (store.index > 0) store.index--;
                },
                child: Text(back.tr()),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    width: 1.0,
                    color: Color(0xFF0083C7).withOpacity(0.1),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Observer(
            builder: (_) => Expanded(
              child: LoginButton(
                enabled: store.isLoading,
                onTap: store.index < 3
                    ? () async {
                        if (store.index == 0) await store.enable2FA();
                        if (store.index == 2) await openGoogleAuth();
                        store.index++;
                      }
                    : store.canFinish
                        ? () async {
                            await store.confirm2FA();
                            if (store.isSuccess) {
                              await getIt.get<ProfileMeStore>().getProfileMe();
                              Navigator.pop(context);
                              await AlertDialogUtils.showSuccessDialog(context);
                            }
                          }
                        : null,
                title: forward.tr(),
              ),
            ),
          ),
        ],
      );

  Future<void> openGoogleAuth() async {
    try {
      if (!(await launch(
          "otpauth://totp/${widget.mail}?secret=${widget.store.googleAuthenticatorSecretCode}&issuer=WorkQuest"))) {
        Platform.isIOS
            ? launch(
                "https://apps.apple.com/ru/app/google-authenticator/id388497605")
            : launch("https://play.google.com/store/apps/details?id=" +
                "com.google.android.apps.authenticator2");
      }
    } catch (e) {
      print(e);
      Platform.isIOS
          ? launch(
              "https://apps.apple.com/ru/app/google-authenticator/id388497605")
          : launch("https://play.google.com/store/apps/details?id=" +
              "com.google.android.apps.authenticator2");
    }
  }
}
