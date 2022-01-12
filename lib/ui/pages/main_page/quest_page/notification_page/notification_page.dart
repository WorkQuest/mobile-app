import 'dart:async';

import 'package:app/ui/pages/main_page/chat_page/chat_room_page/chat_room_page.dart';
import 'package:app/ui/pages/main_page/chat_page/store/chat_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/user_profile_page.dart';
import 'package:app/ui/pages/main_page/quest_page/notification_page/notifications.dart';
import 'package:app/ui/pages/main_page/quest_page/notification_page/store/notification_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  static const String routeName = "/notificationsPage";

  NotificationPage(this.userId);

  final String userId;

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late NotificationStore store;

  @override
  void initState() {
    store = context.read<NotificationStore>();
    super.initState();
  }

  Widget build(context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(
              "ui.notifications.title".tr(),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Observer(
                  builder: (_) => ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: store.listOfNotifications.length,
                    // context.read<ChatStore>().listNotification.length,
                    separatorBuilder: (context, index) => Divider(
                      thickness: 1,
                    ),
                    itemBuilder: (context, index) => notificationCard(
                      // context.read<ChatStore>().listNotification[index]
                      store.listOfNotifications[index],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget notificationCard(
    Notifications? body,
  ) =>
      Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  context.read<ChatStore>().getUserData(body!.idUser);
                  Timer.periodic(Duration(milliseconds: 100), (timer) {
                    if (context.read<ChatStore>().userData != null) {
                      timer.cancel();
                      Navigator.of(context, rootNavigator: true).pushNamed(
                        UserProfile.routeName,
                        arguments: context.read<ChatStore>().userData,
                      );
                      context.read<ChatStore>().userData = null;
                    }
                  });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        body!.avatar.url,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(top: 11),
                      child: Text(body.firstName + " " + body.lastName),
                    ),
                    Spacer(),
                    Text(
                      DateFormat('dd MMM yyyy, kk:mm').format(body.date),
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFAAB0B9),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  body.type.tr(),
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFFAAB0B9),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Color(0xFFF7F8FA),
                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                ),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      child: Text(
                        body.message,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Align(
                      child: InkWell(
                        child: Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: Colors.blueAccent,
                          size: 20,
                        ),
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).pushNamed(
                            ChatRoomPage.routeName,
                            arguments: body.idEvent,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
