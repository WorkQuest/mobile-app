import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/model/respond_model.dart';
import 'package:app/ui/pages/main_page/quest_details_page/employer/store/employer_store.dart';
import 'package:app/ui/pages/main_page/quest_details_page/quest_details_page.dart';
import 'package:app/ui/pages/main_page/quest_page/create_quest_page/create_quest_page.dart';
import 'package:app/ui/pages/main_page/raise_views_page/raise_views_page.dart';
import 'package:app/ui/widgets/alert_dialog.dart';
import 'package:app/ui/widgets/success_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';
import 'package:share/share.dart';

class QuestEmployer extends QuestDetails {
  QuestEmployer(BaseQuestResponse questInfo) : super(questInfo);

  @override
  _QuestEmployerState createState() => _QuestEmployerState();
}

class _QuestEmployerState extends QuestDetailsState<QuestEmployer> {
  late EmployerStore store;

  AnimationController? controller;

  @override
  void initState() {
    store = context.read<EmployerStore>();
    store.getRespondedList(widget.questInfo.id);
    controller = BottomSheet.createAnimationController(this);
    controller!.duration = Duration(seconds: 1);
    super.initState();
  }

  @override
  List<Widget>? actionAppBar() {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.share_outlined),
        onPressed: () {
          Share.share("http://en.m.wikipedia.org");
        },
      ),
      PopupMenuButton<String>(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        onSelected: (value) {
          switch (value) {
            case "Raise views":
              Navigator.pushNamed(
                context,
                RaiseViews.routeName,
                arguments: widget.questInfo,
              );
              break;
            case "Edit":
              Navigator.pushNamed(
                context,
                CreateQuestPage.routeName,
                arguments: widget.questInfo,
              );
              break;
            case "Delete":
              dialog(
                context,
                title: "quests.deleteQuest".tr(),
                message: "quests.deleteQuestMessage".tr(),
                confirmAction: () {
                  store.deleteQuest(questId: widget.questInfo.id);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              );
              break;
            default:
          }
        },
        itemBuilder: (BuildContext context) {
          return {
            'quests.raiseViews'.tr(),
            'registration.edit'.tr(),
            'settings.delete'.tr()
          }.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList();
        },
      ),
    ];
  }

  @override
  Widget getBody() {
    return respondedList();
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
          Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
                child: Image.network(
                  widget.questInfo.assignedWorker!.additionalInfo.avatar.url,
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
        ],
      ),
    );
  }

  Widget respondedList() {
    return Observer(
      builder: (_) => (store.respondedList == null)
          ? Center(
              child: CircularProgressIndicator(),
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
              : (store.respondedList!.isNotEmpty &&
                      (widget.questInfo.status == 0 ||
                          widget.questInfo.status == 1))
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        if (store.respondedList!.isNotEmpty)
                          Text(
                            "btn.responded".tr(),
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF1D2127),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        if (store.respondedList!.isNotEmpty)
                          for (final respond in store.respondedList ?? [])
                            selectableMember(respond),
                        // const SizedBox(height: 10),
                        // const Text(
                        //   "You invited",
                        //   style: TextStyle(
                        //       fontSize: 18,
                        //       color: Color(0xFF1D2127),
                        //       fontWeight: FontWeight.w500),
                        // ),
                        // for (var i = 0; i < 3; i++)
                        //   selectableMember(
                        //     RespondModel(
                        //       createdAt: DateTime.now(),
                        //       id: "user$i",
                        //       type: 1,
                        //       status: 1,
                        //       message: "",
                        //       questId: "",
                        //       workerId: "",
                        //       worker: User(
                        //           id: "id",
                        //           firstName: "firstName $i",
                        //           lastName: "lastName $i",
                        //           avatar: Avatar.fromJson(null)),
                        //     ),
                        //   ),
                        const SizedBox(height: 15),
                        TextButton(
                          onPressed: store.selectedResponders.isEmpty
                              ? null
                              : () {
                                  store.startQuest(
                                    userId: store.selectedResponders,
                                    questId: widget.questInfo.id,
                                  );
                                  widget.questInfo.status = 4;
                                  Navigator.pop(context);
                                  successAlert(
                                    context,
                                    "quests.workerInvited".tr(),
                                  );
                                },
                          child: Text(
                            "quests.chooseWorker".tr(),
                            style: TextStyle(
                              color: store.selectedResponders.isEmpty
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
      //transitionAnimationController: controller,
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
                    onPressed: () {
                      store.acceptCompletedWork(questId: widget.questInfo.id);
                      widget.questInfo.status = 6;
                      Navigator.pop(context);
                      successAlert(
                        context,
                        "quests.answerOnQuest.questCompleted".tr(),
                      );
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
                  TextButton(
                    onPressed: () {
                      store.rejectCompletedWork(questId: widget.questInfo.id);
                      widget.questInfo.status = 4;
                      Navigator.pop(context);
                      successAlert(
                        context,
                        "quests.answerOnQuest.rejectCompletedQuest".tr(),
                      );
                    },
                    child: Text(
                      "quests.answerOnQuest.rejectCompleted".tr(),
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
                  value: respond.workerId,
                  groupValue: store.selectedResponders,
                  onChanged: (String? id) =>
                      store.selectedResponders = id ?? "",
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
          Container(
            margin: const EdgeInsets.only(top: 5),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFF6CF00),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              "levels.higher".tr(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
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
