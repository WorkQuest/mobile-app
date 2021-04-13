import 'package:app/app_localizations.dart';
import 'package:app/login_page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class WorkQuestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
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
          contentPadding: const EdgeInsets.all(
            15.0,
          ),
        ),
      ),
      localeResolutionCallback: _localeResolutionCallback,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }

  Locale _localeResolutionCallback(Locale locale, Iterable<Locale> supportedLocales) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.toString() == locale?.toString()) {
        return locale;
      }
    }
    return supportedLocales.first;
  }
}
