import 'dart:convert';
import 'dart:io';

import 'package:app/main.dart';
import 'package:app/model/notification_model.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/chat_room_page.dart';
import 'package:app/ui/pages/main_page/notification_page/notification_page.dart';
import 'package:app/ui/pages/main_page/quest_details_page/details/quest_details_page.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/my_disputes/dispute/dispute_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  PushNotificationService(
    this._fcm,
    this.channel,
    this.flutterLocalNotificationsPlugin,
  ) {
    _initialise();
    _getRemoteNotification();
    _onMessageOpenApp();
  }

  final FirebaseMessaging _fcm;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final AndroidNotificationChannel channel;

  Future _initialise() async {
    try {
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      var initializationSettingsAndroid =
          AndroidInitializationSettings('@drawable/logo_icon');
      var initializationSettingsIOS = new IOSInitializationSettings();
      var initializationSettings = new InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS);
      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: onSelectNotification);
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
        Platform.isAndroid
            ? implementAndroidNotificationPlugin()
            : implementIOSNotificationPlugin();
        messaging();
      } else {
        print('User declined or has not accepted permission');
      }
    } catch (e, trace) {
      print("Push Notifications error: $e\n$trace");
    }
  }

  Future onSelectNotification(String? payload) async {
    final message = NotificationNotification.fromJson(jsonDecode(payload!));
    _openScreen(message);
  }

  ///FlutterLocalNotificationPlugin Implementation for android
  Future<void> implementAndroidNotificationPlugin() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .createNotificationChannel(channel);
  }

  ///FlutterLocalNotificationPlugin Implementation for IOS
  Future<void> implementIOSNotificationPlugin() async {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
  }

  Future<void> messaging() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  ///BackGround Message Handler

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // await Firebase.initializeApp();
//   print("Handling a background message: ${message.messageId}");
// }

  /// add function to an onpressed function

  Future<void> _getRemoteNotification() async {
    try {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? androidNotification =
            message.notification?.android;
        AppleNotification? appleNotification = message.notification?.apple;
        if (notification != null &&
            (androidNotification != null || appleNotification != null)) {
          Map<String, dynamic> data = {
            "data": message.data["data"],
            "action": message.data["action"],
          };
          showNotification(
            notification.hashCode,
            notification.body,
            notification.title,
            JsonEncoder.withIndent('  ').convert(data),
          );
        }
      });
    } catch (e, trace) {
      print("Push Notifications error: $e\n$trace");
    }
  }

  ///OpenApp with message Clicked
  ///
  Future<void> _onMessageOpenApp() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final notification = NotificationNotification.fromJson(message.data);
      _openScreen(notification);
    });
  }

  void _openScreen(NotificationNotification notification) {
    try {
      if (notification.action.toLowerCase().contains("message")) {
        Navigator.pushNamed(
          navigatorKey.currentState!.context,
          ChatRoomPage.routeName,
          arguments: ChatRoomArguments(notification.data.chatId, true),
        );
      } else if (notification.action.toLowerCase().contains("quest")) {
        Navigator.pushNamed(
          navigatorKey.currentState!.context,
          QuestDetails.routeName,
          arguments: QuestArguments(
            id: notification.data.id,
            questInfo: null,
          ),
        );
      } else if (notification.action.toLowerCase().contains("dispute")) {
        Navigator.pushNamed(
          navigatorKey.currentState!.context,
          DisputePage.routeName,
          arguments: notification.data.questId,
        );
      } else {
        Navigator.of(navigatorKey.currentState!.context).pushNamed(
          NotificationPage.routeName,
        );
      }
    } catch (e, trace) {
      print("ERROR: $e");
      print("ERROR: $trace");
    }
  }

  ///Show Notification using flutter Local Notification
  Future<void> showNotification(
    int hashcode,
    String? body,
    String? title,
    String? data,
  ) async {
    flutterLocalNotificationsPlugin.show(
      hashcode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.high,
          color: Colors.blue,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: IOSNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: data,
    );
  }
}
