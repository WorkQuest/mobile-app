import 'package:app/keys.dart';
import 'package:flutter/material.dart';
class Commission {
  static const commissionBuy = 0.98;
  static const percentTransfer = 1.01;
}
class Constants {
  static const Map<String, Locale> languageList = {
    "English": Locale('en', 'US'),
    // "Mandarin Chinese": Locale('zh', 'ZH'),
    // "Hindi": Locale('hi', 'HI'),
    // "Spanish": Locale('es', 'ES'),
    // "French": Locale('fr', 'FR'),
    // "Standard Arabic": Locale('ar', 'SA'),
    // "Bengali": Locale('bn', 'BN'),
    // "Russian": Locale('ru', 'RU'),
    // "Portuguese": Locale('pt', 'PT'),
    // "Indonesian ": Locale('id', 'ID'),
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
  static const String base64BlackHolder =
      'R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=';
  static const String base64BlueHolder =
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkaD5eDwADoAHLLpHylgAAAABJRU5ErkJggg==';
  static const String defaultImageNetwork =
      'https://workquest-cdn.fra1.digitaloceanspaces.com/sUYNZfZJvHr8fyVcrRroVo8PpzA5RbTghdnP0yEcJuIhTW26A5vlCYG8mZXs';

  static const String worknetMainnetWQFactory = '0x3d9782B4Ba9C10d09973dd1f7C16410c931f5468';
  static const String worknetTestnetWQFactory = '0xD7B31905E3ff7dDAD0707dCEe6a3537587FD2ca4'; ///testnet
  // static const String worknetTestnetWQFactory = '0x455Fc7ac84ee418F4bD414ab92c9c27b18B7B066'; ///dev-net

  static const String worknetMainnetWQPromotion = '';
  static const String worknetTestnetWQPromotion = '0x23918c4cC7001fB4e2BF28c8283b02BcD6975bf0'; ///testnet
  // static const String worknetTestnetWQPromotion = '0xB778e471833102dBe266DE2747D72b91489568c2'; ///dev-net

  static const String worknetMainnetWUSD = '0x4d9F307F1fa63abC943b5db2CBa1c71D02d86AAa';
  static const String worknetTestnetWUSD = '0xf95ef11d0af1f40995218bb2b67ef909bcf30078'; ///testnet
  // static const String worknetTestnetWUSD = '0x0Ed13A696Fa29151F3064077aCb2a281e68df2aa'; ///dev-net

  static final double commissionForQuest = 1.025;
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
  static final addressBech32RegExp = RegExp(r'[0-9a-zA-Z]');
}

class Configs {
  static final configsNetwork = {
    NetworkName.workNetMainnet: ConfigNetwork(
      rpc: 'https://mainnet-gate.workquest.co/',
      wss: 'wss://mainnet-gate.workquest.co/tendermint-rpc/websocket',
      urlExplorer: '',
      dataCoins: const [
        DataCoins(
          symbolToken: TokenSymbols.WQT,
          iconPath: 'assets/wqt_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.WUSD,
          addressToken: '0x4d9F307F1fa63abC943b5db2CBa1c71D02d86AAa',
          iconPath: 'assets/wusd_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.wETH,
          addressToken: '0x8E52341384F5286f4c76cE1072Aba887Be8E4EB9',
          iconPath: 'assets/eth_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.wBNB,
          addressToken: '0xD7ca5F803807b03D49606D4f8e66551170b1d689',
          iconPath: 'assets/bsc_logo.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.USDT,
          addressToken: '0xD93d2cF0e0179112469188F61ceb948F2Dbe4824',
          iconPath: 'assets/tusdt_coin_icon.svg',
        ),
      ],
    ),
    /// Dev-net
    // NetworkName.workNetTestnet: ConfigNetwork(
    //     rpc: 'https://dev-node-ams3.workquest.co/',
    //     wss: 'wss://wss-dev-node-nyc3.workquest.co/tendermint-rpc/websocket',
    //     urlExplorer: '',
    //     dataCoins: const [
    //       DataCoins(
    //         symbolToken: TokenSymbols.WQT,
    //         iconPath: 'assets/wqt_coin_icon.svg',
    //       ),
    //       DataCoins(
    //         symbolToken: TokenSymbols.WUSD,
    //         addressToken: '0x0ed13a696fa29151f3064077acb2a281e68df2aa',
    //         iconPath: 'assets/wusd_coin_icon.svg',
    //       ),
    //       DataCoins(
    //         symbolToken: TokenSymbols.wETH,
    //         addressToken: '0xd9679c4bc6e1546cfcb9c70ac81a4cbf400e7d24',
    //         iconPath: 'assets/eth_coin_icon.svg',
    //       ),
    //       DataCoins(
    //         symbolToken: TokenSymbols.wBNB,
    //         addressToken: '0x0ed13a696fa29151f3064077acb2a281e68df2aa',
    //         iconPath: 'assets/bsc_logo.svg',
    //       ),
    //       DataCoins(
    //         symbolToken: TokenSymbols.USDT,
    //         addressToken: '0xbd5bbed9677401e911044947cff9fa4979c29bd8',
    //         iconPath: 'assets/tusdt_coin_icon.svg',
    //       ),
    //     ],
    //   ),
    /// Testnet
    NetworkName.workNetTestnet: ConfigNetwork(
      rpc: 'https://testnet-gate.workquest.co/',
      wss: 'wss://testnet-gate.workquest.co/tendermint-rpc/websocket',
      urlExplorer: '',
      dataCoins: const [
        DataCoins(
          symbolToken: TokenSymbols.WQT,
          iconPath: 'assets/wqt_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.WUSD,
          addressToken: '0xf95ef11d0af1f40995218bb2b67ef909bcf30078',
          iconPath: 'assets/wusd_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.wETH,
          addressToken: '0xe550018bc9cf68fed303dfb5f225bb0e6b1e201f',
          iconPath: 'assets/eth_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.wBNB,
          addressToken: '0x0c874699373d34c3ccb322a10ed81aef005004a6',
          iconPath: 'assets/bsc_logo.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.USDT,
          addressToken: '0x72603c4cf5a8474e7e85fa1b352bbda5539c3859',
          iconPath: 'assets/tusdt_coin_icon.svg',
        ),
      ],
    ),
    NetworkName.ethereumMainnet: ConfigNetwork(
      rpc: 'https://eth-mainnet.public.blastapi.io/',
      wss: 'wss://speedy-nodes-nyc.moralis.io/${Keys.moralicKey}/eth/mainnet/ws',
      urlExplorer: 'https://etherscan.io/address/',
      dataCoins: const [
        DataCoins(
          symbolToken: TokenSymbols.ETH,
          iconPath: 'assets/eth_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.WQT,
          addressToken: '0x06677Dc4fE12d3ba3C7CCfD0dF8Cd45e4D4095bF',
          iconPath: 'assets/wqt_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.USDT,
          addressToken:
          '0xdAC17F958D2ee523a2206206994597C13D831ec7', // decimals 6
          iconPath: 'assets/tusdt_coin_icon.svg',
        ),
      ],
    ),
    NetworkName.ethereumTestnet: ConfigNetwork(
      rpc:
      'https://speedy-nodes-nyc.moralis.io/${Keys.moralicKey}/eth/rinkeby',
      wss:
      'wss://speedy-nodes-nyc.moralis.io/${Keys.moralicKey}/eth/rinkeby/ws',
      urlExplorer: 'https://rinkeby.etherscan.io/address/',
      dataCoins: const [
        DataCoins(
          symbolToken: TokenSymbols.ETH,
          iconPath: 'assets/eth_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.WQT,
          addressToken: '0xe21D8B17CF2550DE4bC80779486BDC68Cb3a379E',
          iconPath: 'assets/wqt_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.USDT,
          addressToken:
          '0xD92E713d051C37EbB2561803a3b5FBAbc4962431', // decimals 6
          iconPath: 'assets/tusdt_coin_icon.svg',
        ),
      ],
    ),
    NetworkName.bscMainnet: ConfigNetwork(
      rpc: 'https://bscrpc.com/',
      wss:
      'wss://speedy-nodes-nyc.moralis.io/${Keys.moralicKey}/bsc/mainnet/ws',
      urlExplorer: 'https://bscscan.com/address/',
      dataCoins: const [
        DataCoins(
          symbolToken: TokenSymbols.BNB,
          iconPath: 'assets/bsc_logo.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.WQT,
          addressToken: '0xe89508D74579A06A65B907c91F697CF4F8D9Fac7',
          iconPath: 'assets/wqt_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.USDT,
          addressToken:
          '0x55d398326f99059ff775485246999027b3197955', // decimals 18
          iconPath: 'assets/tusdt_coin_icon.svg',
        ),
      ],
    ),
    NetworkName.bscTestnet: ConfigNetwork(
      rpc:
      'https://speedy-nodes-nyc.moralis.io/${Keys.moralicKey}/bsc/testnet',
      wss:
      'wss://speedy-nodes-nyc.moralis.io/${Keys.moralicKey}/bsc/testnet/ws',
      urlExplorer: 'https://testnet.bscscan.com/address/',
      dataCoins: const [
        DataCoins(
          symbolToken: TokenSymbols.BNB,
          iconPath: 'assets/bsc_logo.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.WQT,
          addressToken: '0x8a62Ee790900Df4349B3c57a0FeBbf71f1f729Db',
          iconPath: 'assets/wqt_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.USDT,
          addressToken:
          '0xC9bda0FA861Bd3F66c7d0Fd75A9A8344e6Caa94A', // decimals 18
          iconPath: 'assets/tusdt_coin_icon.svg',
        ),
      ],
    ),
    NetworkName.polygonMainnet: ConfigNetwork(
      rpc: 'https://polygon-mainnet.public.blastapi.io/',
      wss:
      'wss://speedy-nodes-nyc.moralis.io/${Keys.moralicKey}/polygon/mainnet/ws',
      urlExplorer: 'https://polygonscan.com/address/',
      dataCoins: const [
        DataCoins(
          symbolToken: TokenSymbols.MATIC,
          iconPath: 'assets/matic_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.USDT,
          addressToken:
          '0xc2132D05D31c914a87C6611C10748AEb04B58e8F', // decimals 6
          iconPath: 'assets/tusdt_coin_icon.svg',
        ),
      ],
    ),
    NetworkName.polygonTestnet: ConfigNetwork(
      rpc:
      'https://speedy-nodes-nyc.moralis.io/${Keys.moralicKey}/polygon/mumbai',
      wss:
      'wss://speedy-nodes-nyc.moralis.io/${Keys.moralicKey}/polygon/mumbai/ws',
      urlExplorer: 'https://mumbai.polygonscan.com/address/',
      dataCoins: const [
        DataCoins(
          symbolToken: TokenSymbols.MATIC,
          iconPath: 'assets/matic_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.USDT,
          addressToken:
          '0x631E327EA88C37D4238B5c559A715332266e7Ec1', // decimals 6
          iconPath: 'assets/tusdt_coin_icon.svg',
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

enum NetworkName {
  workNetMainnet,
  workNetTestnet,
  ethereumMainnet,
  ethereumTestnet,
  bscMainnet,
  bscTestnet,
  polygonMainnet,
  polygonTestnet
}

enum Network { testnet, mainnet, }

enum SwitchNetworkNames { WORKNET, ETH, BSC, POLYGON }

enum TokenSymbols { WUSD, WQT, wBNB, wETH, USDT, BNB, ETH, MATIC }
