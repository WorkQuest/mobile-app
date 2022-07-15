import 'dart:async';
import 'dart:math';

import 'package:app/constants.dart';
import 'package:app/enums.dart';
import 'package:app/model/quests_models/responded.dart';
import 'package:app/ui/pages/main_page/chat_page/store/chat_store.dart';
import 'package:app/ui/pages/main_page/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/create_review_page/create_review_page.dart';
import 'package:app/ui/pages/main_page/quest_details_page/details/quest_details_page.dart';
import 'package:app/ui/pages/main_page/quest_details_page/dispute_page/open_dispute_page.dart';
import 'package:app/ui/pages/main_page/quest_details_page/worker/store/worker_store.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_list/store/quests_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/confirm_transaction_dialog.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/dismiss_keyboard.dart';
import 'package:app/ui/widgets/login_button.dart';
import 'package:app/ui/widgets/media_upload_widget.dart';
import 'package:app/ui/widgets/quest_header.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:app/web3/contractEnums.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';
import 'package:share/share.dart';

import '../../../report_page/report_page.dart';

class QuestWorker extends QuestDetails {
  QuestWorker(QuestArguments arguments) : super(arguments);

  @override
  _QuestWorkerState createState() => _QuestWorkerState();
}

class _QuestWorkerState extends QuestDetailsState<QuestWorker> {
  late WorkerStore store;
  late MyQuestStore myQuestStore;
  late QuestsStore questStore;
  ChatStore? chatStore;
  List<Responded?> respondedList = [];

  AnimationController? controller;

  bool isLoading = false;
  bool isMyQuest = false;

