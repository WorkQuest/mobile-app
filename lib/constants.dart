import 'package:flutter/material.dart';

class Constants {

  static const Map<String, Locale> languageList = {
    "English": Locale('en', 'US'),
    "Mandarin Chinese": Locale('zh', 'ZH'),
    "Hindi": Locale('hi', 'HI'),
    "Spanish": Locale('es', 'ES'),
    "French": Locale('fr', 'FR'),
    "Standard Arabic": Locale('ar', 'SA'),
    "Bengali": Locale('bn', 'BN'),
    "Russian": Locale('ru', 'RU'),
    "Portuguese": Locale('pt', 'PT'),
    "Indonesian ": Locale('id', 'ID'),
  };

  static const List<Color> priorityColors = [
    Color.fromRGBO(34, 204, 20, 1),
    Color.fromRGBO(34, 204, 20, 1),
    Color.fromRGBO(232, 210, 13, 1),
    Color.fromRGBO(223, 51, 51, 1),
  ];

  static const Map<String, WorkerBadge> workerRatingTag = {
    "topRanked": WorkerBadge("GOLD PLUS", Color(0xFFF6CF00)),
    "reliable": WorkerBadge("SILVER", Color(0xFFBBC0C7)),
    "verified": WorkerBadge("BRONZE", Color(0xFFB79768)),
  };

  static const String base64WhiteHolder = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8Xw8AAoMBgDTD2qgAAAAASUVORK5CYII=';
  static const String base64BlueHolder = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkaD5eDwADoAHLLpHylgAAAABJRU5ErkJggg==';
  static const String defaultImageNetwork = 'https://workquest-cdn.fra1.digitaloceanspaces.com/sUYNZfZJvHr8fyVcrRroVo8PpzA5RbTghdnP0yEcJuIhTW26A5vlCYG8mZXs';
}

abstract class AppColor {
  static const Color primary = const Color(0xFF0083C7);
  static const Color green = const Color(0xFF00AA5B);
  static const blue = Color(0xff103D7C);
  static const disabledText = Color(0xffD8DFE3);
  static const subtitleText = Color(0xff7C838D);
  static const enabledText = Colors.white;
  static const enabledButton = Color(0xff0083C7);
  static const disabledButton = Color(0xffF7F8FA);
  static const unselectedBottomIcon = Color(0xffAAB0B9);
  static const selectedBottomIcon = enabledButton;
  static const star = Color(0xffE8D20D);
}

class AddressCoins {
  static const wUsd = '0x917dc1a9e858deb0a5bdcb44c7601f655f728dfe';
  static const wEth = '0x34808eb7d2bf0b935bdefb20ff77aa77d59f7cc3';
  static const wBnb = '0x631e327ea88c37d4238b5c559a715332266e7ec1';
}

class WorkerBadge {
  final String title;
  final Color color;

  const WorkerBadge(this.title, this.color);
}
