import 'package:app/constants.dart';
import 'package:app/model/quests_models/notifications.dart';
import 'package:app/ui/pages/main_page/chat_page/store/chat_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/user_profile_page.dart';
import 'package:app/ui/pages/main_page/quest_details_page/quest_details_page.dart';
import 'package:app/ui/pages/main_page/quest_page/notification_page/store/notification_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/running_line.dart';
import 'package:app/utils/alert_dialog.dart';
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
  late ChatStore chatStore;
  late ProfileMeStore profileMeStore;

  @override
  void initState() {
    store = context.read<NotificationStore>();
    store.getNotification(true);
    chatStore = context.read<ChatStore>();
    profileMeStore = context.read<ProfileMeStore>();
    super.initState();
  }

  Widget build(context) {
    return Scaffold(
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (scrollEnd) {
          final metrics = scrollEnd.metrics;
          if (metrics.maxScrollExtent == metrics.pixels) {
            store.getNotification(false);
          }
          return true;
        },
        child: CustomScrollView(
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
                      separatorBuilder: (context, index) => Divider(
                        thickness: 1,
                      ),
                      itemBuilder: (context, index) => notificationCard(
                        store.listOfNotifications[index],
                      ),
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

  Widget notificationCard(
    NotificationElement body,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          // vertical: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      AlertDialogUtils.showAlertDialog(
                        context,
                        title: Text("Are you sure?"),
                        content: Text(
                          "Do you really want to delete this notification?",
                        ),
                        needCancel: true,
                        titleCancel: "Cancel",
                        titleOk: "Ok",
                        onTabCancel: null,
                        onTabOk: () => store.deleteNotification(body.id),
                        colorCancel: AppColor.enabledButton,
                        colorOk: Colors.red,
                      );
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (body.userId != profileMeStore.userData?.id)
                      await chatStore.getUserData(body.userId);
                    else
                      chatStore.userData = profileMeStore.userData;
                    if (chatStore.userData != null) {
                      await Navigator.of(context, rootNavigator: true)
                          .pushNamed(
                        UserProfile.routeName,
                        arguments: chatStore.userData,
                      );
                      chatStore.userData = null;
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          body.notification.data.user.avatar.url,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 20,
                          child: RunningLine(
                            children: [
                              Text(
                                body.notification.data.user.firstName +
                                    " " +
                                    body.notification.data.user.lastName,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          DateFormat('dd MMM yyyy, kk:mm')
                              .format(body.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFAAB0B9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                "quests.notification.${body.notification.action}".tr(),
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
                      body.notification.data.title,
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
                      onTap: () async {
                        await store.getQuest(body.notification.data.id);
                        await Navigator.of(context, rootNavigator: true)
                            .pushNamed(
                          QuestDetails.routeName,
                          arguments: store.quest,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
