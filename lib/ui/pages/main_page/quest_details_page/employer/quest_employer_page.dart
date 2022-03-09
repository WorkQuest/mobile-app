import 'package:app/model/quests_models/assigned_worker.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/model/respond_model.dart';
import 'package:app/ui/pages/main_page/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/user_profile_page.dart';
import 'package:app/ui/pages/main_page/quest_details_page/dispute_page/open_dispute_page.dart';
import 'package:app/ui/pages/main_page/quest_details_page/employer/store/employer_store.dart';
import 'package:app/ui/pages/main_page/quest_details_page/quest_details_page.dart';
import 'package:app/ui/pages/main_page/quest_page/create_quest_page/create_quest_page.dart';
import 'package:app/ui/pages/main_page/raise_views_page/raise_views_page.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/alert_dialog.dart';
import 'package:app/ui/widgets/error_dialog.dart';
import 'package:app/ui/widgets/user_rating.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';
import 'package:share/share.dart';

import '../../../../../constants.dart';

class QuestEmployer extends QuestDetails {
  QuestEmployer(BaseQuestResponse questInfo) : super(questInfo);

  @override
  _QuestEmployerState createState() => _QuestEmployerState();
}

class _QuestEmployerState extends QuestDetailsState<QuestEmployer> {
  late EmployerStore store;
  late MyQuestStore questStore;
  AnimationController? controller;

  @override
  void initState() {
    store = context.read<EmployerStore>();
    questStore = context.read<MyQuestStore>();
    profile = context.read<ProfileMeStore>();
    profile!.getProfileMe().then((value) => {
          if (widget.questInfo.userId == profile!.userData!.id)
            store.getRespondedList(
                widget.questInfo.id, widget.questInfo.assignedWorker?.id ?? ""),
        });
    store.quest.value = widget.questInfo;
    controller = BottomSheet.createAnimationController(this);
    controller!.duration = Duration(
      milliseconds: 500,
    );
    super.initState();
  }

