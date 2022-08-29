import 'dart:async';

import 'package:app/constants.dart';
import 'package:app/enums.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/quests_models/assigned_worker.dart';
import 'package:app/model/quests_models/open_dispute.dart';
import 'package:app/model/quests_models/your_review.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/chat_page/store/chat_store.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/profile_details/pages/user_profile_page/user_profile_page.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/my_disputes/pages/dispute_page/dispute_page.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/create_quest_page/create_quest_page.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/create_review_page/create_review_page.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/open_dispute_page/open_dispute_page.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/quest_details/pages/employer/quest_employer_page/store/employer_store.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/quest_details/pages/employer/quest_employer_page/widgets/responded_list_widget.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/quest_details/pages/employer/quest_employer_page/widgets/review_card_widget.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/quest_details/pages/worker/quest_worker_page/quest_worker_page.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/quest_details/widgets/quest_details_body_widget.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/raise_views_page/raise_views_page.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/search_list_page/store/search_list_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/confirm_transaction_dialog.dart';
import 'package:app/ui/widgets/login_button.dart';
import 'package:app/ui/widgets/quest_header.dart';
import 'package:app/ui/widgets/user_avatar.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/quest_util.dart';
import 'package:app/web3/contractEnums.dart';
import 'package:app/web3/repository/wallet_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';
import 'package:share/share.dart';

class QuestEmployerPage extends StatefulWidget {
  final QuestArguments arguments;

  static const String routeName = "/QuestEmployer";

  const QuestEmployerPage(this.arguments);

  @override
  _QuestEmployerPageState createState() => _QuestEmployerPageState();
}

class _QuestEmployerPageState extends State<QuestEmployerPage> with SingleTickerProviderStateMixin {
  late EmployerStore store;
  late MyQuestStore myQuestStore;
  late ChatStore chatStore;
  late SearchListStore questStore;
  AnimationController? controller;

  String get myId => context.read<ProfileMeStore>().userData!.id;

  bool get isTotpActive => context.read<ProfileMeStore>().userData?.isTotpActive == true;

  bool get isMyQuest => store.quest.value != null && store.quest.value?.userId == myId;

  bool get canActionsQuest =>
      isMyQuest &&
      (store.quest.value?.status == QuestConstants.questCreated ||
          store.quest.value?.status == QuestConstants.questWaitWorkerOnAssign);

  bool get canRaiseView =>
      (store.quest.value?.status == QuestConstants.questCreated ||
          store.quest.value?.status == QuestConstants.questWaitWorkerOnAssign) &&
      store.quest.value?.raiseView?.status != 0;

  bool get canEditOrDelete =>
      store.quest.value?.status == QuestConstants.questCreated ||
      store.quest.value?.status == QuestConstants.questWaitWorkerOnAssign;

  bool get canCreateReview =>
      store.quest.value?.status == QuestConstants.questDone &&
      store.quest.value?.yourReview == null &&
      (store.quest.value?.userId == myId || store.quest.value?.assignedWorker?.id == myId);

  bool get showReview =>
      store.quest.value?.status == QuestConstants.questDone &&
      store.quest.value?.yourReview != null &&
      (store.quest.value?.userId == myId || store.quest.value?.assignedWorker?.id == myId);

  bool get canPushToDispute =>
      store.quest.value?.userId == myId &&
      store.quest.value?.status == QuestConstants.questDispute &&
      store.quest.value?.openDispute != null;

  void getResponded() {
    if (store.quest.value?.userId == myId) {
      store.getRespondedList(store.quest.value!.id);
    }
  }

  @override
  void initState() {
    store = context.read<EmployerStore>();
    myQuestStore = context.read<MyQuestStore>();
    questStore = context.read<SearchListStore>();
    chatStore = context.read<ChatStore>();

    store.getQuest(widget.arguments.id!).then((value) => getResponded());

    controller = BottomSheet.createAnimationController(this);

    controller!.duration = Duration(
      milliseconds: 500,
    );

    super.initState();
  }

