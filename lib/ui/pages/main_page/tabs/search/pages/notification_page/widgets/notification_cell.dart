import 'package:app/constants.dart';
import 'package:app/di/injector.dart';
import 'package:app/enums.dart';
import 'package:app/model/notification_model.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/change_profile_page/change_profile_page.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/profile_details/pages/user_profile_page/user_profile_page.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/2FA_page/2FA_page.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/my_disputes/pages/dispute_page/dispute_page.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/create_review_page/create_review_page.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/quest_details/pages/employer/quest_employer_page/quest_employer_page.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/quest_details/pages/worker/quest_worker_page/quest_worker_page.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/notification_page/store/notification_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/web_view_page/web_view_page.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class NotificationCell extends StatefulWidget {
  final NotificationStore store;
  final NotificationElement body;

  const NotificationCell({
    required this.store,
    required this.body,
  });

  @override
  State<NotificationCell> createState() => _NotificationCellState();
}

class _NotificationCellState extends State<NotificationCell> {
  User? get user => widget.body.notification.data.user;

  String get action => widget.body.notification.action.toLowerCase();

  String get senderName => (user?.firstName ?? "Workquest") + " " + (user?.lastName ?? "info");

  @override
  void initState() {
    // TODO need refactor get info dispute
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
                    builder: (_) => widget.store.disputes[widget.body.notification.data.disputeId ?? ""]
                                ?.currentUserDisputeReview !=
                            null
                        ? OutlinedButton(
                            onPressed: () async {
                              await Navigator.pushNamed(
                                context,
                                CreateReviewPage.routeName,
                                arguments: CreateReviewArguments(
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
                    onPressed: _onPressedDeleteNotification,
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: _onPressedToPushProfile,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        user?.avatar?.url ?? Constants.defaultImageNetwork,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        senderName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        DateFormat('dd MMM yyyy, kk:mm').format(widget.body.createdAt),
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
              onTap: () => _navigate(),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.body.notification.data.title ?? _userRating(widget.body.notification.data.status),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  if (hasNavigation())
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

  _onPressedToPushProfile() {
    if (user != null) {
      final isMy = user!.id == getIt.get<ProfileMeStore>().userData!.id;
      Navigator.of(context, rootNavigator: true).pushNamed(
        UserProfile.routeName,
        arguments: isMy ? null : ProfileArguments(role: user!.role, userId: user!.id),
      );
    }
  }

  _onPressedDeleteNotification() {
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
        widget.store.deleteNotification(widget.body.id);
      },
      colorCancel: AppColor.enabledButton,
      colorOk: Colors.red,
    );
  }

  void _navigate() async {
    if (action.contains("workquestwikipage")) {
      await Navigator.of(context, rootNavigator: true).pushNamed(
        WebViewPage.routeName,
        arguments: "https://workquest.wiki/",
      );
    } else if (action.contains("quest")) {
      await Navigator.of(context, rootNavigator: true).pushNamed(
        getIt.get<ProfileMeStore>().userData!.role == UserRole.Worker
            ? QuestWorkerPage.routeName
            : QuestEmployerPage.routeName,
        arguments: QuestArguments(
          id: widget.body.notification.data.id,
        ),
      );
    } else if (action.contains("dispute_page")) {
      await Navigator.of(context, rootNavigator: true).pushNamed(
        DisputePage.routeName,
        arguments: widget.body.notification.data.disputeId,
      );
    } else if (action.contains("updateratingstatistic")) {
      final userData = context.read<ProfileMeStore>().userData;
      await Navigator.of(context, rootNavigator: true).pushNamed(
        UserProfile.routeName,
        arguments: ProfileArguments(
          userId: userData!.id,
          role: userData.role,
        ),
      );
    } else if (action.contains("fillprofiledataonsettings")) {
      await Navigator.of(context, rootNavigator: true).pushNamed(
        ChangeProfilePage.routeName,
      );
    } else if (action.contains("enablesumsubkyc")) {
      await Navigator.of(context, rootNavigator: true).pushNamed(
        WebViewPage.routeName,
        arguments: "sumsub",
      );
    } else if (action.contains("enabledoubleauthentication")) {
      await Navigator.of(context, rootNavigator: true).pushNamed(
        TwoFAPage.routeName,
      );
    } else if (action.contains("invitefriendsreward")) {
      await Navigator.of(context, rootNavigator: true).pushNamed(
        WebViewPage.routeName,
        arguments: "referral",
      );
    }
  }

  bool hasNavigation() {
    if (action.contains("workquestwikipage")) {
      return true;
    } else if (action.contains("quest")) {
      return true;
    } else if (action.contains("dispute")) {
      return true;
    } else if (action.contains("updateratingstatistic")) {
      return true;
    } else if (action.contains("fillprofiledataonsettings")) {
      return true;
    } else if (action.contains("enablesumsubkyc")) {
      return true;
    } else if (action.contains("enabledoubleauthentication")) {
      return true;
    } else if (action.contains("invitefriendsreward")) {
      return true;
    } else {
      return false;
    }
  }

  String _userRating(int? status) {
    switch (status) {
      case 0:
        return "No status";
      case 1:
        return "Verified";
      case 2:
        return "Reliable";
      case 3:
        return "TopRanked";
    }
    return "";
  }
}
