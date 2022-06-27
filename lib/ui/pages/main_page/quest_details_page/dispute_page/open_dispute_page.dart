import 'dart:async';

import 'package:app/constants.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';

import '../../../../../utils/web3_utils.dart';
import '../../wallet_page/confirm_transaction_dialog.dart';
import 'store/open_dispute_store.dart';

class OpenDisputePage extends StatefulWidget {
  static const String routeName = '/openDisputePage';

  final BaseQuestResponse quest;

  OpenDisputePage(this.quest);

  @override
  _OpenDisputePageState createState() => _OpenDisputePageState();
}

class _OpenDisputePageState extends State<OpenDisputePage> {
  late OpenDisputeStore store;

  @override
  void initState() {
    store = context.read<OpenDisputeStore>();
    super.initState();
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        automaticallyImplyLeading: true,
        middle: Text("modals.openADispute".tr()),
      ),
      persistentFooterButtons: [
        Observer(
          builder: (_) => ElevatedButton(
            onPressed: store.isButtonEnable()
                ? () async {
                    try {
                      await _checkPossibilityTx();
                    } on FormatException catch (e) {
                      AlertDialogUtils.showInfoAlertDialog(
                        context,
                        title: 'modals.error'.tr(),
                        content: e.message,
                      );
                      return;
                    } catch (e) {
                      AlertDialogUtils.showInfoAlertDialog(
                        context,
                        title: 'modals.error'.tr(),
                        content: e.toString(),
                      );
                      return;
                    }
                    await confirmTransaction(
                      context,
                      fee: store.fee,
                      transaction: "Transaction info",
                      address: widget.quest.contractAddress!,
                      amount: null,
                      onPress: () async {
                        print(
                            "widget.quest.contractAddress!: ${widget.quest.contractAddress!}");
                        store.openDispute(
                          widget.quest.id,
                          widget.quest.contractAddress!,
                        );
                        Navigator.pop(context);
                      },
                    );
                    AlertDialogUtils.showLoadingDialog(context);
                    Timer.periodic(Duration(seconds: 1), (timer) async {
                      if (!store.isLoading) {
                        timer.cancel();
                        Navigator.pop(context);
                        if (store.isSuccess) {
                          await AlertDialogUtils.showSuccessDialog(context);
                          widget.quest.status = -2;
                        }
                        setState(() {});
                        Navigator.pop(context);
                        if (!store.isSuccess)
                          await AlertDialogUtils.showInfoAlertDialog(
                            context,
                            title: "Warning",
                            content: "Dispute not created",
                          );
                      }
                    });
                  }
                : null,
            child: Text(
              "modals.openADispute".tr(),
            ),
          ),
        ),
      ],
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              16.0,
              16.0,
              16.0,
              0.0,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  titledField(
                    "modals.disputeTheme".tr(),
                    Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Color(0xFFF7F8FA),
                        borderRadius: BorderRadius.all(
                          const Radius.circular(
                            6.0,
                          ),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () => modalBottomSheet(store),
                        child: Row(
                          children: [
                            Expanded(
                              child: Observer(
                                builder: (_) => Text(
                                  store.theme.tr(),
                                  maxLines: 2,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              size: 30,
                              color: Colors.blueAccent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  titledField(
                    "modals.description".tr(),
                    Container(
                      height: 200,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Color(0xFFF7F8FA),
                        borderRadius: BorderRadius.all(
                          Radius.circular(6.0),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        maxLength: 1000,
                        textAlign: TextAlign.start,
                        onChanged: (text) => store.setDescription(text),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        textAlignVertical: TextAlignVertical.top,
                        expands: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 10),
                          hintText: "modals.description".tr(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget titledField(
    String title,
    Widget child,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          child,
        ],
      );

  modalBottomSheet(OpenDisputeStore store) => showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(
              20.0,
            ),
          ),
        ),
        context: context,
        builder: (context) {
          return DraggableScrollableSheet(
            initialChildSize: 1.0,
            expand: false,
            builder: (context, scrollController) => ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 15.0,
              ),
              separatorBuilder: (context, index) => const Divider(
                color: Colors.black12,
                endIndent: 50.0,
                indent: 50.0,
              ),
              controller: scrollController,
              shrinkWrap: false,
              itemCount: store.disputeCategoriesList.length,
              itemBuilder: (context, index) => Container(
                height: 45.0,
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    store.changeTheme(store.disputeCategoriesList[index]);
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      store.disputeCategoriesList[index].tr(),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );

  _checkPossibilityTx() async {
    await store.getFee(widget.quest.contractAddress!);
    await Web3Utils.checkPossibilityTx(
      typeCoin: TokenSymbols.WQT,
      gas: double.parse(store.fee),
      amount: 0.0,
      isMain: true,
    );
  }
}