  _stateListener() async {
    if (store.successData == EmployerStoreState.startQuest) {
      Navigator.of(context, rootNavigator: true).pop();
      store.quest.value!.assignedWorker = AssignedWorker(
        firstName: store.selectedResponders!.worker.firstName,
        lastName: store.selectedResponders!.worker.lastName,
        avatar: store.selectedResponders!.worker.avatar,
        id: store.selectedResponders!.id,
      );
      store.setQuestStatus(QuestConstants.questWaitWorkerOnAssign);
      await questStore.search(role: UserRole.Employer, searchLine: questStore.searchWord);
      await myQuestStore.updateListQuest();
      myQuestStore.sortQuests();
      await AlertDialogUtils.showSuccessDialog(
        context,
      );
    } else if (store.successData == EmployerStoreState.deleteQuest) {
      if (context.read<ProfileMeStore>().userData!.questsStatistic != null) {
        context.read<ProfileMeStore>().userData!.questsStatistic!.opened -= 1;
      }
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pop(context, true);
    } else if (store.successData == EmployerStoreState.validateTotpEdit) {
      await Navigator.pushNamed(
        context,
        CreateQuestPage.routeName,
        arguments: store.quest.value,
      );
    } else if (store.successData == EmployerStoreState.validateTotpDelete) {
      await store.getFee(store.quest.value?.assignedWorkerId ?? '1', WQContractFunctions.cancelJob.name);
      AlertDialogUtils.showAlertTxConfirm(
        context,
        typeTx: "quests.deleteQuest".tr(),
        addressTo: store.quest.value!.contractAddress!,
        amount: '0.0',
        fee: store.fee,
        tokenSymbol: TokenSymbols.WQT.name,
        tokenSymbolFee: TokenSymbols.WQT.name,
        onTabOk: () async {
          AlertDialogUtils.showLoadingDialog(context);
          store.deleteQuest(
            questId: store.quest.value!.id,
          );
        },
      );
    } else if (store.successData == EmployerStoreState.acceptCompletedWork) {
      store.setQuestStatus(5);
      setState(() {});
      Navigator.pop(context);
      await myQuestStore.updateListQuest();
      myQuestStore.sortQuests();
      chatStore.loadChats(starred: false);
      await AlertDialogUtils.showSuccessDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        appBar: store.quest.value == null
            ? null
            : AppBar(
                actions: [
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
                  if (canActionsQuest)
                    PopupMenuButton<String>(
                      elevation: 10,
                      icon: Icon(Icons.more_vert),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      onSelected: (value) async {
                        if (value == "Raise views") {
                          final result = await Navigator.pushNamed(
                            context,
                            RaiseViews.routeName,
                            arguments: store.quest.value!.id,
                          );
                          if (result != null && result is RaiseView) {
                            setState(() {
                              store.quest.value!.raiseView = result;
                            });
                          }
                        } else if (value == "registration.edit") {
                          if (isTotpActive) {
                            AlertDialogUtils.showSecurityTotpPDialog(
                              context,
                              onTapOk: () async {
                                store.validateTotp(isEdit: true);
                              },
                              setTotp: store.setTotp,
                            );
                          } else {
                            await AlertDialogUtils.showInfoAlertDialog(
                              context,
                              title: 'modals.error'.tr(),
                              content: "modals.errorEditQuest2FA".tr(),
                            );
                          }
                        } else if (value == "Close quest") {
                          if (isTotpActive) {
                            AlertDialogUtils.showSecurityTotpPDialog(
                              context,
                              onTapOk: () async {
                                store.validateTotp();
                              },
                              setTotp: store.setTotp,
                            );
                          } else {
                            await AlertDialogUtils.showInfoAlertDialog(
                              context,
                              title: 'modals.error'.tr(),
                              content: "modals.errorDeleteQuest2FA".tr(),
                            );
                          }
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return {
                          if (canRaiseView) 'Raise views',
                          if (canEditOrDelete) 'registration.edit',
                          if (canEditOrDelete) 'Close quest',
                        }.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice.tr()),
                          );
                        }).toList();
                      },
                    ),
                ],
              ),
        body: QuestDetailsBodyWidget(
          onRefresh: () async {
            store.getQuest(store.quest.value!.id);
          },
          quest: store.quest.value,
          questHeader: QuestHeader(
            itemType: QuestsType.All,
            questStatus: store.quest.value?.status ?? 10,
            rounded: false,
            responded: store.quest.value?.responded,
            role: UserRole.Employer,
          ),
          inProgressBy: inProgressBy(),
          bottomBody: getBodyBottom(),
          review: review(),
        ),
      ),
    );
  }

  Widget getBodyBottom() {
    if (isMyQuest) {
      return ObserverListener<EmployerStore>(
        onSuccess: _stateListener,
        onFailure: () => false,
        child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: RespondedList(
              store: store,
              profileStore: context.read<ProfileMeStore>(),
              answerOnQuestPressed: () {
                bottomForm();
              },
              chooseWorkerPressed: () async {
                await sendTransaction(
                  onPressedConfirm: () async {
                    Navigator.pop(context);
                    store.startQuest(
                      userId: store.selectedResponders!.workerId,
                      questId: store.quest.value!.id,
                    );
                    AlertDialogUtils.showLoadingDialog(context);
                  },
                  functionName: WQContractFunctions.assignJob.name,
                );
              },
            )),
      );
    }
    return SizedBox();
  }

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
                arguments: CreateReviewArguments(
                  store.quest.value!,
                  null,
                ),
              );

              if (result != null && result is YourReview) {
                print('review: ${result.toJson()}');
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
    } else if (showReview) {
      return ReviewCard(
        message: store.quest.value!.yourReview!.message,
        mark: store.quest.value!.yourReview!.mark,
      );
    } else if (canPushToDispute) {
      return LoginButton(
        enabled: store.isLoading,
        title: 'modals.openADispute'.tr(),
        onTap: () {
          Navigator.pushNamed(
            context,
            DisputePage.routeName,
            arguments: store.quest.value!.openDispute!.id,
          );
        },
      );
    }
    return SizedBox();
  }

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
            store.quest.value?.status == QuestConstants.questDone
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
                    url: store.quest.value?.assignedWorker?.avatar?.url ?? Constants.defaultImageNetwork,
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    "${store.quest.value?.assignedWorker?.firstName} "
                    "${store.quest.value?.assignedWorker?.lastName}",
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
                  Observer(
                    builder: (_) => TextButton(
                      onPressed: store.isLoading
                          ? null
                          : () async {
                              await sendTransaction(
                                onPressedConfirm: () async {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  store.acceptCompletedWork(
                                    questId: store.quest.value!.id,
                                  );
                                  AlertDialogUtils.showLoadingDialog(context);
                                },
                                functionName: WQContractFunctions.acceptJobResult.name,
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
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Theme.of(context).colorScheme.primary.withOpacity(0.5);
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
                                  "to open a dispute_page",
                                ),
                                needCancel: true,
                                titleCancel: "Cancel",
                                titleOk: "Ok",
                                onTabCancel: () => Navigator.pop(context),
                                onTabOk: () async {
                                  final _result = await Navigator.pushNamed(
                                    context,
                                    OpenDisputePage.routeName,
                                    arguments: store.quest.value!,
                                  );
                                  if (_result != null && _result is OpenDispute) {
                                    Navigator.pop(context);
                                    store.quest.value!.status = QuestConstants.questDispute;
                                    store.quest.value!.openDispute = _result;
                                    store.quest.reportChanged();
                                  }
                                },
                                colorCancel: Colors.blue,
                                colorOk: Colors.red,
                              );
                            },
                      child: Text(
                        "btn.dispute_page".tr(),
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
    required void Function()? onPressedConfirm,
    required String functionName,
  }) async {
    try {
      await _checkPossibilityTx(functionName);
    } on FormatException catch (e) {
      AlertDialogUtils.showInfoAlertDialog(context, title: 'modals.error'.tr(), content: e.message);
      return;
    } catch (e, trace) {
      print('$e\n$trace');
      AlertDialogUtils.showInfoAlertDialog(context, title: 'modals.error'.tr(), content: e.toString());
      return;
    }
    await confirmTransaction(
      context,
      fee: store.fee,
      transaction: "ui.txInfo".tr(),
      address: store.quest.value!.contractAddress!,
      amount: null,
      onPressConfirm: onPressedConfirm,
      onPressCancel: () {
        store.onError("Cancel");
        Navigator.pop(context);
      },
    );
  }

  _checkPossibilityTx(String functionName) async {
    await store.getFee(store.selectedResponders?.workerId ?? '', functionName);
  }
}
