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

  static const String base64WhiteHolder =
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8Xw8AAoMBgDTD2qgAAAAASUVORK5CYII=';
  static const String base64BlueHolder =
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkaD5eDwADoAHLLpHylgAAAABJRU5ErkJggg==';
  static const String defaultImageNetwork =
      'https://workquest-cdn.fra1.digitaloceanspaces.com/sUYNZfZJvHr8fyVcrRroVo8PpzA5RbTghdnP0yEcJuIhTW26A5vlCYG8mZXs';
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

enum ConfigNameNetwork { devnet, testnet }

class Configs {
  static final configsNetwork = {
    ConfigNameNetwork.devnet: ConfigNetwork(
      rpc: 'https://dev-node-ams3.workquest.co',
      wss: 'wss://dev-node-nyc3.workquest.co',
      addresses: AddressCoins(
        wUsd: '0x0ed13a696fa29151f3064077acb2a281e68df2aa',
        wEth: '0x0ed13a696fa29151f3064077acb2a281e68df2aa',
        wBnb: '0xd9679c4bc6e1546cfcb9c70ac81a4cbf400e7d24',
        uSdt: '0xbd5bbed9677401e911044947cff9fa4979c29bd8',
      ),
    ),
    ConfigNameNetwork.testnet: ConfigNetwork(
      rpc: 'https://testnet-gate.workquest.co/',
      wss: 'wss://testnet-gate.workquest.co',
      addresses: AddressCoins(
        wUsd: '0xf95ef11d0af1f40995218bb2b67ef909bcf30078',
        wEth: '0xe550018bc9cf68fed303dfb5f225bb0e6b1e201f',
        wBnb: '0x0c874699373d34c3ccb322a10ed81aef005004a6',
        uSdt: '0x72603c4cf5a8474e7e85fa1b352bbda5539c3859',
      ),
    )
  };
}

class RegExpFields {
  static final emailRegExp = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );
  static final firstNameRegExp = RegExp(r'^[a-zA-Z]+$');
  static final passwordRegExp = RegExp(r'^[а-яА-Я]');
  static final addressRegExp = RegExp(r'[0-9a-fA-F]');
}

class AddressCoins {
  final String wUsd;
  final String wEth;
  final String wBnb;
  final String uSdt;

  AddressCoins({
    required this.wUsd,
    required this.wEth,
    required this.wBnb,
    required this.uSdt,
  });
}

class ConfigNetwork {
  final String rpc;
  final String wss;
  final AddressCoins addresses;

  ConfigNetwork({
    required this.rpc,
    required this.wss,
    required this.addresses,
  });
}

class WorkerBadge {
  final String title;
  final Color color;

  const WorkerBadge(this.title, this.color);
}
