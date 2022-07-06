import 'package:app/constants.dart';
import 'package:app/model/notification_model.dart';
import 'package:app/ui/pages/main_page/notification_page/store/notification_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/create_review_page/create_review_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/store/user_profile_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/user_profile_page.dart';
import 'package:app/ui/pages/main_page/quest_details_page/details/quest_details_page.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/my_disputes/dispute/dispute_page.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class NotificationCell extends StatefulWidget {
  final NotificationStore store;
  final NotificationElement body;
  final String userId;

  const NotificationCell({
    required this.store,
    required this.body,
    required this.userId,
  });

  @override
  State<NotificationCell> createState() => _NotificationCellState();
}

class _NotificationCellState extends State<NotificationCell> {
  String action = "";

  @override
  void initState() {
    action = widget.body.notification.action.toLowerCase();
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
                        ? OutlinedButton(
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
                            child: Text("Add review to the arbiter"),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                width: 1.0,
                                color: Color(0xFF0083C7).withOpacity(0.1),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ),
                  IconButton(
                    onPressed: () {
                      AlertDialogUtils.showAlertDialog(
                        context,
                        title: Text("Are you sure?"),
                        content: Padding(
                          padding: const EdgeInsets.only(
                            left: 25.0,
                            top: 16,
                          ),
                          child: Text(
                            "Do you really want \nto delete this notification?",
                          ),
                        ),
                        needCancel: true,
                        titleCancel: "Cancel",
                        titleOk: "Ok",
                        onTabCancel: null,
                        onTabOk: () {
                          widget.store.deleteNotification(
                            widget.body.id,
                          );
                        },
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
                onTap: () async {
                  context.read<UserProfileStore>().initRole(
                        widget.body.notification.data.user.role,
                      );
                  await Navigator.of(context, rootNavigator: true).pushNamed(
                    UserProfile.routeName,
                    arguments:
                        widget.body.notification.data.user.id != widget.userId
                            ? ProfileArguments(
                                role: widget.body.notification.data.user.role,
                                userId: widget.body.notification.data.user.id,
                              )
                            : null,
                  );
                },
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
              onTap: () async {
                if (action.contains("quest")) {
                  await Navigator.of(context, rootNavigator: true).pushNamed(
                    QuestDetails.routeName,
                    arguments: QuestArguments(
                      questInfo: null,
                      id: widget.body.notification.data.id,
                    ),
                  );
                } else if (action.contains("dispute")) {
                  await Navigator.of(context, rootNavigator: true).pushNamed(
                    DisputePage.routeName,
                    arguments: widget.body.notification.data.disputeId,
                  );
                }
              },
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
