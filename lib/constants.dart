import 'dart:ui';

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
