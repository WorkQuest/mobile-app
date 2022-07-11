import 'dart:async';

import 'package:app/enums.dart';
import 'package:app/model/quests_models/assigned_worker.dart';
import 'package:app/model/respond_model.dart';
import 'package:app/ui/pages/main_page/chat_page/store/chat_store.dart';
import 'package:app/ui/pages/main_page/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/create_review_page/create_review_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/store/user_profile_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/user_profile_page.dart';
import 'package:app/ui/pages/main_page/quest_details_page/dispute_page/open_dispute_page.dart';
import 'package:app/ui/pages/main_page/quest_details_page/employer/store/employer_store.dart';
import 'package:app/ui/pages/main_page/quest_details_page/details/quest_details_page.dart';
import 'package:app/ui/pages/main_page/quest_page/create_quest_page/create_quest_page.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_list/store/quests_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/confirm_transaction_dialog.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/alert_dialog.dart';
import 'package:app/ui/widgets/user_avatar.dart';
import 'package:app/ui/widgets/user_rating.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/web3/contractEnums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';
import 'package:share/share.dart';

import '../../../../../constants.dart';
import '../../../../widgets/quest_header.dart';
import '../../raise_views_page/raise_views_page.dart';

class QuestEmployer extends QuestDetails {
  QuestEmployer(QuestArguments arguments) : super(arguments);

  @override
  _QuestEmployerState createState() => _QuestEmployerState();
}

class _QuestEmployerState extends QuestDetailsState<QuestEmployer> {
  late EmployerStore store;
  late MyQuestStore myQuestStore;
  late ChatStore chatStore;
  late QuestsStore questStore;
  AnimationController? controller;

