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

  static const worknetWQFactory = '0xD7B31905E3ff7dDAD0707dCEe6a3537587FD2ca4';
  static const worknetPromotion = '0x23918c4cC7001fB4e2BF28c8283b02BcD6975bf0';
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

class RegExpFields {
  static final emailRegExp = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );
  static final firstNameRegExp = RegExp(r'^[a-zA-Z]+$');
  static final passwordRegExp = RegExp(r'^[а-яА-Я]');
  static final addressRegExp = RegExp(r'[0-9a-fA-F]');
}

class Configs {
  static final configsNetwork = {
    ConfigNameNetwork.testnet: ConfigNetwork(
      rpc: 'https://dev-node-ams3.workquest.co',
      wss: 'wss://wss-dev-node-ams3.workquest.co',
      urlExplorer: '',
      dataCoins: [
        DataCoins(
          symbolToken: TokenSymbols.WQT,
          iconPath: 'assets/coins/wqt.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.WUSD,
          addressToken: '0x0ed13a696fa29151f3064077acb2a281e68df2aa',
          iconPath: 'assets/coins/wusd.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.wETH,
          addressToken: '0xd9679c4bc6e1546cfcb9c70ac81a4cbf400e7d24',
          iconPath: 'assets/coins/weth.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.wBNB,
          addressToken: '0x0ed13a696fa29151f3064077acb2a281e68df2aa',
          iconPath: 'assets/coins/wbnb.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.USDT,
          addressToken: '0xbd5bbed9677401e911044947cff9fa4979c29bd8',
          iconPath: 'assets/coins/usdt.svg',
        ),
      ],
    ),
    ConfigNameNetwork.rinkeby: ConfigNetwork(
      rpc:
          'https://speedy-nodes-nyc.moralis.io/b42d7d2a9baf055b2076cc12/eth/rinkeby',
      wss:
          'wss://speedy-nodes-nyc.moralis.io/b42d7d2a9baf055b2076cc12/eth/rinkeby/ws',
      urlExplorer: 'https://rinkeby.etherscan.io/address/',
      dataCoins: [
        DataCoins(
          symbolToken: TokenSymbols.ETH,
          iconPath: 'assets/coins/weth.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.USDT,
          addressToken: '0xD92E713d051C37EbB2561803a3b5FBAbc4962431',
          iconPath: 'assets/coins/usdt.svg',
        ),
      ],
    ),
    ConfigNameNetwork.binance: ConfigNetwork(
      rpc:
          'https://speedy-nodes-nyc.moralis.io/b42d7d2a9baf055b2076cc12/bsc/testnet',
      wss:
          'wss://speedy-nodes-nyc.moralis.io/b42d7d2a9baf055b2076cc12/bsc/testnet/ws',
      urlExplorer: 'https://testnet.bscscan.com/address/',
      dataCoins: [
        DataCoins(
          symbolToken: TokenSymbols.BNB,
          iconPath: 'assets/coins/wbnb.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.USDT,
          addressToken: '0xC9bda0FA861Bd3F66c7d0Fd75A9A8344e6Caa94A',
          iconPath: 'assets/coins/usdt.svg',
        ),
      ],
    ),
    ConfigNameNetwork.polygon: ConfigNetwork(
      rpc:
          'https://speedy-nodes-nyc.moralis.io/b42d7d2a9baf055b2076cc12/polygon/mumbai',
      wss:
          'wss://speedy-nodes-nyc.moralis.io/b42d7d2a9baf055b2076cc12/polygon/mumbai/ws',
      urlExplorer: 'https://mumbai.polygonscan.com/address/',
      dataCoins: [
        DataCoins(
          symbolToken: TokenSymbols.MATIC,
          iconPath: 'assets/coins/wqt.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.USDT,
          addressToken: '0x631E327EA88C37D4238B5c559A715332266e7Ec1',
          iconPath: 'assets/coins/usdt.svg',
        ),
      ],
    ),
  };
}

class ConfigNetwork {
  final String rpc;
  final String wss;
  final String urlExplorer;
  final List<DataCoins> dataCoins;

  ConfigNetwork({
    required this.rpc,
    required this.wss,
    required this.urlExplorer,
    required this.dataCoins,
  });
}

class DataCoins {
  final TokenSymbols symbolToken;
  final String? addressToken;
  final String iconPath;

  const DataCoins({
    required this.symbolToken,
    required this.iconPath,
    this.addressToken,
  });
}

class WorkerBadge {
  final String title;
  final Color color;

  const WorkerBadge(this.title, this.color);
}

enum ConfigNameNetwork { testnet, rinkeby, binance, polygon }

enum TokenSymbols { WUSD, WQT, wBNB, wETH, USDT, BNB, ETH, MATIC }
