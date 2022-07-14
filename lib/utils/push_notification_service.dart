import 'dart:io';

import 'package:app/main.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/chat_room_page.dart';
import 'package:app/ui/pages/main_page/notification_page/notification_page.dart';
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
        print("notification.body: ${message.toMap()}");
        RemoteNotification? notification = message.notification;
        AndroidNotification? androidNotification =
            message.notification?.android;
        AppleNotification? appleNotification = message.notification?.apple;
        if (notification != null &&
            (androidNotification != null || appleNotification != null)) {
          showNotification(
            notification.hashCode,
            notification.body,
            notification.title,
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
      // RemoteNotification? notification = message.notification;
      if (message.notification != null) {
        if (message.data["action"] == "newMessage")
          Navigator.pushNamed(
            navigatorKey.currentState!.context,
            ChatRoomPage.routeName,
            arguments: ChatRoomArguments(message.data["id"], true),
          );
        else {
          // final userId =
          Navigator.of(navigatorKey.currentState!.context).pushNamed(
            NotificationPage.routeName,
          );
        }
      }
    });
  }

  ///Show Notification using flutter Local Notification
  Future<void> showNotification(
    int hashcode,
    String? body,
    String? title,
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
    );
  }
}
