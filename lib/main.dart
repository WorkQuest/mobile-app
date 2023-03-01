import 'dart:convert';
import 'dart:io';

import 'package:app/constants.dart';
import 'package:app/utils/push_notification/push_notification_service.dart';
import 'package:app/utils/storage.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:app/web3/repository/wallet_repository.dart';
import 'package:app/work_quest_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'di/injector.dart';
import 'package:easy_localization/easy_localization.dart';

import 'firebase_options.dart';

///BackGround Message Handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  Map<String, dynamic> data = {
    "data": message.data["data"],
    "action": message.data["action"],
  };
  final payload = JsonEncoder.withIndent('  ').convert(data);
  Storage.writePushPayload(payload);
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
  //
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
  ).then(
    (value) => _initialisePushNotification(),
  );

  await EasyLocalization.ensureInitialized();
  try {
    final wallet = await Storage.readWallet();
    if (wallet != null) {
      WalletRepository().setWallet(wallet);
    }
    final _networkNameStorage =
        await Storage.read(StorageKeys.networkName.name);
    if (_networkNameStorage == null) {
      WalletRepository().setNetwork(NetworkName.workNetMainnet);
    } else {
      final _networkName = Web3Utils.getNetworkName(_networkNameStorage);
      WalletRepository().setNetwork(_networkName);
    }
  } catch (e) {
    WalletRepository().clearData();
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

void _initialisePushNotification() async {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  PushNotificationService();
  _firebaseMessaging.subscribeToTopic('all');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}