  @override
  List<Widget>? actionAppBar() {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.share_outlined),
        onPressed: () {
          Share.share("https://app.workquest.co/quests/${widget.questInfo.id}");
        },
      ),
      if (widget.questInfo.userId == profile!.userData!.id &&
          (widget.questInfo.status == 0 ||
              widget.questInfo.status == 1 ||
              widget.questInfo.status == 4 ||
              widget.questInfo.status == 5))
        PopupMenuButton<String>(
          elevation: 10,
          icon: Icon(Icons.more_vert),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          onSelected: (value) async {
            if (widget.questInfo.status == 0 || widget.questInfo.status == 4)
              switch (value) {
                case "quests.raiseViews":
                  await Navigator.pushNamed(
                    context,
                    RaiseViews.routeName,
                    arguments: widget.questInfo,
                  );
                  break;
                case "registration.edit":
                  if (profile?.userData?.isTotpActive == true) {
                    AlertDialogUtils.showAlertDialog(
                      context,
                      title: const Text("Security check"),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Google confirmation code"),
                          const SizedBox(
                            height: 15,
                          ),
                          Observer(
                            builder: (_) => TextFormField(
                              onChanged: store.setTotp,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Enter the 6-digit code from the Google Authentication app",
                          ),
                        ],
                      ),
                      needCancel: true,
                      titleCancel: "Cancel",
                      titleOk: "Send",
                      onTabCancel: null,
                      onTabOk: () async {
                        await store.validateTotp();
                        if (store.isValid) {
                          await Navigator.pushNamed(
                            context,
                            CreateQuestPage.routeName,
                            arguments: widget.questInfo,
                          );
                        } else {
                          await errorAlert(context, "Invalid TOTP");
                        }
                      },
                      colorCancel: AppColor.enabledButton,
                      colorOk: Colors.red,
                    );
                  } else {
                    errorAlert(
                        context, "You can't edit quest without connected 2FA");
                  }
                  break;
                case "settings.delete":
                  if (profile?.userData?.isTotpActive == true) {
                    AlertDialogUtils.showAlertDialog(
                      context,
                      title: const Text("Security check"),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Google confirmation code"),
                          const SizedBox(
                            height: 15,
                          ),
                          Observer(
                            builder: (_) => TextFormField(
                              onChanged: store.setTotp,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Enter the 6-digit code from the Google Authentication app",
                          ),
                        ],
                      ),
                      needCancel: true,
                      titleCancel: "Cancel",
                      titleOk: "Send",
                      onTabCancel: null,
                      onTabOk: () async {
                        await store.validateTotp();
                        if (store.isValid)
                          await dialog(
                            context,
                            title: "quests.deleteQuest".tr(),
                            message: "quests.deleteQuestMessage".tr(),
                            confirmAction: () async {
                              await store.deleteQuest(
                                  questId: widget.questInfo.id);
                              questStore.deleteQuest(widget.questInfo);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          );
                      },
                      colorCancel: AppColor.enabledButton,
                      colorOk: Colors.red,
                    );
                  } else {
                    errorAlert(context,
                        "You can't delete quest without connected 2FA");
                  }
                  break;
                default:
              }
            if ((widget.questInfo.status == 1 ||
                    widget.questInfo.status == 5) &&
                value == "chat.report")
              await Navigator.of(context, rootNavigator: true).pushNamed(
                OpenDisputePage.routeName,
                arguments: widget.questInfo,
              );
          },
          itemBuilder: (BuildContext context) {
            return {
              if (widget.questInfo.status == 0 || widget.questInfo.status == 4)
                'quests.raiseViews',
              if (widget.questInfo.status == 0 || widget.questInfo.status == 4)
                'registration.edit',
              if (widget.questInfo.status == 0 || widget.questInfo.status == 4)
                'settings.delete',
              if (widget.questInfo.status == 1 || widget.questInfo.status == 5)
                "chat.report",
            }.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice.tr()),
              );
            }).toList();
          },
        ),
    ];
  }

  Future<void> validate() {
    return AlertDialogUtils.showAlertDialog(
      context,
      title: const Text("Security check"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Google confirmation code"),
          const SizedBox(
            height: 15,
          ),
          Observer(
            builder: (_) => TextFormField(
              onChanged: store.setTotp,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            "Enter the 6-digit code from the Google Authentication app",
          ),
        ],
      ),
      needCancel: true,
      titleCancel: "Cancel",
      titleOk: "Send",
      onTabCancel: () => Navigator.pop(context),
      onTabOk: () => store.validateTotp(),
      colorCancel: AppColor.enabledButton,
      colorOk: Colors.red,
    );
  }

  @override
  Widget getBody() {
    return store.quest.value?.userId == (profile?.userData?.id ?? "myId")
        ? respondedList()
        : SizedBox();
  }

  @override
  Widget inProgressBy() {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "quests.inProgressBy".tr(),
            style: TextStyle(
              color: const Color(0xFF7C838D),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              await profile!
                  .getAssignedWorker(widget.questInfo.assignedWorker!.id);
              if (profile!.assignedWorker?.id != null) {
                await Navigator.of(context, rootNavigator: true).pushNamed(
                  UserProfile.routeName,
                  arguments: profile!.assignedWorker,
                );
                profile!.assignedWorker = null;
              }
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                  child: Image.network(
                    widget.questInfo.assignedWorker!.avatar.url,
                    width: 30,
                    height: 30,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "${widget.questInfo.assignedWorker!.firstName} " +
                      "${widget.questInfo.assignedWorker!.lastName}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget respondedList() {
    return Observer(
      builder: (_) => (store.respondedList == null)
          ? Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : widget.questInfo.status == 5
              ? TextButton(
                  onPressed: () {
                    bottomForm();
                  },
                  child: Text(
                    "quests.answerOnQuest.title".tr(),
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(
                      Size(double.maxFinite, 43),
                    ),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5);
                        return const Color(0xFF0083C7);
                      },
                    ),
                  ),
                )
              : (store.respondedList.isNotEmpty &&
                      (widget.questInfo.status == 0))
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          "btn.responded".tr(),
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF1D2127),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (store.respondedList.isNotEmpty)
                            for (final respond in store.respondedList)
                              selectableMember(respond),
                        const SizedBox(height: 15),
                        TextButton(
                          onPressed: store.selectedResponders == null
                              ? null
                              : () async {
                                  await store.startQuest(
                                    userId: store.selectedResponders!.workerId,
                                    questId: widget.questInfo.id,
                                  );
                                  widget.questInfo.assignedWorker =
                                      AssignedWorker(
                                    firstName: store
                                        .selectedResponders!.worker.firstName,
                                    lastName: store
                                        .selectedResponders!.worker.lastName,
                                    avatar:
                                        store.selectedResponders!.worker.avatar,
                                    id: store.selectedResponders!.id,
                                  );
                                  questStore.deleteQuest(widget.questInfo);
                                  questStore.addQuest(widget.questInfo, true);
                                  Navigator.pop(context);
                                  await AlertDialogUtils.showSuccessDialog(
                                      context);
                                },
                          child: Text(
                            "quests.chooseWorker".tr(),
                            style: TextStyle(
                              color: store.selectedResponders == null
                                  ? Colors.grey
                                  : Colors.white,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled))
                                  return const Color(0xFFF7F8FA);
                                if (states.contains(MaterialState.pressed))
                                  return Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.5);
                                return const Color(0xFF0083C7);
                              },
                            ),
                            fixedSize: MaterialStateProperty.all(
                              Size(double.maxFinite, 43),
                            ),
                          ),
                        )
                      ],
                    )
                  : const SizedBox(),
    );
  }

  bottomForm() {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6.0),
          topRight: Radius.circular(6.0),
        ),
      ),
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 10.0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 5.0,
                  width: 70.0,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 23),
                  Text(
                    "quests.answerOnQuest.title".tr(),
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () async {
                      store.acceptCompletedWork(questId: widget.questInfo.id);
                      widget.questInfo.status = 6;
                      questStore.deleteQuest(widget.questInfo);
                      questStore.addQuest(widget.questInfo, true);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      await AlertDialogUtils.showSuccessDialog(context);
                    },
                    child: Text(
                      "quests.answerOnQuest.acceptCompleted".tr(),
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(
                        Size(double.maxFinite, 43),
                      ),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.5);
                          return const Color(0xFF0083C7);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget selectableMember(RespondModel respond) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...respondedUser(respond),
              Spacer(),
              Transform.scale(
                scale: 1.5,
                child: Radio(
                  toggleable: true,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: respond,
                  groupValue: store.selectedResponders,
                  onChanged: (RespondModel? user) =>
                      store.selectedResponders = user,
                ),
              ),
            ],
          ),
          if (respond.message.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              respond.message,
              textAlign: TextAlign.start,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            GestureDetector(
              child: Text(
                "Show more",
                style: TextStyle(
                  color: Color(0xFF0083C7),
                ),
              ),
              onTap: () => showMore(respond),
            )
          ]
        ],
      ),
    );
  }

  List<Widget> respondedUser(RespondModel respond) {
    return [
      ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
        child: Image.network(
          respond.worker.avatar.url,
          fit: BoxFit.cover,
          height: 50,
          width: 50,
        ),
      ),
      const SizedBox(width: 15),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${respond.worker.firstName} ${respond.worker.lastName}",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (respond.worker.ratingStatistic?.status != null)
            UserRating(respond.worker.ratingStatistic!.status),
        ],
      ),
    ];
  }

  showMore(RespondModel respond) {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6.0),
          topRight: Radius.circular(6.0),
        ),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.only(
            top: 20,
            left: 16,
            right: 16,
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: respondedUser(respond),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView(
                  children: [
                    Text(
                      respond.message,
                      softWrap: true,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
