import 'package:app/routes.dart';
import 'package:app/ui/pages/main_page/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_localizations.dart';

class WorkQuestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _theme,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.generateRoute,
      localeResolutionCallback: _localeResolutionCallback,
      initialRoute: MainPage.routeName,
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
  unselectedWidgetColor: const Color(0xFFCBCED2),
  cupertinoOverrideTheme: const CupertinoThemeData(
    barBackgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: const Color(0xFF0083C7),
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
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: const Color(0xFF0083C7),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: const Color(0xFF0083C7),
    foregroundColor: Colors.white,
    elevation: 0.0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: const Color(0xFF0083C7),
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
      color: const Color(0xFF7C838D),
    ),
  ),
  textTheme: const TextTheme(
    // Using for all texts except titles
    bodyText2: const TextStyle(
      color: const Color(0xFF353C47),
      fontSize: 16,
    ),
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
