import 'package:app/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_localizations.dart';
import 'ui/pages/sign_in_page/sign_in_page.dart';

class WorkQuestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _theme,
      onGenerateRoute: Routes.generateRoute,
      localeResolutionCallback: _localeResolutionCallback,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }

  Locale? _localeResolutionCallback(Locale? locale, Iterable<Locale> supportedLocales) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.toString() == locale.toString()) {
        return locale;
      }
    }
    return supportedLocales.first;
  }
}

final _theme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  cupertinoOverrideTheme: CupertinoThemeData(
    barBackgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Color(0xFF0083C7),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Color(0xFF0083C7),
  ),
  appBarTheme: AppBarTheme(
    color: Colors.white,
    elevation: 0.0,
    iconTheme: IconThemeData(
      color: Color(0xFF7C838D),
    ),
  ),
  textTheme: TextTheme(
    // Using for all texts except titles
    bodyText2: TextStyle(
      color: Color(0xFF353C47),
      fontSize: 16,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFF7F8FA),
    hintStyle: TextStyle(
      fontSize: 16.0,
      color: Color(0xFFCBCED2),
    ),
    border: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(6.0)),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(
      vertical: 0.0, horizontal: 15.0
    ),
  ),
);
