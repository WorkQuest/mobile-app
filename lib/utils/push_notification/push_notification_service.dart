import 'dart:convert';
import 'dart:io';

import 'package:app/model/notification_model.dart';
import 'package:app/utils/push_notification/open_scree_from_push.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  PushNotificationService() {
    _initialise();
    _getRemoteNotification();
    _onMessageOpenApp();
  }

  FirebaseMessaging _fcm = FirebaseMessaging.instance;
  AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notification',
    description: 'This channel is used for important notifications',
    importance: Importance.max,
    playSound: true,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

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
          AndroidInitializationSettings('@drawable/logo');
      var initializationSettingsIOS = new IOSInitializationSettings();
      var initializationSettings = new InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS);

      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: onSelectNotification);

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
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
    final notification =
        NotificationNotification.fromJson(jsonDecode(payload!));
    OpenScreeFromPush().openScreen(notification);
  }

  Future<void> implementAndroidNotificationPlugin() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .createNotificationChannel(channel);
  }

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

  Future<void> _getRemoteNotification() async {
    try {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? androidNotification =
            message.notification?.android;
        if (notification != null && androidNotification != null) {
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

  Future<void> _onMessageOpenApp() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final notification = NotificationNotification.fromJson(message.data);
      OpenScreeFromPush().openScreen(notification);
    });
  }

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
          color: Colors.white,
          playSound: true,
          icon: '@drawable/logo',
        ),
      ),
      payload: data,
    );
  }
}
