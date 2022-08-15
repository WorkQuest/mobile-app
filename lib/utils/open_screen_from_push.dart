import 'package:app/main.dart';
import 'package:app/model/notification_model.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/chat_room_page.dart';
import 'package:app/ui/pages/main_page/notification_page/notification_page.dart';
import 'package:app/ui/pages/main_page/quest_details_page/details/quest_details_page.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/my_disputes/dispute/dispute_page.dart';
import 'package:app/utils/storage.dart';
import 'package:app/work_quest_app.dart';
import 'package:flutter/material.dart';

class OpenScreeFromPush {
  void openScreen(NotificationNotification notification) async {
    try {
      BuildContext? con;
      final toLoginCheck = await Storage.toLoginCheck();
      if (navigatorKey.currentState == null) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) {
              con = context;
              return WorkQuestApp(toLoginCheck);
            },
          ),
        );
      }
      if (con == null)
        con = navigatorKey.currentState!.context;
      if (notification.action.toLowerCase().contains("message")) {
        Navigator.pushNamed(
          con!,
          ChatRoomPage.routeName,
          arguments: ChatRoomArguments(notification.data.chatId, true),
        );
      } else if (notification.action.toLowerCase().contains("quest")) {
        Navigator.pushNamed(
          con!,
          QuestDetails.routeName,
          arguments: QuestArguments(
            id: notification.data.id,
          ),
        );
      } else if (notification.action.toLowerCase().contains("dispute")) {
        Navigator.pushNamed(
          con!,
          DisputePage.routeName,
          arguments: notification.data.questId,
        );
      } else {
        Navigator.of(con!).pushNamed(
          NotificationPage.routeName,
          // arguments: notification.recipients?.first,
        );
      }
    } catch (e, trace) {
      print("ERROR: $e");
      print("ERROR: $trace");
    }
  }
}