  @override
  void initState() {
    store = context.read<WorkerStore>();
    myQuestStore = context.read<MyQuestStore>();
    questStore = context.read<QuestsStore>();
    profile = context.read<ProfileMeStore>();
    chatStore = context.read<ChatStore>();

    profile!.getProfileMe();

    if (widget.arguments.questInfo != null)
      store.quest.value = widget.arguments.questInfo;
    else
      store.getQuest(widget.arguments.id ?? "").then(
            (value) =>
                isMyQuest = store.quest.value!.userId == profile!.userData!.id,
          );
    controller = BottomSheet.createAnimationController(this);
    controller!.duration = Duration(seconds: 1);
    respondedList.add(store.quest.value?.responded);
    respondedList.forEach((element) {
      if (element != null) if (element.workerId == profile!.userData!.id &&
          element.status != -1) {
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
            store.quest.value?.star ?? false ? Icons.star : Icons.star_border,
            color: store.quest.value?.star ?? false
                ? Color(0xFFE8D20D)
                : Color(0xFFD8DFE3),
          ),
          onPressed: () {
            store.onStar();
            store.quest.value!.star
                ? myQuestStore.setStar(store.quest.value!, false)
                : myQuestStore.setStar(store.quest.value!, true);
          },
        ),
      ),
      IconButton(
        icon: Icon(
          Icons.warning_amber_outlined,
          color: Color(0xFFD8DFE3),
        ),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pushNamed(
            ReportPage.routeName,
            arguments: ReportPageArguments(
              entityType: ReportEntityType.quest,
              entityId: store.quest.value!.id,
            ),
          );
        },
      ),
      if (store.quest.value?.status == 0)
        IconButton(
          icon: Icon(Icons.share_outlined),
          onPressed: () {
            Share.share(
                "https://dev-app.workquest.co/quests/${store.quest.value!.id}");
          },
        ),
    ];
  }

  @override
  Widget questHeader() {
    return QuestHeader(
      itemType: QuestsType.All,
      questStatus: store.quest.value!.status,
      rounded: false,
      role: UserRole.Worker,
      responded: store.quest.value!.responded ??
          store.quest.value!.questChat?.response,
      invited: store.quest.value!.invited,
    );
  }

  @override
  Widget review() {
    return store.quest.value!.status == 5 &&
            !profile!.review &&
            (store.quest.value!.userId == profile!.userData!.id ||
                store.quest.value!.assignedWorker?.id == profile!.userData!.id)
        ? Column(
            children: [
              const SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  await Navigator.pushNamed(
                    context,
                    CreateReviewPage.routeName,
                    arguments: ReviewArguments(storeQuest.questInfo, null),
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
        : store.quest.value!.status == 5 &&
                profile!.review &&
                (store.quest.value!.userId == profile!.userData!.id ||
                    store.quest.value!.assignedWorker?.id ==
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
              "Your review",
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
  Widget getBody() {
    if (isMyQuest) return const SizedBox();
    final differentTime = DateTime.now().millisecondsSinceEpoch -
        (store.quest.value!.startedAt?.millisecondsSinceEpoch ?? 0);
    return Observer(
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  "${_getPrice(store.quest.value!.price)} WUSD",
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
                    store.quest.value!.status == 1 &&
                    store.quest.value!.invited == null &&
                    store.quest.value!.responded?.status != -1
                ? store.isLoading
                    ? Center(child: CircularProgressIndicator.adaptive())
                    : TextButton(
                        onPressed: () {
                          bottomForm(child: bottomRespond());
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
          if ((store.quest.value!.status == 2 &&
                  store.quest.value!.assignedWorker?.id ==
                      profile!.userData!.id) ||
              (store.quest.value!.invited != null &&
                  store.quest.value!.status == 1 &&
                  store.quest.value!.invited?.status == 0))
            store.isLoading
                ? Center(child: CircularProgressIndicator.adaptive())
                : TextButton(
                    onPressed: () {
                      bottomForm(child: bottomAcceptReject());
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
          if (store.quest.value!.status == 3 &&
              store.quest.value!.assignedWorker?.id == profile!.userData!.id)
            store.isLoading
                ? Center(child: CircularProgressIndicator.adaptive())
                : TextButton(
                    onPressed: () {
                      bottomForm(child: bottomComplete());
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
          if (store.quest.value?.assignedWorker?.id == profile!.userData!.id &&
              store.quest.value?.status == 4)
            store.isLoading
                ? Center(child: CircularProgressIndicator.adaptive())
                : Observer(
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
                                  await AlertDialogUtils.showAlertDialog(
                                    context,
                                    title: Text("Dispute payment"),
                                    content: Text(
                                      "You need to pay to open a dispute",
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
        ],
      ),
    );
  }

  _getPrice(String value) {
    try {
      return (BigInt.parse(value).toDouble() * pow(10, -18)).toStringAsFixed(2);
    } catch (e) {
      return '0.00';
    }
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
          decoration: InputDecoration(hintText: "modals.hello".tr()),
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
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
                        questStore.searchWord.isEmpty
                            ? questStore.getQuests(true)
                            : questStore.setSearchWord(questStore.searchWord);

                        await myQuestStore.updateListQuest();
                        myQuestStore.sortQuests();
                        _updateLoading();
                        chatStore!.loadChats(starred: false);
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
        Observer(
          builder: (_) => LoginButton(
            withColumn: true,
            enabled: isLoading,
            onTap: () async {
              _updateLoading();
              if (store.quest.value!.invited == null) {
                await sendTransaction(
                  onPress: () async {
                    Navigator.pop(context);
                    await store.sendAcceptOnQuest();
                  },
                  nextStep: () async {
                    await questStore.getQuests(true);
                    await myQuestStore.updateListQuest();
                    myQuestStore.sortQuests();
                  },
                  functionName: WQContractFunctions.acceptJob.name,
                );
              } else {
                await store.acceptInvite(store.quest.value!.invited!.id);
                if (store.isSuccess) {
                  Navigator.pop(context);
                  AlertDialogUtils.showSuccessDialog(context);
                }
              }
              _updateLoading();
            },
            title: "quests.answerOnQuest.accept".tr(),
          ),
        ),
        const SizedBox(height: 15),
        if (store.quest.value!.invited != null)
          Column(
            children: [
              Observer(
                builder: (_) => LoginButton(
                  withColumn: true,
                  enabled: isLoading,
                  onTap: () async {
                    _updateLoading();
                    await store.rejectInvite(store.quest.value!.invited!.id);
                    await store.getQuest(store.quest.value!.id);
                    Navigator.pop(context);
                    chatStore!.loadChats(starred: false);
                    _updateLoading();
                    await Future.delayed(const Duration(milliseconds: 250));
                    AlertDialogUtils.showSuccessDialog(context);
                  },
                  title: "quests.answerOnQuest.reject".tr(),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
      ],
    );
  }

  Future<void> sendTransaction({
    required void Function()? onPress,
    required void Function() nextStep,
    required String functionName,
  }) async {
    try {
      await _checkPossibilityTx(functionName);
    } on FormatException catch (e) {
      AlertDialogUtils.showInfoAlertDialog(context,
          title: 'modals.error'.tr(), content: e.message);
      return;
    } catch (e, trace) {
      print('_checkPossibilityTx | $e\n$trace');
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
          if (store.isSuccess) nextStep();
          await Future.delayed(const Duration(milliseconds: 250));
          Navigator.pop(context);
          await AlertDialogUtils.showSuccessDialog(context);
        }
      });
    else
      Navigator.pop(context);
  }

  _checkPossibilityTx(String functionName) async {
    await store.getFee(functionName);
    await Web3Utils.checkPossibilityTx(
      typeCoin: TokenSymbols.WQT,
      fee: Decimal.parse(store.fee),
      amount: 0.0,
      isMain: true,
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
        Observer(
          builder: (_) => LoginButton(
            withColumn: true,
            enabled: store.isLoading,
            title: "quests.completeTheQuest".tr(),
            onTap: () async {
              _updateLoading();
              await sendTransaction(
                onPress: () async {
                  Navigator.pop(context);
                  await store.sendCompleteWork();
                },
                nextStep: () async {
                  store.setQuestStatus(4);
                  await myQuestStore.updateListQuest();
                  myQuestStore.sortQuests();
                },
                functionName: WQContractFunctions.verificationJob.name,
              );
              _updateLoading();
              // await Future.delayed(const Duration(milliseconds: 250));
              // Navigator.pop(context);
              // await AlertDialogUtils.showSuccessDialog(context);
            },
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  @override
  void dispose() {
    store.quest.value!.update(store.quest.value!);
    super.dispose();
  }
}
