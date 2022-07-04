import 'package:app/constants.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/raise_views_page/store/raise_views_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/confirm_transaction_dialog.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';

final _divider = const SizedBox(
  height: 15.0,
);

class RaiseViews extends StatelessWidget {
  RaiseViews(this.questId);

  final String questId;

  static const String routeName = "/raiseViewsPage";

  @override
  Widget build(BuildContext context) {
    final raiseViewStore = context.read<RaiseViewStore>();
    raiseViewStore.initPrice();
    raiseViewStore.setQuestId(questId);
    return ObserverListener<RaiseViewStore>(
      onSuccess: () async {
        Navigator.of(context, rootNavigator: true).pop();
        await AlertDialogUtils.showSuccessDialog(context);
        Navigator.pop(context);
      },
      onFailure: () {
        Navigator.of(context, rootNavigator: true).pop();
        return false;
      },
      child: Observer(
        builder: (_) => Scaffold(
          persistentFooterButtons: [
            ElevatedButton(
              onPressed: () => _onPressedPay(context, raiseViewStore),
              child: Text(
                "wallet.pay".tr(),
              ),
            ),
          ],
          body: CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar(
                trailing: questId.isNotEmpty
                    ? TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("startPage.skip".tr()),
                      )
                    : SizedBox(),
                largeTitle: Text(
                  "raising-views.raisingViews".tr(),
                ),
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
                      _PeriodCard(
                        period: "raising-views.forOneDay".tr(),
                        groupValue: raiseViewStore.periodGroupValue,
                        value: 1,
                        onChanged: raiseViewStore.changePeriod,
                      ),
                      _divider,
                      _PeriodCard(
                        period: questId.isEmpty ? "raising-views.forOneWeek".tr() : "raising-views.forFiveDay",
                        groupValue: raiseViewStore.periodGroupValue,
                        value: 2,
                        onChanged: raiseViewStore.changePeriod,
                      ),
                      _divider,
                      _PeriodCard(
                        period: questId.isEmpty ? "raising-views.forOneMonth".tr() : "raising-views.forOneWeek".tr(),
                        groupValue: raiseViewStore.periodGroupValue,
                        value: 3,
                        onChanged: raiseViewStore.changePeriod,
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Text(
                        "raising-views.chooseLevel".tr(),
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      _divider,
                      _LevelCard(
                        value: 1,
                        onChanged: raiseViewStore.changeLevel,
                        groupValue: raiseViewStore.levelGroupValue,
                        color: Color(0xFFF6CF00),
                        level: "raising-views.goldPlus.title".tr(),
                        price: raiseViewStore.price[raiseViewStore.periodGroupValue]![0],
                        description: "raising-views.goldPlus.description".tr(),
                      ),
                      _divider,
                      _LevelCard(
                        value: 2,
                        groupValue: raiseViewStore.levelGroupValue,
                        onChanged: raiseViewStore.changeLevel,
                        color: Color(0xFFF6CF00),
                        level: "raising-views.gold.title".tr(),
                        price: raiseViewStore.price[raiseViewStore.periodGroupValue]![1],
                        description: "raising-views.gold.description".tr(),
                      ),
                      _divider,
                      _LevelCard(
                        value: 3,
                        onChanged: raiseViewStore.changeLevel,
                        groupValue: raiseViewStore.levelGroupValue,
                        color: Color(0xFFBBC0C7),
                        level: "raising-views.silver.title".tr(),
                        price: raiseViewStore.price[raiseViewStore.periodGroupValue]![2],
                        description: "raising-views.silver.description".tr(),
                      ),
                      _divider,
                      _LevelCard(
                        value: 4,
                        groupValue: raiseViewStore.levelGroupValue,
                        onChanged: raiseViewStore.changeLevel,
                        color: Color(0xFFB79768),
                        level: "raising-views.bronze.title".tr(),
                        price: raiseViewStore.price[raiseViewStore.periodGroupValue]![3],
                        description: "raising-views.bronze.description".tr(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onPressedPay(BuildContext context, RaiseViewStore store) async {
    String _gas = await store.getFee(isQuestRaise: questId.isNotEmpty);
    final _amount = store.getAmount(
      isQuest: questId.isNotEmpty,
      tariff: store.levelGroupValue,
      period: store.getPeriod(isQuest: questId.isNotEmpty),
    );
    await Web3Utils.checkPossibilityTx(
        typeCoin: TokenSymbols.WUSD, gas: double.parse(_gas), amount: double.parse(_amount));
    confirmTransaction(
      context,
      fee: _gas,
      transaction: "ui.txInfo".tr(),
      address: Web3Utils.getAddressWorknetWQPromotion(),
      amount: _amount,
      onPress: () async {
        if (questId.isEmpty) {
          store.raiseProfile();
        } else {
          store.raiseQuest(questId);
        }
        AlertDialogUtils.showLoadingDialog(context);
        Navigator.pop(context);
      },
    );
  }
}

class _PeriodCard extends StatelessWidget {
  final String period;
  final int value;
  final int groupValue;
  final Function(int?)? onChanged;

  const _PeriodCard({
    Key? key,
    required this.period,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(6.0),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      child: RadioListTile(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        contentPadding: EdgeInsets.zero,
        title: Text(
          period,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final int value;
  final int groupValue;
  final Function(int?)? onChanged;
  final Color color;
  final String price;
  final String level;
  final String description;

  const _LevelCard({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.color,
    required this.price,
    required this.level,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(6.0),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      child: Column(
        children: [
          RadioListTile(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.0,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: color,
                  ),
                  child: Text(
                    level,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Spacer(),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(description),
          ),
          const SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }
}
