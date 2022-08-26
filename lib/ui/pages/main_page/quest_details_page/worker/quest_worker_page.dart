import 'dart:async';

import 'package:app/constants.dart';
import 'package:app/enums.dart';
import 'package:app/model/quests_models/open_dispute.dart';
import 'package:app/model/quests_models/your_review.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/chat_page/store/chat_store.dart';
import 'package:app/ui/pages/main_page/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/create_review_page/create_review_page.dart';
import 'package:app/ui/pages/main_page/quest_details_page/details/quest_details_page.dart';
import 'package:app/ui/pages/main_page/quest_details_page/dispute_page/open_dispute_page.dart';
import 'package:app/ui/pages/main_page/quest_details_page/worker/store/worker_store.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_list/store/quests_store.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/my_disputes/dispute/dispute_page.dart';
import 'package:app/ui/pages/main_page/wallet_page/confirm_transaction_dialog.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/dismiss_keyboard.dart';
import 'package:app/ui/widgets/login_button.dart';
import 'package:app/ui/widgets/media_upload/media_upload_widget.dart';
import 'package:app/ui/widgets/quest_header.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/quest_util.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:app/web3/contractEnums.dart';
import 'package:app/web3/repository/wallet_repository.dart';
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

  AnimationController? controller;

  bool get isMyQuest => (store.quest.value?.userId ?? '') == profile!.userData!.id;

  bool get canCreateReview =>
      store.quest.value?.status == QuestConstants.questDone &&
      ((store.quest.value?.userId == profile!.userData!.id ||
              store.quest.value?.assignedWorker?.id == profile!.userData!.id) &&
          store.quest.value?.yourReview == null);

  bool get showReview =>
      store.quest.value?.status == QuestConstants.questDone &&
      ((store.quest.value?.userId == profile!.userData!.id ||
              store.quest.value?.assignedWorker?.id == profile!.userData!.id) &&
          store.quest.value?.yourReview != null);

  bool get canSendRequest =>
      store.quest.value?.status == QuestConstants.questCreated &&
      store.quest.value!.responded == null;

  bool get canAnswerAnQuest =>
      (store.quest.value?.status == QuestConstants.questWaitWorkerOnAssign &&
          store.quest.value?.assignedWorker?.id == profile!.userData!.id) ||
      (store.quest.value?.responded != null &&
          store.quest.value?.status == QuestConstants.questCreated &&
          store.quest.value?.responded?.status == 0 &&
          store.quest.value!.responded?.type !=
              QuestConstants.questResponseTypeResponded);

  bool get canCompleteQuest =>
      store.quest.value?.status == QuestConstants.questWaitWorker &&
      store.quest.value?.assignedWorker?.id == profile!.userData!.id;

  bool get canCreateDispute =>
      store.quest.value?.assignedWorker?.id == profile!.userData!.id &&
      store.quest.value?.status == QuestConstants.questWaitEmployerConfirm;

  bool get canPushToDispute =>
      store.quest.value?.assignedWorker?.id == profile!.userData!.id &&
      store.quest.value?.status == QuestConstants.questDispute &&
      store.quest.value?.openDispute != null;

  @override
  void initState() {
    store = context.read<WorkerStore>();
    myQuestStore = context.read<MyQuestStore>();
    questStore = context.read<QuestsStore>();
    profile = context.read<ProfileMeStore>();
    chatStore = context.read<ChatStore>();

    store.getQuest(widget.arguments.id ?? "");

    controller = BottomSheet.createAnimationController(this);
    controller!.duration = Duration(seconds: 1);

    super.initState();
  }

  @override
  Future<dynamic> update() => store.getQuest(store.quest.value!.id);

  @override
  List<Widget>? actionAppBar() {
    return <Widget>[
      IconButton(
        icon: Icon(
          Icons.share_outlined,
          color: Color(0xFFD8DFE3),
        ),
        onPressed: () {
          late String _url;
          if (WalletRepository().notifierNetwork.value == Network.mainnet) {
            _url = "https://app.workquest.co/quests/${store.quest.value!.id}";
          } else {
            _url =
                "https://${Constants.isTestnet ? 'testnet' : 'dev'}-app.workquest.co/quests/${widget.arguments.id}";
          }
          Share.share(_url);
        },
      ),
      Observer(
        builder: (_) => IconButton(
          icon: Icon(
            store.quest.value?.star ?? false ? Icons.star : Icons.star_border,
            color:
                store.quest.value?.star ?? false ? Color(0xFFE8D20D) : Color(0xFFD8DFE3),
          ),
          onPressed: () async {
            await myQuestStore.setStar(store.quest.value!, !store.quest.value!.star);
            store.onStar();
            questStore.setStar(store.quest.value!.id, store.quest.value!.star);
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
      if (store.quest.value?.status == QuestConstants.questPending)
        IconButton(
          icon: Icon(Icons.share_outlined),
          onPressed: () {
            late String _url;
            if (WalletRepository().notifierNetwork.value == Network.mainnet) {
              _url = "https://app.workquest.co/quests/${store.quest.value!.id}";
            } else {
              _url =
                  "https://${Constants.isTestnet ? 'testnet' : 'dev'}-app.workquest.co/quests/${widget.arguments.id}";
            }
            Share.share(_url);
          },
        ),
    ];
  }

  @override
  Widget questHeader() {
    return Observer(
      builder: (_) => QuestHeader(
        itemType: QuestsType.All,
        questStatus: store.quest.value?.status ?? 0,
        rounded: false,
        role: UserRole.Worker,
        responded: store.quest.value?.responded ?? store.quest.value?.questChat?.response,
      ),
    );
  }

  @override
  Widget review() {
    if (canCreateReview) {
      return Column(
        children: [
          const SizedBox(height: 20),
          TextButton(
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                CreateReviewPage.routeName,
                arguments: CreateReviewArguments(store.quest.value, null),
              );
              if (result != null && result is YourReview) {
                store.quest.value!.yourReview = result;
                store.quest.reportChanged();
              }
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
                    return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                  return const Color(0xFF0083C7);
                },
              ),
            ),
          ),
        ],
      );
    }
    if (showReview) {
      return _ReviewCard(
        message: store.quest.value!.yourReview!.message,
        mark: store.quest.value!.yourReview!.mark,
      );
    }
    return SizedBox();
  }

  @override
  Widget getBody() {
    print('body: ${store.quest.value?.toJson()}');
    if (isMyQuest) return const SizedBox();
    final _dif = DateTime.now()
        .toUtc()
        .difference(store.quest.value?.startedAt ?? DateTime.now().toUtc())
        .inHours;
    return ObserverListener<WorkerStore>(
      onSuccess: () async {
        if (store.successData == WorkerStoreState.rejectInvite) {
          await store.getQuest(store.quest.value!.id);
          Navigator.pop(context);
          chatStore!.loadChats(starred: false);
          await Future.delayed(const Duration(milliseconds: 250));
          AlertDialogUtils.showSuccessDialog(context);
        }
        if (store.successData == WorkerStoreState.sendAcceptOnQuest) {
          Navigator.pop(context);
          await questStore.getQuests(true);
          await myQuestStore.updateListQuest();
          myQuestStore.sortQuests();
          Navigator.pop(context);
          await AlertDialogUtils.showSuccessDialog(context);
        } else if (store.successData == WorkerStoreState.acceptInvite) {
          Navigator.pop(context);
          AlertDialogUtils.showSuccessDialog(context);
        } else if (store.successData == WorkerStoreState.sendCompleteWork) {
          Navigator.pop(context);
          store.setQuestStatus(4);
          await myQuestStore.updateListQuest();
          myQuestStore.sortQuests();
          await Future.delayed(const Duration(milliseconds: 250));
          Navigator.pop(context);
          await AlertDialogUtils.showSuccessDialog(context);
        } else if (store.successData == WorkerStoreState.sendRespondOnQuest) {
          questStore.searchWord.isEmpty
              ? questStore.getQuests(true)
              : questStore.setSearchWord(questStore.searchWord);
          await myQuestStore.updateListQuest();
          myQuestStore.sortQuests();
          chatStore!.loadChats();
          await Future.delayed(const Duration(milliseconds: 250));
          Navigator.pop(context);
          await AlertDialogUtils.showSuccessDialog(context);
        }
      },
      onFailure: () => false,
      child: Observer(
        builder: (_) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "${QuestUtils.getPrice(store.quest.value?.price ?? '0')} WUSD",
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
            Observer(builder: (_) {
              if (canSendRequest) {
                if (store.isLoading) {
                  return Center(child: CircularProgressIndicator.adaptive());
                }
                return TextButton(
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
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                        return const Color(0xFF0083C7);
                      },
                    ),
                  ),
                );
              }
              return SizedBox();
            }),
            if (canAnswerAnQuest)
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
            if (canCompleteQuest)
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
            if (canCreateDispute)
              store.isLoading
                  ? Center(child: CircularProgressIndicator.adaptive())
                  : Observer(
                      builder: (_) => TextButton(
                        onPressed: store.isLoading
                            ? null
                            : _dif < 24
                                ? () {
                                    AlertDialogUtils.showInfoAlertDialog(
                                      context,
                                      title: "Error",
                                      content: "You cannot create a dispute until 24"
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
                                      onTabCancel: null,
                                      onTabOk: () async {
                                        final result = await Navigator.pushNamed(
                                          context,
                                          OpenDisputePage.routeName,
                                          arguments: store.quest.value!,
                                        );
                                        if (result != null && result is OpenDispute) {
                                          print('result: ${result.toJson()}');
                                          store.quest.value!.status =
                                              QuestConstants.questDispute;
                                          store.quest.value!.openDispute = result;
                                          store.quest.reportChanged();
                                        }
                                      },
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
            if (canPushToDispute)
              store.isLoading
                  ? Center(child: CircularProgressIndicator.adaptive())
                  : LoginButton(
                      enabled: store.isLoading,
                      title: 'modals.openADispute'.tr(),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          DisputePage.routeName,
                          arguments: store.quest.value!.openDispute!.id,
                        );
                      },
                    ),
          ],
        ),
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
          decoration: InputDecoration(hintText: "modals.hello".tr()),
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: MediaUploadWithProgress(
            store: store,
            type: MediaType.images,
          ),
        ),
        const SizedBox(height: 21),
        Observer(
          builder: (_) => LoginButton(
            withColumn: true,
            enabled: store.isLoading,
            onTap: store.opinion.isNotEmpty ||
                    store.mediaFile.isNotEmpty ||
                    store.mediaIds.isNotEmpty
                ? () async {
                    store.sendRespondOnQuest(store.opinion);
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
            onTap: store.isLoading
                ? null
                : () async {
                    print('assignedWorkerId: ${store.quest.value!.assignedWorkerId}');
                    print('id: ${profile!.userData!.id}');
                    if (store.quest.value!.assignedWorkerId == profile!.userData!.id) {
                      await sendTransaction(
                        onPress: () async {
                          Navigator.pop(context);
                          store.sendAcceptOnQuest();
                          AlertDialogUtils.showLoadingDialog(context);
                        },
                        functionName: WQContractFunctions.acceptJob.name,
                      );
                    } else {
                      store.acceptInvite(store.quest.value!.responded!.id);
                    }
                  },
            title: "quests.answerOnQuest.accept".tr(),
          ),
        ),
        const SizedBox(height: 15),
        if (store.quest.value!.responded != null &&
            store.quest.value!.responded?.status == QuestConstants.questResponseOpen &&
            store.quest.value!.assignedWorkerId != profile!.userData!.id)
          Column(
            children: [
              Observer(
                builder: (_) => LoginButton(
                  withColumn: true,
                  onTap: store.isLoading
                      ? null
                      : () async {
                          store.rejectInvite(store.quest.value!.responded!.id);
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
            title: "quests.completeTheQuest".tr(),
            onTap: store.isLoading
                ? null
                : () async {
                    await sendTransaction(
                      onPress: () async {
                        Navigator.pop(context);
                        store.sendCompleteWork();
                        AlertDialogUtils.showLoadingDialog(context);
                      },
                      functionName: WQContractFunctions.verificationJob.name,
                    );
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

class _ReviewCard extends StatelessWidget {
  final String message;
  final int mark;

  const _ReviewCard({
    Key? key,
    required this.message,
    required this.mark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            Text(message),
            const SizedBox(height: 10),
            Row(
              children: [
                for (int i = 0; i < mark; i++)
                  Icon(
                    Icons.star,
                    color: Color(0xFFE8D20D),
                    size: 20.0,
                  ),
                for (int i = 0; i < 5 - mark; i++)
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
}
