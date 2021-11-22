import 'package:app/model/quests_models/Responded.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/create_review_page/create_review_page.dart';
import 'package:app/ui/pages/main_page/quest_details_page/quest_details_page.dart';
import 'package:app/ui/pages/main_page/quest_details_page/worker/store/worker_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/priority_view.dart';
import 'package:app/ui/widgets/success_alert_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';

class QuestWorker extends QuestDetails {
  final bool isMyQuest;

  QuestWorker(
    BaseQuestResponse questInfo,
    this.isMyQuest,
  ) : super(questInfo);

  @override
  _QuestWorkerState createState() => _QuestWorkerState();
}

class _QuestWorkerState extends QuestDetailsState<QuestWorker> {
  late WorkerStore store;
  ProfileMeStore? profile;
  List<Responded?> respondedList = [];

  AnimationController? controller;

  @override
  void initState() {
    store = context.read<WorkerStore>();
    profile = context.read<ProfileMeStore>();
    store.quest.value = widget.questInfo;
    controller = BottomSheet.createAnimationController(this);
    controller!.duration = Duration(seconds: 1);
    respondedList.add(store.quest.value?.responded);
    // respondedList.map((e) => null)
    respondedList.forEach((element) {
      if (element != null) if (element.workerId == profile!.userData!.id) {
        store.response = true;
        return;
      }
    });
    super.initState();
  }

  @override
  List<Widget>? actionAppBar() {
    return [
      Observer(
        builder: (_) => IconButton(
          icon: Icon(
            store.quest.value!.star ? Icons.star : Icons.star_border,
            color:
                store.quest.value!.star ? Color(0xFFE8D20D) : Color(0xFFD8DFE3),
          ),
          onPressed: store.onStar,
        ),
      )
    ];
  }

  @override
  Widget getBody() {
    if (widget.isMyQuest) return const SizedBox();
    return Observer(
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${widget.questInfo.price} WUSD",
                textAlign: TextAlign.end,
                overflow: TextOverflow.fade,
                style: const TextStyle(
                  color: Color(0xFF00AA5B),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              PriorityView(widget.questInfo.priority),
            ],
          ),
          const SizedBox(height: 20),
          Observer(
            builder: (_) => !store.response &&
                    (widget.questInfo.status == 0 ||
                        widget.questInfo.status == 4)
                ? store.isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : TextButton(
                        onPressed: () {
                          bottomForm(
                            child: bottomRespond(),
                          );
                        },
                        child: Text(
                          "modals.sendARequest".tr(),
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(
                            Size(double.maxFinite, 43),
                          ),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
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
                : SizedBox(),
          ),
          if (store.quest.value!.status == 4)
            store.isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : TextButton(
                    onPressed: () {
                      bottomForm(
                        child: bottomAcceptReject(),
                      );
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
                  ),
          if (store.quest.value!.status == 1)
            store.isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : TextButton(
                    onPressed: () {
                      bottomForm(
                        child: bottomComplete(),
                      );
                    },
                    child: Text(
                      "quests.completeTheQuest".tr(),
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
          if (store.quest.value!.status == 6)
            store.isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        CreateReviewPage.routeName,
                        arguments: store.quest.value!.id,
                      );
                    },
                    child: Text(
                      "quests.addReview".tr(),
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
        ],
      ),
    );
  }

  bottomForm({
    required Widget child,
  }) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6.0),
          topRight: Radius.circular(6.0),
        ),
      ),
      context: context,
      backgroundColor: Colors.white,
      transitionAnimationController: controller,
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
              child,
            ],
          ),
        );
      },
    ).whenComplete(
      () => controller = BottomSheet.createAnimationController(this),
    );
  }

  bottomRespond() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 23),
            Text(
              "modals.reviewOnEmployer".tr(),
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              onChanged: store.setOpinion,
              keyboardType: TextInputType.multiline,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "modals.hello".tr(),
              ),
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 15),
            Observer(
              builder: (_) => TextButton(
                onPressed: store.opinion != ""
                    ? () {
                        store.sendRespondOnQuest(store.opinion);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        successAlert(
                          context,
                          "modals.requestSend".tr(),
                        );
                      }
                    : null,
                child: Text(
                  "modals.sendARequest".tr(),
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
            ),
            const SizedBox(height: 15),
          ],
        ),
      ],
    );
  }

  bottomAcceptReject() {
    return Column(
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
            store.sendAcceptOnQuest();
            Navigator.pop(context);
            Navigator.pop(context);
            successAlert(
              context,
              "quests.answerOnQuest.questAccepted".tr(),
            );
          },
          child: Text(
            "quests.answerOnQuest.accept".tr(),
            style: TextStyle(color: Colors.white),
          ),
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(
              Size(double.maxFinite, 43),
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed))
                  return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                return const Color(0xFF0083C7);
              },
            ),
          ),
        ),
        const SizedBox(height: 15),
        TextButton(
          onPressed: () {
            store.sendRejectOnQuest();
            Navigator.pop(context);
            Navigator.pop(context);
            successAlert(
              context,
              "quests.answerOnQuest.questRejected".tr(),
            );
          },
          child: Text(
            "quests.answerOnQuest.reject".tr(),
            style: TextStyle(color: Colors.white),
          ),
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(
              Size(double.maxFinite, 43),
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed))
                  return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                return const Color(0xFF0083C7);
              },
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  bottomComplete() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 23),
        Text(
          "quests.areYouSureTheQuestIsComplete".tr(),
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 15),
        TextButton(
          onPressed: () {
            store.sendCompleteWork();
            Navigator.pop(context);
            Navigator.pop(context);
            successAlert(
              context,
              "quests.answerOnQuest.questCompleted".tr(),
            );
          },
          child: Text(
            "quests.completeTheQuest".tr(),
            style: TextStyle(color: Colors.white),
          ),
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(
              Size(double.maxFinite, 43),
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed))
                  return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                return const Color(0xFF0083C7);
              },
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  @override
  void dispose() {
    // widget.questInfo.update(store.quest.value!);
    super.dispose();
  }
}
