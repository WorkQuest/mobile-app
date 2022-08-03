import 'package:app/constants.dart';
import 'package:app/ui/pages/main_page/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/raise_views_page/store/raise_views_store.dart';
import 'package:app/ui/pages/main_page/raise_views_page/widgets/level_card.dart';
import 'package:app/ui/pages/main_page/raise_views_page/widgets/period_card.dart';
import 'package:app/ui/pages/main_page/wallet_page/confirm_transaction_dialog.dart';
import 'package:app/ui/widgets/login_button.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';

final _divider = const SizedBox(height: 15.0);

class RaiseViews extends StatefulWidget {
  RaiseViews(this.questId);

  final String questId;

  static const String routeName = "/raiseViewsPage";

  @override
  State<RaiseViews> createState() => _RaiseViewsState();
}

class _RaiseViewsState extends State<RaiseViews> {
  late RaiseViewStore raiseViewStore;

  @override
  void initState() {
    raiseViewStore = context.read<RaiseViewStore>();
    raiseViewStore.initPrice();
    raiseViewStore.setQuestId(widget.questId);
    if (raiseViewStore.questId.isNotEmpty) raiseViewStore.getQuest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        persistentFooterButtons: [
          LoginButton(
            withColumn: true,
            enabled: raiseViewStore.isLoading,
            title: "wallet.pay".tr(),
            onTap: _onPressedPay,
          )
        ],
        body: CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              trailing: widget.questId.isNotEmpty
                  ? TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("startPage.skip".tr()),
                    )
                  : const SizedBox(),
              largeTitle: Text("raising-views.raisingViews".tr()),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 15.0,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    ///Period
                    Text(
                      "raising-views.choosePeriod".tr(),
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    _divider,
                    PeriodCard(
                      period: "raising-views.forOneDay".tr(),
                      groupValue: raiseViewStore.periodGroupValue,
                      value: 1,
                      onChanged: raiseViewStore.changePeriod,
                    ),
                    _divider,
                    PeriodCard(
                      period: widget.questId.isEmpty
                          ? "raising-views.forOneWeek".tr()
                          : "raising-views.forFiveDay".tr(),
                      groupValue: raiseViewStore.periodGroupValue,
                      value: 2,
                      onChanged: raiseViewStore.changePeriod,
                    ),
                    _divider,
                    PeriodCard(
                      period: widget.questId.isEmpty
                          ? "raising-views.forOneMonth".tr()
                          : "raising-views.forOneWeek".tr(),
                      groupValue: raiseViewStore.periodGroupValue,
                      value: 3,
                      onChanged: raiseViewStore.changePeriod,
                    ),
                    const SizedBox(height: 25.0),
                    Text(
                      "raising-views.chooseLevel".tr(),
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    _divider,
                    LevelCard(
                      value: 1,
                      onChanged: raiseViewStore.changeLevel,
                      groupValue: raiseViewStore.levelGroupValue,
                      color: Color(0xFFF6CF00),
                      level: "raising-views.levels.goldPlus.title".tr(),
                      price: raiseViewStore
                          .price[raiseViewStore.periodGroupValue]![0],
                      description:
                          "raising-views.levels.goldPlus.description".tr(),
                    ),
                    _divider,
                    LevelCard(
                      value: 2,
                      groupValue: raiseViewStore.levelGroupValue,
                      onChanged: raiseViewStore.changeLevel,
                      color: Color(0xFFF6CF00),
                      level: "raising-views.levels.gold.title".tr(),
                      price: raiseViewStore
                          .price[raiseViewStore.periodGroupValue]![1],
                      description: "raising-views.levels.gold.description".tr(),
                    ),
                    _divider,
                    LevelCard(
                      value: 3,
                      onChanged: raiseViewStore.changeLevel,
                      groupValue: raiseViewStore.levelGroupValue,
                      color: Color(0xFFBBC0C7),
                      level: "raising-views.levels.silver.title".tr(),
                      price: raiseViewStore
                          .price[raiseViewStore.periodGroupValue]![2],
                      description:
                          "raising-views.levels.silver.description".tr(),
                    ),
                    _divider,
                    LevelCard(
                      value: 4,
                      groupValue: raiseViewStore.levelGroupValue,
                      onChanged: raiseViewStore.changeLevel,
                      color: Color(0xFFB79768),
                      level: "raising-views.levels.bronze.title".tr(),
                      price: raiseViewStore
                          .price[raiseViewStore.periodGroupValue]![3],
                      description:
                          "raising-views.levels.bronze.description".tr(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onPressedPay() async {
    raiseViewStore.getAmount(
      isQuest: widget.questId.isNotEmpty,
      tariff: raiseViewStore.levelGroupValue,
      period: raiseViewStore.getPeriod(
        isQuest: widget.questId.isNotEmpty,
      ),
    );
    await raiseViewStore.checkAllowance();
    if (raiseViewStore.needApprove) {
      await raiseViewStore.getFeeApprove(
          isQuestRaise: widget.questId.isNotEmpty);
      await confirmTransaction(
        context,
        fee: raiseViewStore.gas,
        transaction: "Raise view Approve",
        address: Web3Utils.getAddressWorknetWQPromotion(),
        amount: raiseViewStore.amount,
        onPressConfirm: () async {
          AlertDialogUtils.showLoadingDialog(context);
          await raiseViewStore.approve();
          raiseViewStore.setApprove(true);
          Navigator.pop(context);
          Navigator.pop(context);
        },
        onPressCancel: () {
          raiseViewStore.setApprove(false);
          Navigator.pop(context);
        },
      );
    } else
      raiseViewStore.setApprove(true);

    await raiseViewStore.getFeePromotion(widget.questId.isNotEmpty);
    if (raiseViewStore.approved && double.parse(raiseViewStore.gas) != 0.0) {
      await Web3Utils.checkPossibilityTx(
        typeCoin: TokenSymbols.WUSD,
        fee: Decimal.parse(raiseViewStore.gas),
        amount: double.parse(raiseViewStore.amount),
      );

      await confirmTransaction(
        context,
        fee: raiseViewStore.gas,
        transaction: "Raise views",
        address: Web3Utils.getAddressWorknetWQPromotion(),
        amount: raiseViewStore.amount,
        onPressConfirm: () async {
          AlertDialogUtils.showLoadingDialog(context);
          if (widget.questId.isEmpty) {
            await raiseViewStore.raiseProfile();
          } else {
            await raiseViewStore.raiseQuest(widget.questId);
          }
          Navigator.pop(context);
          Navigator.pop(context);

          if (raiseViewStore.isSuccess) {
            await context.read<MyQuestStore>().updateListQuest();
            Navigator.pop(context);
            Navigator.pop(context);
            await AlertDialogUtils.showSuccessDialog(context);
          }
        },
        onPressCancel: () {
          raiseViewStore.setApprove(false);
          Navigator.pop(context);
        },
      );
    } else
      AlertDialogUtils.showInfoAlertDialog(
        context,
        title: "Error",
        content: "Try again",
      );
  }
}
