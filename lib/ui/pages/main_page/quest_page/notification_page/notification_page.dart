import 'package:app/constants.dart';
import 'package:app/model/quests_models/notifications.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/create_review_page/create_review_page.dart';
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
  late ProfileMeStore profileMeStore;

  @override
  void initState() {
    store = context.read<NotificationStore>();
    store.updateNotification();
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
                largeTitle: Text("ui.notifications.title".tr()),
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
                            separatorBuilder: (context, index) => Divider(
                              thickness: 1,
                            ),
                            itemBuilder: (context, index) =>
                                const _ShimmerNotificationView(),
                          );
                        }
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: store.listOfNotifications.length,
                          separatorBuilder: (context, index) => Divider(
                            thickness: 1,
                          ),
                          itemBuilder: (context, index) => Column(
                            children: [
                              _NotificationView(
                                store: store,
                                body: store.listOfNotifications[index],
                                onTap: () async {
                                  final body = store.listOfNotifications[index];
                                  await Navigator.of(context,
                                          rootNavigator: true)
                                      .pushNamed(
                                    UserProfile.routeName,
                                    arguments: body.notification.data.user.id !=
                                            profileMeStore.userData!.id
                                        ? ProfileArguments(
                                            role: body
                                                .notification.data.user.role,
                                            userId:
                                                body.notification.data.user.id,
                                          )
                                        : null,
                                  );
                                },
                                onTabOk: () => store.deleteNotification(
                                    store.listOfNotifications[index].id),
                                onTapPushQuest: () async {
                                  await store.getQuest(
                                    store.listOfNotifications[index]
                                        .notification.data.id,
                                  );
                                  await Navigator.of(context,
                                          rootNavigator: true)
                                      .pushNamed(
                                    QuestDetails.routeName,
                                    arguments: QuestArguments(
                                      questInfo: store.quest,
                                      id: null,
                                    ),
                                  );
                                },
                              ),
                              if (index == store.listOfNotifications.length - 1)
                                Divider(thickness: 1),
                            ],
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

class _NotificationView extends StatefulWidget {
  final NotificationStore store;
  final NotificationElement body;
  final Function()? onTabOk;
  final Function()? onTap;
  final Function()? onTapPushQuest;

  const _NotificationView({
    required this.store,
    required this.body,
    required this.onTabOk,
    required this.onTap,
    required this.onTapPushQuest,
  });

  @override
  State<_NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<_NotificationView> {
  @override
  void initState() {
    if (widget.body.notification.data.disputeId != null)
      Future.delayed(Duration.zero, () {
        widget.store.getDispute(widget.body.notification.data.disputeId!);
      });
    super.initState();
  }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Observer(
                    builder: (_) => widget
                                .store
                                .disputes[
                                    widget.body.notification.data.disputeId ??
                                        ""]
                                ?.currentUserDisputeReview !=
                            null
                        ? TextButton(
                            onPressed: () async {
                              await Navigator.pushNamed(
                                context,
                                CreateReviewPage.routeName,
                                arguments: ReviewArguments(
                                  null,
                                  widget.body.notification.data.disputeId,
                                ),
                              );
                            },
                            child: Text("chat.addReviewArbiter".tr()),
                          )
                        : const SizedBox(),
                  ),
                  IconButton(
                    onPressed: () {
                      AlertDialogUtils.showAlertDialog(
                        context,
                        title: Text("meta.areYouSure".tr()),
                        content: Padding(
                          padding: const EdgeInsets.only(
                            left: 25.0,
                            top: 16,
                          ),
                          child: Text(
                            "modals.quesDeleteNotif".tr(),
                          ),
                        ),
                        needCancel: true,
                        titleCancel: "meta.cancel".tr(),
                        titleOk: "Ok",
                        onTabCancel: null,
                        onTabOk: widget.onTabOk,
                        colorCancel: AppColor.enabledButton,
                        colorOk: Colors.red,
                      );
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: widget.onTap,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        widget.body.notification.data.user.avatar?.url ??
                            Constants.defaultImageNetwork,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.body.notification.data.user.firstName +
                            " " +
                            widget.body.notification.data.user.lastName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        DateFormat('dd MMM yyyy, kk:mm')
                            .format(widget.body.createdAt),
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
              "quests.notification.${widget.body.notification.action}".tr(),
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
              onTap: widget.onTapPushQuest,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.body.notification.data.title!,
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _ShimmerItem(height: 34, width: 34),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _ShimmerItem(height: 46, width: 46),
                  const SizedBox(width: 10),
                  _ShimmerItem(height: 20, width: 220),
                  const SizedBox(width: 5),
                ],
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.centerLeft,
            child: const _ShimmerItem(
              width: 130,
              height: 20,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ShimmerItem(height: 40, width: 320),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShimmerItem extends StatelessWidget {
  final double height;
  final double width;

  const _ShimmerItem({
    Key? key,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.stand(
      child: Container(
        child: SizedBox(
          height: height,
          width: width,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
        ),
      ),
    );
  }
}
