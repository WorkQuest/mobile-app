import 'package:app/model/quests_models/Responded.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/quest_details_page/details/quest_details_page.dart';
import 'package:app/ui/pages/main_page/quest_details_page/worker/store/worker_store.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_list/store/quests_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/dismiss_keyboard.dart';
import 'package:app/ui/widgets/login_button.dart';
import 'package:app/ui/widgets/media_upload_widget.dart';
import 'package:app/utils/alert_dialog.dart';
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
  late MyQuestStore myQuestStore;
  late QuestsStore questStore;
  List<Responded?> respondedList = [];

  AnimationController? controller;

  bool isLoading = false;

  @override
  void initState() {
    store = context.read<WorkerStore>();
    myQuestStore = context.read<MyQuestStore>();
    questStore = context.read<QuestsStore>();
    profile = context.read<ProfileMeStore>();
    profile!.getProfileMe();
    store.quest.value = widget.questInfo;
    controller = BottomSheet.createAnimationController(this);
    controller!.duration = Duration(seconds: 1);
    respondedList.add(store.quest.value?.responded);
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
    return <Widget>[
      Observer(
        builder: (_) => IconButton(
          icon: Icon(
            store.quest.value!.star ? Icons.star : Icons.star_border,
            color: store.quest.value!.star ? Color(0xFFE8D20D) : Color(0xFFD8DFE3),
          ),
          onPressed: () {
            store.onStar();
            myQuestStore.deleteQuest(store.quest.value!);
            myQuestStore.addQuest(
              store.quest.value!,
              store.quest.value!.star ? true : false,
            );
            store.quest.value!.star
                ? myQuestStore.setStar(store.quest.value!, false)
                : myQuestStore.setStar(store.quest.value!, true);
          },
        ),
      ),
      if (widget.questInfo.assignedWorker?.id == profile!.userData!.id &&
          (widget.questInfo.status == 1 || widget.questInfo.status == 5))
        PopupMenuButton<String>(
          elevation: 10,
          icon: Icon(Icons.more_vert),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          onSelected: (value) async {
            AlertDialogUtils.showInfoAlertDialog(context,
                title: 'Warning'.tr(), content: 'Service temporarily unavailable');
          },
          itemBuilder: (BuildContext context) {
            return {
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

  @override
  Widget getBody() {
    if (widget.isMyQuest) return const SizedBox();
    return Observer(
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.questInfo.yourReview != null)
            Column(
              children: [
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "quests.yourReview".tr(),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${widget.questInfo.yourReview!.message}",
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    for (int i = 0; i < widget.questInfo.yourReview!.mark; i++)
                      Icon(
                        Icons.star,
                        color: Color(0xFFE8D20D),
                        size: 20.0,
                      ),
                    for (int i = 0; i < 5 - widget.questInfo.yourReview!.mark; i++)
                      Icon(
                        Icons.star,
                        color: Color(0xFFE9EDF2),
                        size: 20.0,
                      ),
                  ],
                ),
              ],
            ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  "${widget.questInfo.price} WUSD",
                  overflow: TextOverflow.fade,
                  style: const TextStyle(
                    color: Color(0xFF00AA5B),
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Observer(
            builder: (_) => !store.response &&
                    widget.questInfo.status == 0 &&
                    widget.questInfo.invited == null
                ? store.isLoading
                    ? Center(
                        child: CircularProgressIndicator.adaptive(),
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
                : SizedBox(),
          ),
          if (store.quest.value!.status == 4 &&
                  store.quest.value!.assignedWorker?.id == profile!.userData!.id ||
              (widget.questInfo.invited != null && widget.questInfo.invited?.status == 0))
            store.isLoading
                ? Center(
                    child: CircularProgressIndicator.adaptive(),
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
                            return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                          return const Color(0xFF0083C7);
                        },
                      ),
                    ),
                  ),
          if (store.quest.value!.status == 1 &&
              store.quest.value!.assignedWorker?.id == profile!.userData!.id)
            store.isLoading
                ? Center(
                    child: CircularProgressIndicator.adaptive(),
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
                            return Theme.of(context).colorScheme.primary.withOpacity(0.5);
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
        return DismissKeyboard(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 10.0,
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
        Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
          ),
          child: MediaUpload(
            store.mediaIds,
            mediaFile: store.mediaFile,
          ),
        ),
        const SizedBox(height: 21),
        Observer(
          builder: (_) => LoginButton(
            withColumn: true,
            enabled: isLoading,
            onTap: store.opinion.isNotEmpty ||
                    store.mediaFile.isNotEmpty ||
                    store.mediaIds.isNotEmpty
                ? () async {
                    if (!isLoading) {
                      _updateLoading();
                      await store.sendRespondOnQuest(store.opinion);
                      if (store.isSuccess) {
                        widget.questInfo.responded = Responded(
                          id: "",
                          workerId: profile!.userData!.id,
                          questId: widget.questInfo.id,
                          status: 0,
                          type: 0,
                          message: store.opinion,
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        );
                        for (int i = 0; i < questStore.questsList.length; i++)
                          if (questStore.questsList[i].id == widget.questInfo.id)
                            questStore.questsList[i].responded = Responded(
                              id: "",
                              workerId: profile!.userData!.id,
                              questId: widget.questInfo.id,
                              status: 0,
                              type: 0,
                              message: store.opinion,
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now(),
                            );
                        questStore.searchWord.isEmpty
                            ? questStore.getQuests(true)
                            : questStore.setSearchWord(questStore.searchWord);
                        myQuestStore.deleteQuest(widget.questInfo);
                        myQuestStore.addQuest(widget.questInfo, true);
                        _updateLoading();
                        await Future.delayed(const Duration(milliseconds: 250));
                        Navigator.pop(context);
                        Navigator.pop(context);
                        await AlertDialogUtils.showSuccessDialog(context);
                      }
                    }
                  }
                : null,
            title: "modals.sendARequest".tr(),
          ),
        ),
        const SizedBox(height: 15),
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
        LoginButton(
          withColumn: true,
          enabled: isLoading,
          onTap: () async {
            _updateLoading();
            if (widget.questInfo.invited == null) {
              await store.sendAcceptOnQuest();
              widget.questInfo.status = 1;
              myQuestStore.deleteQuest(widget.questInfo);
              myQuestStore.addQuest(widget.questInfo, true);
            } else {
              await store.acceptInvite(widget.questInfo.invited!.id);
              questStore.getQuests(true);
            }
            _updateLoading();
            await Future.delayed(const Duration(milliseconds: 250));
            Navigator.pop(context);
            Navigator.pop(context);
            await AlertDialogUtils.showSuccessDialog(context);
          },
          title: "quests.answerOnQuest.accept".tr(),
        ),
        const SizedBox(height: 15),
        LoginButton(
          withColumn: true,
          enabled: isLoading,
          onTap: () async {
            _updateLoading();
            if (widget.questInfo.invited == null) {
              await store.sendRejectOnQuest();
              if (widget.questInfo.responded != null) {
                widget.questInfo.responded?.status = -1;
              }
              widget.questInfo.status = 0;
              widget.questInfo.assignedWorker = null;
              myQuestStore.deleteQuest(widget.questInfo);
              myQuestStore.addQuest(widget.questInfo, true);
            } else {
              await store.rejectInvite(widget.questInfo.invited!.id);
              questStore.getQuests(true);
            }
            _updateLoading();
            await Future.delayed(const Duration(milliseconds: 250));
            Navigator.pop(context);
            Navigator.pop(context);
            await AlertDialogUtils.showSuccessDialog(context);
          },
          title: "quests.answerOnQuest.reject".tr(),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  _updateLoading() {
    setState(() {
      isLoading = !isLoading;
    });
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
        LoginButton(
          withColumn: true,
          enabled: store.isLoading,
          title: "quests.completeTheQuest".tr(),
          onTap: () async {
            _updateLoading();
            await store.sendCompleteWork();
            widget.questInfo.status = 5;
            await myQuestStore.deleteQuest(widget.questInfo);
            await myQuestStore.addQuest(widget.questInfo, true);
            _updateLoading();
            await Future.delayed(const Duration(milliseconds: 250));
            Navigator.pop(context);
            Navigator.pop(context);
            await AlertDialogUtils.showSuccessDialog(context);
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  @override
  void dispose() {
    widget.questInfo.update(store.quest.value!);
    super.dispose();
  }
}
