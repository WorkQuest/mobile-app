import 'package:app/utils/push_notification_service.dart';
import 'package:app/utils/storage.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:app/work_quest_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'di/injector.dart';
import 'package:easy_localization/easy_localization.dart';

///Android Notification Channel
const AndroidNotificationChannel _channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notification',
  'This channel is used for important notifications',
  importance: Importance.max,
  playSound: true,
);

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

///BackGround Message Handler
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("Handling a background message: ${message.messageId}");
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //_initialisePushNotification();
  //init get_it
  injectDependencies(env: Environment.test);
  await Firebase.initializeApp().then(
    (value) => _initialisePushNotification(),
  );

  await EasyLocalization.ensureInitialized();

  //Init Wallet
  final addressActive = await Storage.read(Storage.activeAddress);
  if (addressActive != null) {
    final wallets = await Storage.readWallets();
    if (wallets.isNotEmpty) {
      AccountRepository().userAddresses = wallets;
    }
    AccountRepository().userAddress = addressActive;
  }

  runApp(
    EasyLocalization(
      child: WorkQuestApp(await Storage.toLoginCheck()),
      supportedLocales: [
        Locale('ru', 'RU'),
        Locale('ar', 'SA'),
        Locale('es', 'ES'),
        Locale('en', 'US'),
        Locale('bn', 'BN'),
        Locale('fr', 'FR'),
        Locale('hi', 'HI'),
        Locale('id', 'ID'),
        Locale('zh', 'ZH'),
        Locale('pt', 'PT'),
      ],
      startLocale: Locale('en', 'US'),
      path: 'assets/lang',
    ),
  );
}

void _initialisePushNotification() {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  PushNotificationService(
    _firebaseMessaging,
    _channel,
    _flutterLocalNotificationsPlugin,
  );
  _firebaseMessaging.subscribeToTopic('all');
  //firebaseMessaging.getToken().then((token) => print(" firebase token $token"));
  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}
