import 'dart:convert';
import 'dart:ui';

import 'package:app/model/notification_model.dart';
import 'package:app/routes.dart';
import 'package:app/ui/pages/pin_code_page/pin_code_page.dart';
import 'package:app/ui/pages/start_page/start_page.dart';
import 'package:app/ui/widgets/CustomBanner.dart';
import 'package:app/utils/open_screen_from_push.dart';
import 'package:app/utils/storage.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:firebase_notifications_handler/firebase_notifications_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'constants.dart';
import 'main.dart';

class WorkQuestApp extends StatelessWidget {
  final bool isToken;

  WorkQuestApp(this.isToken);

  @override
  Widget build(BuildContext context) {
    return FirebaseNotificationsHandler(
      onTap: _onTap,
      child: ValueListenableBuilder<Network>(
          valueListenable: AccountRepository().notifierNetwork,
          builder: (_, value, child) {
            final name = value.name;
            final visible = name != Network.mainnet.name;
            return CustomBanner(
              text: '${name.substring(0, 1).toUpperCase()}${name.substring(1)}',
              visible: false,
              color: visible ? Colors.grey : Colors.transparent,
              textStyle: visible
                  ? const TextStyle(
                      color: AppColor.enabledText,
                      fontWeight: FontWeight.bold,
                    )
                  : const TextStyle(
                      color: Colors.transparent,
                      fontWeight: FontWeight.bold,
                    ),
              child: child!,
            );
          },
          child: MaterialApp(
            navigatorKey: navigatorKey,
            theme: _theme,
            builder: (context, child) {
              final mq = MediaQuery.of(context);
              double fontScale;
              if (window.textScaleFactor > 1.1) {
                fontScale = 1.1;
              } else if (window.textScaleFactor < 0.9) {
                fontScale = 0.8;
              } else {
                fontScale = window.textScaleFactor;
              }
              return MediaQuery(
                data: mq.copyWith(textScaleFactor: fontScale),
                child: child!,
              );
            },
            debugShowCheckedModeBanner: false,
            onGenerateRoute: Routes.generateRoute,
            initialRoute: isToken ? PinCodePage.routeName : StartPage.routeName,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
          )),
    );
  }

  _onTap(
    GlobalKey<NavigatorState> navigatorState,
    AppState appState,
    Map<dynamic, dynamic> payload,
  ) {
    final notification = NotificationNotification.fromJson(
      payload as Map<String, dynamic>,
    );
    final response = {
      "data": notification.data,
      "action": notification.action,
    };
    if (appState.name == "closed") {
      Storage.writePushPayload(
        JsonEncoder.withIndent('  ').convert(response),
      );
    } else {
      OpenScreeFromPush().openScreen(notification);
    }
  }
}

final _theme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  unselectedWidgetColor: const Color(0xFFCBCED2),
  cupertinoOverrideTheme: const CupertinoThemeData(
    barBackgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: AppColor.primary,
    textTheme: CupertinoTextThemeData(
      navLargeTitleTextStyle: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1D2127),
      ),
      navTitleTextStyle: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1D2127),
      ),
    ),
  ),
  primaryColor: AppColor.primary,
  iconTheme: IconThemeData(
    color: AppColor.primary,
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: AppColor.primary,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColor.primary,
    foregroundColor: Colors.white,
    elevation: 0.0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: AppColor.primary,
      onPrimary: Colors.white,
      onSurface: const Color(0xFFCBCED2),
      elevation: 0.0,
      shadowColor: Colors.transparent,
      animationDuration: Duration.zero,
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      minimumSize: const Size(
        double.infinity,
        43,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(6.0),
        ),
      ),
    ),
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.white,
    elevation: 0.0,
    iconTheme: const IconThemeData(
      color: const Color(0xFF0083C7),
    ),
  ),
  textTheme: const TextTheme(
    // Using for all texts except titles
    bodyText2: const TextStyle(
      color: const Color(0xFF353C47),
      fontSize: 16,
    ),
  ),
  primaryIconTheme: IconThemeData(
    color: const Color(0xFF7C838D),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    isDense: true,
    fillColor: const Color(0xFFF7F8FA),
    hintStyle: const TextStyle(
      fontSize: 16.0,
      color: const Color(0xFFCBCED2),
    ),
    border: const OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(6.0)),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(
      vertical: 12.5,
      horizontal: 12.5,
    ),
  ),
);
