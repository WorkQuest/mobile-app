import 'dart:async';

import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/choose_quest/store/choose_quest_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/confirm_transaction_dialog.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ChooseQuestArguments {
  final String workerId;
  final String? workerAddress;

  ChooseQuestArguments({
    required this.workerId,
    required this.workerAddress,
  });
}

class ChooseQuestPage extends StatefulWidget {
  static const String routeName = '/chooseQuestPage';

  const ChooseQuestPage({
    required this.arguments,
  });

  final ChooseQuestArguments arguments;

  @override
  State<ChooseQuestPage> createState() => _ChooseQuestPageState();
}

class _ChooseQuestPageState extends State<ChooseQuestPage> {
  //TODO: CREATE NEW STORE
  late ChooseQuestStore store;

  @override
  void initState() {
    store = context.read<ChooseQuestStore>();
    store.getQuests(
      userId: widget.arguments.workerId,
      newList: true,
      isProfileYours: false,
    );
    if (widget.arguments.workerAddress == null)
      store.getUser(userId: widget.arguments.workerId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        buttonRow(context, store),
      ],
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_sharp,
          ),
        ),
        centerTitle: true,
        title: Text(
          "quests.quests".tr(),
          style: TextStyle(
            color: Color(0xFF1D2127),
          ),
        ),
      ),
      body: Observer(
        builder: (_) => store.quests.isEmpty && store.isLoading
            ? Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : NotificationListener<ScrollEndNotification>(
                onNotification: (scrollEnd) {
                  final metrics = scrollEnd.metrics;
                  if ((metrics.atEdge ||
                          metrics.maxScrollExtent < metrics.pixels) &&
                      !store.isLoading) {
                    store.getQuests(
                      userId: widget.arguments.workerId,
                      newList: true,
                      isProfileYours: false,
                    );
                  }
                  return true;
                },
                child: ListView.builder(
                  itemBuilder: (context, index) => Observer(
                    builder: (_) => RadioListTile<String>(
                      title: Text(
                        store.quests[index].title,
                      ),
                      value: store.quests[index].id,
                      groupValue: store.questId,
                      onChanged: (value) {
                        store.setQuest(
                          store.quests[index].id,
                          store.quests[index].contractAddress!,
                        );
                      },
                    ),
                  ),
                  itemCount: store.quests.length,
                ),
              ),
      ),
    );
  }

  Widget buttonRow(
    BuildContext context,
    ChooseQuestStore store,
  ) =>
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 45.0,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "meta.cancel".tr(),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      width: 1.0,
                      color: Color(0xFF0083C7).withOpacity(0.1),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Observer(
                builder: (_) => ElevatedButton(
                  onPressed: store.questId.isNotEmpty
                      ? () async {
                          await store.getFee();
                          await confirmTransaction(
                            context,
                            fee: store.fee,
                            transaction: "Transaction info",
                            address: store.quests
                                .firstWhere(
                                    (element) => element.id == store.questId)
                                .contractAddress!,
                            amount: null,
                            onPress: () {
                              store.startQuest(
                                userId: widget.arguments.workerId,
                                userAddress: widget.arguments.workerAddress ??
                                    store.user!.walletAddress!,
                              );
                              Navigator.pop(context);
                            },
                          );
                          AlertDialogUtils.showLoadingDialog(context);
                          Timer.periodic(Duration(seconds: 1), (timer) async {
                            if (!store.isLoading) {
                              timer.cancel();
                              Navigator.pop(context);
                              if (store.isSuccess)
                                await AlertDialogUtils.showSuccessDialog(
                                  context,
                                );
                            }
                          });
                        }
                      : null,
                  child: Text(
                    "quests.addToQuest".tr(),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}