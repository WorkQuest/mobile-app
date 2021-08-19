import 'dart:ui';
import 'package:app/ui/pages/sign_in_page/sign_in_page.dart';
import 'package:app/ui/pages/sign_up_page/sign_up_page.dart';

abstract class AuthLangKeys {
  static const String _main = 'auth';
  static const String password = '$_main.password';

  /// Localization keys for [SignInPage] page.
  static const String _signIn = '$_main.signIn';
  static const String welcomeTo = '$_signIn.welcomeTo';
  static const String pleaseSignIn = '$_signIn.pleaseSignIn';
  static const String username = '$_signIn.username';
  static const String login = '$_signIn.login';
  static const String doNotHaveAccount = '$_signIn.doNotHaveAccount';
  static const String signUp = '$_signIn.signUp';
  static const String forgotPassword = '$_signIn.forgotPassword';

  /// Localization keys for [SignUpPage] page.
  static const String _signUp = '$_main.signUp';
  static const String firstName = '$_signUp.firstName';
  static const String lastName = '$_signUp.lastName';
  static const String email = '$_signUp.email';
  static const String repeatPassword = '$_signUp.repeatPassword';
  static const String createAccount = '$_signUp.createAccount';
  static const String alreadyHaveAccount = '$_signUp.alreadyHaveAccount';
  static const String signIn = '$_signUp.signIn';

  // /// Localization keys for [QuestPage] page.
  // static const String _questPage = '$_main.signIn';
  // static const String list = '$.email';
}

class Constants {
  static const Map<String, Locale> languageList = {
    "English": Locale('en', 'US'),
    // "Mandarin Chinese": Locale('en', 'US'),
    // "Hindi": Locale('en', 'US'),
    // "Spanish": Locale('en', 'US'),
    // "French": Locale('en', 'US'),
    "Standard Arabic": Locale('ar', 'SA'),
    //"Bengali": Locale('en', 'US'),
    "Russian": Locale('ru', 'RU'),
    // "Portuguese": Locale('en', 'US'),
    // "Indonesian ": Locale('en', 'US'),
  };
  static const List<Color> priorityColors = [
    Color.fromRGBO(34, 204, 20, 1),
    Color.fromRGBO(34, 204, 20, 1),
    Color.fromRGBO(232, 210, 13, 1),
    Color.fromRGBO(223, 51, 51, 1),
  ];
  static const List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
}
