import 'dart:async';

import 'package:app/enums.dart';
import 'package:app/model/quests_models/assigned_worker.dart';
import 'package:app/model/quests_models/open_dispute.dart';
import 'package:app/model/quests_models/your_review.dart';
import 'package:app/model/respond_model.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/chat_page/store/chat_store.dart';
import 'package:app/ui/pages/main_page/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/create_review_page/create_review_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/user_profile_page.dart';
import 'package:app/ui/pages/main_page/quest_details_page/dispute_page/open_dispute_page.dart';
import 'package:app/ui/pages/main_page/quest_details_page/employer/store/employer_store.dart';
import 'package:app/ui/pages/main_page/quest_details_page/details/quest_details_page.dart';
import 'package:app/ui/pages/main_page/quest_page/create_quest_page/create_quest_page.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_list/store/quests_store.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/my_disputes/dispute/dispute_page.dart';
import 'package:app/ui/pages/main_page/wallet_page/confirm_transaction_dialog.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/login_button.dart';
import 'package:app/ui/widgets/user_avatar.dart';
import 'package:app/ui/widgets/user_rating.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/quest_util.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:app/web3/contractEnums.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:decimal/decimal.dart';
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

  bool get isMyQuest =>
      store.quest.value != null &&
      store.quest.value!.userId == profile!.userData!.id;

  bool get canActionsQuest =>
      isMyQuest &&
      (store.quest.value!.status == QuestConstants.questCreated ||
          store.quest.value!.status == QuestConstants.questWaitWorkerOnAssign);

  bool get canRaiseView =>
      (store.quest.value!.status == QuestConstants.questCreated ||
          store.quest.value!.status ==
              QuestConstants.questWaitWorkerOnAssign) &&
      store.quest.value!.raiseView?.status != 0;

  bool get canEditOrDelete =>
      store.quest.value!.status == QuestConstants.questCreated ||
      store.quest.value!.status == QuestConstants.questWaitWorkerOnAssign;

  bool get canCreateReview =>
      storeQuest.questInfo!.status == QuestConstants.questDone &&
      (storeQuest.questInfo!.userId == profile!.userData!.id ||
          storeQuest.questInfo!.assignedWorker?.id == profile!.userData!.id);

  bool get showReview =>
      storeQuest.questInfo!.status == QuestConstants.questDone &&
      (storeQuest.questInfo!.userId == profile!.userData!.id ||
          storeQuest.questInfo!.assignedWorker?.id == profile!.userData!.id);

  bool get canPushToDispute =>
      store.quest.value?.userId == profile!.userData!.id &&
      store.quest.value?.status == QuestConstants.questDispute &&
      store.quest.value!.openDispute != null;

  void getResponded(){
    if (store.quest.value!.userId == profile!.userData!.id) {
      store.getRespondedList(
        store.quest.value!.id,
        store.quest.value!.assignedWorker?.id ?? "",
      );
    }
  }

  @override
  void initState() {
    store = context.read<EmployerStore>();
    myQuestStore = context.read<MyQuestStore>();
    questStore = context.read<QuestsStore>();
    profile = context.read<ProfileMeStore>();
    chatStore = context.read<ChatStore>();

    if (widget.arguments.questInfo != null) {
      store.quest.value = widget.arguments.questInfo;
      getResponded();
      if (store.quest.value!.status == QuestConstants.questDispute) {
        store.getQuest(widget.arguments.questInfo!.id);
      }
    } else {
      store.getQuest(widget.arguments.id!).then((value) => getResponded());
    }

    controller = BottomSheet.createAnimationController(this);

    controller!.duration = Duration(
      milliseconds: 500,
    );

    super.initState();
  }

  @override
  Future<dynamic> update() => store.getQuest(store.quest.value!.id);

  @override
  List<Widget>? actionAppBar() {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.share_outlined),
        onPressed: () {
          late String _url;
          if (AccountRepository().notifierNetwork.value == Network.mainnet) {
            _url = "https://app.workquest.co/quests/${store.quest.value!.id}";
          } else {
            _url =
                "https://${Constants.isTestnet ? 'testnet' : 'dev'}-app.workquest.co/quests/${store.quest.value!.id}";
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
            if (value == "quests.raiseViews") {
              await Navigator.pushNamed(
                context,
                RaiseViews.routeName,
                arguments: store.quest.value!.id,
              );
            } else if (value == "registration.edit") {
              if (profile?.userData?.isTotpActive == true) {
                _showSecurityTOTPDialog(onTabOk: () async {
                  store.validateTotp(isEdit: true);
                });
              } else {
                await AlertDialogUtils.showInfoAlertDialog(
                  context,
                  title: 'modals.error'.tr(),
                  content: "modals.errorEditQuest2FA".tr(),
                );
              }
            } else if (value == "settings.delete") {
              if (profile?.userData?.isTotpActive == true) {
                _showSecurityTOTPDialog(
                  onTabOk: () async {
                    store.validateTotp();
                  },
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
              if (canRaiseView) 'quests.raiseViews',
              if (canEditOrDelete) 'registration.edit',
              if (canEditOrDelete) 'settings.delete',
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
    if (isMyQuest) {
      return ObserverListener<EmployerStore>(
        onSuccess: () async {
          if (store.successData == EmployerStoreState.startQuest) {
            Navigator.of(context, rootNavigator: true).pop();
            store.quest.value!.assignedWorker = AssignedWorker(
              firstName: store.selectedResponders!.worker.firstName,
              lastName: store.selectedResponders!.worker.lastName,
              avatar: store.selectedResponders!.worker.avatar,
              id: store.selectedResponders!.id,
            );
            store.setQuestStatus(QuestConstants.questWaitWorkerOnAssign);
            await questStore.getQuests(true);
            await myQuestStore.updateListQuest();
            myQuestStore.sortQuests();
            await AlertDialogUtils.showSuccessDialog(
              context,
            );
          } else if (store.successData == EmployerStoreState.deleteQuest) {
            if (profile!.userData!.questsStatistic != null) {
              profile!.userData!.questsStatistic!.opened -= 1;
            }
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.pop(context, true);
          } else if (store.successData == EmployerStoreState.validateTotpEdit) {
            await Navigator.pushNamed(
              context,
              CreateQuestPage.routeName,
              arguments: widget.arguments.questInfo,
            );
          } else if (store.successData ==
              EmployerStoreState.validateTotpDelete) {
            await store.getFee(store.quest.value?.assignedWorkerId ?? '1',
                WQContractFunctions.cancelJob.name);
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
                  questId: widget.arguments.questInfo!.id,
                );
              },
            );
          } else if (store.successData ==
              EmployerStoreState.acceptCompletedWork) {
            store.setQuestStatus(5);
            setState(() {});
            Navigator.pop(context);
            await myQuestStore.updateListQuest();
            myQuestStore.sortQuests();
            chatStore.loadChats(starred: false);
            await AlertDialogUtils.showSuccessDialog(context);
          }
        },
        onFailure: () => false,
        child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: _RespondedList(
              store: store,
              profileStore: profile,
              answerOnQuestPressed: () {
                bottomForm();
              },
              chooseWorkerPressed: () async {
                await sendTransaction(
                  onPressedConfirm: () async {
                    Navigator.pop(context);
                    await store.startQuest(
                      userId: store.selectedResponders!.workerId,
                      questId: store.quest.value!.id,
                    );
                  },
                  functionName: WQContractFunctions.assignJob.name,
                );
              },
            )),
      );
    }
    return SizedBox();
  }

  @override
  Widget questHeader() {
    return QuestHeader(
      itemType: QuestsType.All,
      questStatus: store.quest.value?.status ?? 10,
      rounded: false,
      responded: store.quest.value!.responded,
      invited: store.quest.value!.invited,
      role: UserRole.Employer,
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
                arguments: CreateReviewArguments(
                  store.quest.value!,
                  null,
                ),
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
      );
    } else if (showReview) {
      return _ReviewCard(
        message: storeQuest.questInfo!.yourReview!.message,
        mark: storeQuest.questInfo!.yourReview!.mark,
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
            store.quest.value!.status == QuestConstants.questDone
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
                                },
                                functionName:
                                    WQContractFunctions.acceptJobResult.name,
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
                                onTabOk: () async {
                                  final _result = await Navigator.pushNamed(
                                    context,
                                    OpenDisputePage.routeName,
                                    arguments: store.quest.value!,
                                  );
                                  if (_result != null &&
                                      _result is OpenDispute) {
                                    Navigator.pop(context);
                                    store.quest.value!.status =
                                        QuestConstants.questDispute;
                                    store.quest.value!.openDispute = _result;
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
    required void Function()? onPressedConfirm,
    required String functionName,
  }) async {
    try {
      await _checkPossibilityTx(functionName);
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
      onPressConfirm: onPressedConfirm,
      onPressCancel: () {
        store.onError("Cancel");
        Navigator.pop(context);
      },
    );
    AlertDialogUtils.showLoadingDialog(context);
  }

  _checkPossibilityTx(String functionName) async {
    await store.getFee(store.selectedResponders?.workerId ?? '', functionName);
    await Web3Utils.checkPossibilityTx(
      typeCoin: TokenSymbols.WQT,
      fee: Decimal.parse(store.fee),
      amount: 0.0,
      isMain: true,
    );
  }

  _showSecurityTOTPDialog({
    required Function()? onTabOk,
  }) {
    AlertDialogUtils.showAlertDialog(
      context,
      title: Text("securityCheck.title".tr()),
      content: Builder(builder: (context) {
        var width = MediaQuery.of(context).size.width;
        return Container(
          width: width - 20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("securityCheck.confCode".tr()),
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
              const SizedBox(
                height: 15,
              ),
              Text(
                "securityCheck.enterDiginCodeGoogle".tr(),
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
}

class _RespondedList extends StatefulWidget {
  final EmployerStore store;
  final ProfileMeStore? profileStore;
  final Function()? answerOnQuestPressed;
  final Function()? chooseWorkerPressed;

  const _RespondedList({
    Key? key,
    required this.store,
    required this.profileStore,
    required this.answerOnQuestPressed,
    required this.chooseWorkerPressed,
  }) : super(key: key);

  @override
  State<_RespondedList> createState() => _RespondedListState();
}

class _RespondedListState extends State<_RespondedList> {
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      if (widget.store.respondedList.isEmpty && widget.store.isLoading) {
        return Center(
          child: CircularProgressIndicator.adaptive(),
        );
      }
      if (widget.store.quest.value!.status ==
          QuestConstants.questWaitEmployerConfirm) {
        return TextButton(
          onPressed: widget.answerOnQuestPressed,
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
        );
      } else if (widget.store.respondedList.isNotEmpty &&
          (widget.store.quest.value!.status == QuestConstants.questCreated)) {
        return Column(
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
            if (widget.store.respondedList.isNotEmpty)
              for (final respond in widget.store.respondedList)
                selectableMember(respond),
            const SizedBox(height: 15),
            Observer(
              builder: (_) => TextButton(
                onPressed: widget.store.selectedResponders == null ||
                        widget.store.isLoading
                    ? null
                    : widget.chooseWorkerPressed,
                child: Text(
                  "quests.chooseWorker".tr(),
                  style: TextStyle(
                    color: widget.store.selectedResponders == null
                        ? Colors.grey
                        : Colors.white,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
        );
      }
      return const SizedBox();
    });
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
              Expanded(
                child: respondedUser(respond),
              ),
              // Spacer(),
              Transform.scale(
                scale: 1.5,
                child: Radio(
                  toggleable: true,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: respond,
                  groupValue: widget.store.selectedResponders,
                  onChanged: (RespondModel? user) =>
                      widget.store.selectedResponders = user,
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

  Widget respondedUser(RespondModel respond) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context, rootNavigator: true).pushNamed(
          UserProfile.routeName,
          arguments: ProfileArguments(
            role: UserRole.Worker,
            userId: respond.workerId,
          ),
        );
        widget.profileStore!.assignedWorker = null;
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
              "quests.yourReview".tr(),
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
