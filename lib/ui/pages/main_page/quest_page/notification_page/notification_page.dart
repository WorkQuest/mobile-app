import 'package:app/constants.dart';
import 'package:app/model/quests_models/notifications.dart';
import 'package:app/ui/pages/main_page/chat_page/store/chat_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/user_profile_page.dart';
import 'package:app/ui/pages/main_page/quest_details_page/details/quest_details_page.dart';
import 'package:app/ui/pages/main_page/quest_page/notification_page/store/notification_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/shimmer.dart';

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
    store.updateNotification();
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
        child: RefreshIndicator(
          onRefresh: () => store.updateNotification(),
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
                      builder: (_) {
                        if (store.isLoading) {
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 6,
                            separatorBuilder: (context, index) =>
                                Divider(
                                  thickness: 1,
                                ),
                            itemBuilder: (context, index) => const _ShimmerNotificationView(),
                          );
                        }
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: store.listOfNotifications.length,
                          separatorBuilder: (context, index) =>
                              Divider(
                                thickness: 1,
                              ),
                          itemBuilder: (context, index) =>
                              _NotificationView(
                                body: store.listOfNotifications[index],
                                onTap: () async {
                                  final body = store.listOfNotifications[index];
                                  if (body.notification.data.user.id !=
                                      profileMeStore.userData?.id)
                                    await chatStore.getUserData(
                                        body.notification.data.user.id);
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
                                onTabOk: () =>
                                    store
                                        .deleteNotification(
                                        store.listOfNotifications[index].id),
                                onTapPushQuest: () async {
                                  await store.getQuest(
                                      store.listOfNotifications[index].notification.data
                                          .id);
                                  await Navigator.of(context, rootNavigator: true)
                                      .pushNamed(
                                    QuestDetails.routeName,
                                    arguments: store.quest,
                                  );
                                },
                              ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationView extends StatelessWidget {
  final NotificationElement body;
  final Function()? onTabOk;
  final Function()? onTap;
  final Function()? onTapPushQuest;

  const _NotificationView({
    Key? key,
    required this.body,
    required this.onTabOk,
    required this.onTap,
    required this.onTapPushQuest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
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
                      onTabOk: onTabOk,
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
                onTap: onTap,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        body.notification.data.user.avatar?.url ??
                            "https://workquest-cdn.fra1.digitaloceanspaces.com/sUYNZfZJvHr8fyVcrRroVo8PpzA5RbTghdnP0yEcJuIhTW26A5vlCYG8mZXs",
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        body.notification.data.user.firstName +
                            " " +
                            body.notification.data.user.lastName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        DateFormat('dd MMM yyyy, kk:mm').format(body.createdAt),
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
            child: GestureDetector(
              onTap: onTapPushQuest,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      body.notification.data.title!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: Colors.blueAccent,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerNotificationView extends StatelessWidget {
  const _ShimmerNotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Shimmer.stand(
                  child: Container(
                    height: 34,
                    width: 34,
                    padding: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Shimmer.stand(
                      child: Container(
                        height: 40,
                        width: 40,
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Shimmer.stand(
                    child: Container(
                      height: 30,
                      width: 220,
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Shimmer.stand(
                      child: Container(
                        height: 30,
                        width: 130,
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.centerLeft,
            child: Shimmer.stand(
              child: Container(
                height: 30,
                width: 140,
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
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
                Shimmer.stand(
                  child: Container(
                    height: 30,
                    width: 140,
                    padding: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
                Shimmer.stand(
                  child: Container(
                    height: 20,
                    width: 20,
                    padding: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

/*Shimmer.stand(
            child: Container(
              height: 34,
              width: 34,
              padding: const EdgeInsets.all(10.0),
              decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            ),
          ),*/
}