  @override
  void initState() {
    store = context.read<EmployerStore>();
    myQuestStore = context.read<MyQuestStore>();
    questStore = context.read<QuestsStore>();
    profile = context.read<ProfileMeStore>();
    chatStore = context.read<ChatStore>();
    if (widget.arguments.questInfo != null) {
      profile!.getProfileMe().then((value) => {
            if (widget.arguments.questInfo!.userId == profile!.userData!.id)
              store.getRespondedList(
                widget.arguments.questInfo!.id,
                widget.arguments.questInfo!.assignedWorker?.id ?? "",
              ),
          });
      store.quest.value = widget.arguments.questInfo;
    } else
      store.getQuest(widget.arguments.id!);
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
          Share.share(
              "https://dev-app.workquest.co/quests/${store.quest.value!.id}");
        },
      ),
      if (store.quest.value != null &&
          store.quest.value!.userId == profile!.userData!.id &&
          (store.quest.value!.status == 1 || store.quest.value!.status == 2))
        PopupMenuButton<String>(
          elevation: 10,
          icon: Icon(Icons.more_vert),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          onSelected: (value) async {
            switch (value) {
              case "quests.raiseViews":
                await Navigator.pushNamed(
                  context,
                  RaiseViews.routeName,
                  arguments: store.quest.value!.id,
                );
                break;
              case "registration.edit":
                if (profile?.userData?.isTotpActive == true) {
                  _showSecurityTOTPDialog(onTabOk: () async {
                    await store.validateTotp();
                    if (store.isValid) {
                      await Navigator.pushNamed(
                        context,
                        CreateQuestPage.routeName,
                        arguments: widget.arguments.questInfo,
                      );
                    } else {
                      await AlertDialogUtils.showInfoAlertDialog(
                        context,
                        title: 'modals.error'.tr(),
                        content: "modals.invalid2FA".tr(),
                      );
                    }
                  });
                } else {
                  await AlertDialogUtils.showInfoAlertDialog(
                    context,
                    title: 'modals.error'.tr(),
                    content: "modals.errorEditQuest2FA".tr(),
                  );
                }
                break;
              case "settings.delete":
                if (profile?.userData?.isTotpActive == true) {
                  _showSecurityTOTPDialog(onTabOk: () async {
                    await store.validateTotp();
                    if (store.isValid)
                      await dialog(
                        context,
                        title: "quests.deleteQuest".tr(),
                        message: "quests.deleteQuestMessage".tr(),
                        confirmAction: () async {
                          await store.deleteQuest(
                            questId: widget.arguments.questInfo!.id,
                          );
                          if (profile!.userData!.questsStatistic != null)
                            profile!.userData!.questsStatistic!.opened -= 1;
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      );
                  });
                } else {
                  await AlertDialogUtils.showInfoAlertDialog(
                    context,
                    title: 'modals.error'.tr(),
                    content: "modals.errorDeleteQuest2FA".tr(),
                  );
                }
                break;
              default:
            }
          },
          itemBuilder: (BuildContext context) {
            return {
              if ((store.quest.value!.status == 1 ||
                      store.quest.value!.status == 2) &&
                  store.quest.value!.raiseView?.type == null)
                'quests.raiseViews',
              if (store.quest.value!.status == 1 ||
                  store.quest.value!.status == 2)
                'registration.edit',
              if (store.quest.value!.status == 1 ||
                  store.quest.value!.status == 2)
                'settings.delete',
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
    return store.quest.value?.userId == (profile?.userData?.id ?? "myId")
        ? Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: respondedList(),
          )
        : SizedBox();
  }

  @override
  Widget questHeader() {
    return QuestHeader(
      itemType: QuestsType.All,
      questStatus: store.quest.value!.status,
      rounded: false,
      responded: store.quest.value!.responded,
      invited: store.quest.value!.invited,
      role: UserRole.Employer,
    );
  }

  @override
  Widget review() {
    return storeQuest.questInfo!.status == 5 &&
            !profile!.review &&
            (storeQuest.questInfo!.userId == profile!.userData!.id ||
                storeQuest.questInfo!.assignedWorker?.id ==
                    profile!.userData!.id)
        ? Column(
            children: [
              const SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  await Navigator.pushNamed(
                    context,
                    CreateReviewPage.routeName,
                    arguments: ReviewArguments(
                      store.quest.value!,
                      null,
                    ),
                  );
                  store.quest.value!.yourReview != null
                      ? profile!.review = true
                      : profile!.review = false;
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
          )
        : storeQuest.questInfo!.status == 5 &&
                profile!.review &&
                (storeQuest.questInfo!.userId == profile!.userData!.id ||
                    storeQuest.questInfo!.assignedWorker?.id ==
                        profile!.userData!.id)
            ? reviewCard()
            : SizedBox();
  }

  Widget reviewCard() {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFFF7F8FA),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "quests.yourReview".tr(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(storeQuest.questInfo!.yourReview!.message),
            const SizedBox(height: 10),
            Row(
              children: [
                for (int i = 0; i < storeQuest.questInfo!.yourReview!.mark; i++)
                  Icon(
                    Icons.star,
                    color: Color(0xFFE8D20D),
                    size: 20.0,
                  ),
                for (int i = 0;
                    i < 5 - storeQuest.questInfo!.yourReview!.mark;
                    i++)
                  Icon(
                    Icons.star,
                    color: Color(0xFFE9EDF2),
                    size: 20.0,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
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
            store.quest.value!.status == 5
                ? "quests.finishedBy".tr()
                : "quests.inProgressBy".tr(),
            style: TextStyle(
              color: const Color(0xFF7C838D),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              context.read<UserProfileStore>().initRole(UserRole.Worker);
              await Navigator.of(context, rootNavigator: true).pushNamed(
                UserProfile.routeName,
                arguments: ProfileArguments(
                  role: UserRole.Worker,
                  userId: store.quest.value!.assignedWorker!.id,
                ),
              );
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                  child: UserAvatar(
                    width: 30,
                    height: 30,
                    url: store.quest.value!.assignedWorker?.avatar?.url,
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    "${store.quest.value!.assignedWorker!.firstName} "
                    "${store.quest.value!.assignedWorker!.lastName}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
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
      builder: (_) => (store.respondedList.isEmpty && store.isLoading)
          ? Center(child: CircularProgressIndicator.adaptive())
          : store.quest.value!.status == 4
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
                      (store.quest.value!.status == 1))
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
                        Observer(
                          builder: (_) => TextButton(
                            onPressed: store.selectedResponders == null ||
                                    store.isLoading
                                ? null
                                : () async {
                                    await sendTransaction(
                                      onPress: () async {
                                        Navigator.pop(context);
                                        await store.startQuest(
                                          userId: store
                                              .selectedResponders!.workerId,
                                          questId: store.quest.value!.id,
                                        );
                                      },
                                      nextStep: () async {
                                        store.quest.value!.assignedWorker =
                                            AssignedWorker(
                                          firstName: store.selectedResponders!
                                              .worker.firstName,
                                          lastName: store.selectedResponders!
                                              .worker.lastName,
                                          avatar: store.selectedResponders!
                                              .worker.avatar,
                                          id: store.selectedResponders!.id,
                                        );
                                        store.setQuestStatus(2);

                                        await questStore.getQuests(true);
                                        await myQuestStore.updateListQuest();
                                        myQuestStore.sortQuests();
                                        await AlertDialogUtils
                                            .showSuccessDialog(
                                          context,
                                        );
                                      },
                                      functionName:
                                          WQContractFunctions.assignJob.name,
                                      userId:
                                          store.selectedResponders!.workerId,
                                    );
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
                          ),
                        )
                      ],
                    )
                  : const SizedBox(),
    );
  }

  bottomForm() {
    final differentTime = DateTime.now().millisecondsSinceEpoch -
        (store.quest.value!.startedAt?.millisecondsSinceEpoch ?? 0);
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
                  Observer(
                    builder: (_) => TextButton(
                      onPressed: store.isLoading
                          ? null
                          : () async {
                              await sendTransaction(
                                onPress: () async {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  await store.acceptCompletedWork(
                                    questId: store.quest.value!.id,
                                  );
                                },
                                nextStep: () async {
                                  store.setQuestStatus(5);
                                  setState(() {});
                                  Navigator.pop(context);
                                  await myQuestStore.updateListQuest();
                                  myQuestStore.sortQuests();
                                  chatStore.loadChats(starred: false);
                                  await AlertDialogUtils.showSuccessDialog(
                                      context);
                                },
                                functionName:
                                    WQContractFunctions.acceptJobResult.name,
                                userId: store.quest.value!.assignedWorkerId!,
                              );
                            },
                      child: Text(
                        "quests.answerOnQuest.acceptWork".tr(),
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
                            return Colors.green;
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Observer(
                    builder: (_) => TextButton(
                      onPressed: store.isLoading
                          ? null
                          : differentTime < 60000
                              ? () {
                                  AlertDialogUtils.showInfoAlertDialog(
                                    context,
                                    title: "Error",
                                    content:
                                        "You cannot create a dispute until 24"
                                        " hours have passed from the start of "
                                        "this quest",
                                  );
                                }
                              : () async {
                                  await store.getFee(
                                    store.quest.value!.assignedWorkerId!,
                                    WQContractFunctions.arbitration.name,
                                  );
                                  await AlertDialogUtils.showAlertDialog(
                                    context,
                                    title: Text("Dispute payment"),
                                    content: Text(
                                      "You need to pay\n"
                                      "${double.parse(store.fee) + 1.0} WUSD\n"
                                      "to open a dispute",
                                    ),
                                    needCancel: true,
                                    titleCancel: "Cancel",
                                    titleOk: "Ok",
                                    onTabCancel: () => Navigator.pop(context),
                                    onTabOk: () async =>
                                        await Navigator.pushNamed(
                                      context,
                                      OpenDisputePage.routeName,
                                      arguments: store.quest.value!,
                                    ).then(
                                      (value) async => await store.getQuest(
                                        store.quest.value!.id,
                                      ),
                                    ),
                                    colorCancel: Colors.blue,
                                    colorOk: Colors.red,
                                  );
                                },
                      child: Text(
                        "btn.dispute".tr(),
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

  Future<void> sendTransaction({
    required void Function()? onPress,
    required void Function() nextStep,
    required String functionName,
    required String userId,
  }) async {
    try {
      await store.checkPossibilityTx(userId, functionName);
    } on FormatException catch (e) {
      AlertDialogUtils.showInfoAlertDialog(context,
          title: 'modals.error'.tr(), content: e.message);
      return;
    } catch (e) {
      AlertDialogUtils.showInfoAlertDialog(context,
          title: 'modals.error'.tr(), content: e.toString());
      return;
    }
    await confirmTransaction(
      context,
      fee: store.fee,
      transaction: "ui.txInfo".tr(),
      address: store.quest.value!.contractAddress!,
      amount: null,
      onPressConfirm: onPress,
      onPressCancel: () {
        store.onError("Cancel");
        Navigator.pop(context);
      },
    );
    AlertDialogUtils.showLoadingDialog(context);
    if (store.isLoading)
      Timer.periodic(Duration(seconds: 1), (timer) async {
        if (!store.isLoading) {
          timer.cancel();
          Navigator.pop(context);
          if (!store.isSuccess) nextStep();
          await Future.delayed(const Duration(milliseconds: 250));
          await AlertDialogUtils.showSuccessDialog(context);
        }
      });
    else
      Navigator.pop(context);
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
              Expanded(child: respondedUser(respond)),
              // Spacer(),
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

  Widget respondedUser(RespondModel respond) {
    return GestureDetector(
      onTap: () async {
        context.read<UserProfileStore>().initRole(UserRole.Worker);
        await Navigator.of(context, rootNavigator: true).pushNamed(
          UserProfile.routeName,
          arguments: ProfileArguments(
            role: UserRole.Worker,
            userId: respond.workerId,
          ),
        );
        profile!.assignedWorker = null;
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
            child: Image.network(
              respond.worker.avatar?.url ?? Constants.defaultImageNetwork,
              fit: BoxFit.cover,
              height: 50,
              width: 50,
            ),
          ),
          const SizedBox(width: 15),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${respond.worker.firstName} ${respond.worker.lastName}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (respond.worker.ratingStatistic?.status != null)
                  UserRating(
                    respond.worker.ratingStatistic!.status,
                    isWorker: true,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _showSecurityTOTPDialog({
    required Function()? onTabOk,
  }) {
    AlertDialogUtils.showAlertDialog(
      context,
      title: Text("meta.securityCheck.title".tr()),
      content: Builder(builder: (context) {
        var width = MediaQuery.of(context).size.width;
        return Container(
          width: width - 20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("meta.securityCheck.confCode".tr()),
              const SizedBox(
                height: 15,
              ),
              Observer(
                builder: (_) => TextFormField(
                  onChanged: store.setTotp,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      color: AppColor.disabledText,
                    ),
                    hintText: '123456',
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "meta.securityCheck.enterDiginCodeGoogle",
              ),
            ],
          ),
        );
      }),
      needCancel: true,
      titleCancel: "meta.cancel".tr(),
      titleOk: "meta.send".tr(),
      onTabCancel: null,
      onTabOk: onTabOk,
      colorCancel: Colors.red,
      colorOk: AppColor.enabledButton,
    );
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
              respondedUser(respond),
              const SizedBox(height: 15),
              Expanded(
                child: ListView(
                  children: [
                    Text(
                      respond.message,
                      softWrap: true,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 50),
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
