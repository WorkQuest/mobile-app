import 'dart:io';

import 'package:app/constants.dart';
import 'package:app/utils/storage.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:app/work_quest_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'di/injector.dart';
import 'package:easy_localization/easy_localization.dart';

import 'firebase_options.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  injectDependencies(env: Environment.test);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ),
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await EasyLocalization.ensureInitialized();
  try {
    final wallet = await Storage.readWallet();
    if (wallet != null) {
      AccountRepository().setWallet(wallet);
    }
    final _networkNameStorage =
        await Storage.read(StorageKeys.networkName.name);
    if (_networkNameStorage == null) {
      AccountRepository().setNetwork(NetworkName.workNetMainnet);
      await Storage.write(
          StorageKeys.networkName.name, NetworkName.workNetMainnet.name);
    } else {
      final _networkName = Web3Utils.getNetworkName(_networkNameStorage);
      AccountRepository().setNetwork(_networkName);
      await Storage.write(StorageKeys.networkName.name, _networkName.name);
    }
  } catch (e) {
    AccountRepository().clearData();
  }

  final deepLinksCheck = await Storage.readDeepLinkCheck();
  if (deepLinksCheck != "0") Storage.writeDeepLinkCheck("0");

  runApp(
    EasyLocalization(
      child: WorkQuestApp(await Storage.toLoginCheck()),
      supportedLocales: [
        Locale('en', 'US'),
        // Locale('ru', 'RU'),
        // Locale('ar', 'SA'),
        // Locale('es', 'ES'),
        // Locale('bn', 'BN'),
        // Locale('fr', 'FR'),
        // Locale('hi', 'HI'),
        // Locale('id', 'ID'),
        // Locale('zh', 'ZH'),
        // Locale('pt', 'PT'),
      ],
      startLocale: Locale('en', 'US'),
      path: 'assets/lang',
    ),
  );
}