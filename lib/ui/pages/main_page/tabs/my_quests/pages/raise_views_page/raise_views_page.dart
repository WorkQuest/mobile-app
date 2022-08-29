import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/raise_views_page/store/raise_views_store.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/raise_views_page/widgets/level_card.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/raise_views_page/widgets/period_card.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/confirm_transaction_dialog.dart';
import 'package:app/ui/widgets/login_button.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/raise_view_util.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
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
  late RaiseViewStore store;

  bool get isRaiseViewProfile => widget.questId.isEmpty;

  @override
  void initState() {
    store = context.read<RaiseViewStore>();
    store.initPrice();
    store.setQuestId(widget.questId);
    if (store.questId.isNotEmpty) store.getQuest();
    super.initState();
  }

  _stateListener() async {
    if (store.successData == RaiseViewStoreState.checkAllowance) {
      Navigator.of(context, rootNavigator: true).pop();
      if (store.needApprove) {
        store.getGasApprove();
      } else {
        if (isRaiseViewProfile) {
          store.getGasRaiseViewProfile();
        } else {
          store.getGasRaiseViewQuest();
        }
      }
      AlertDialogUtils.showLoadingDialog(context);
    } else if (store.successData == RaiseViewStoreState.getGasApprove) {
      Navigator.of(context, rootNavigator: true).pop();
      _approve();
    } else if (store.successData == RaiseViewStoreState.approve) {
      Navigator.of(context, rootNavigator: true).pop();
      AlertDialogUtils.showLoadingDialog(context);
      store.checkAllowance();
    } else if (store.successData == RaiseViewStoreState.getGasRaiseViewQuest ||
        store.successData == RaiseViewStoreState.getGasRaiseViewProfile) {
      Navigator.of(context, rootNavigator: true).pop();
      _promotion();
    } else if (store.successData == RaiseViewStoreState.raiseProfile ||
        store.successData == RaiseViewStoreState.raiseQuest) {
      Navigator.of(context, rootNavigator: true).pop();
      context.read<MyQuestStore>().updateListQuest();
      final _raiseViewResult = RaiseView(
        userId: GetIt.I.get<ProfileMeStore>().userData!.id,
        status: 0,
        duration: store.period,
        type: store.levelGroupValue,
        endedAt: DateTime.now().add(Duration(days: store.period)),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      Navigator.pop(context, _raiseViewResult);
      await AlertDialogUtils.showSuccessDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ObserverListener<RaiseViewStore>(
      onSuccess: _stateListener,
      onFailure: () {
        Navigator.of(context, rootNavigator: true).pop();
        return false;
      },
      child: Observer(
        builder: (_) => Scaffold(
          persistentFooterButtons: [
            LoginButton(
              withColumn: true,
              title: "wallet.pay".tr(),
              onTap: store.isLoading ? null : _onPressedPay,
            )
          ],
          body: CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar(
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
                        groupValue: store.periodGroupValue,
                        value: 1,
                        onChanged: store.changePeriod,
                      ),
                      _divider,
                      PeriodCard(
                        period:
                            widget.questId.isEmpty ? "raising-views.forOneWeek".tr() : "raising-views.forFiveDay".tr(),
                        groupValue: store.periodGroupValue,
                        value: 2,
                        onChanged: store.changePeriod,
                      ),
                      _divider,
                      PeriodCard(
                        period:
                            widget.questId.isEmpty ? "raising-views.forOneMonth".tr() : "raising-views.forOneWeek".tr(),
                        groupValue: store.periodGroupValue,
                        value: 3,
                        onChanged: store.changePeriod,
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
                        value: 0,
                        onChanged: store.changeLevel,
                        groupValue: store.levelGroupValue,
                        color: Color(0xFFF6CF00),
                        level: "raising-views.levels.goldPlus.title".tr(),
                        price: store.price[store.periodGroupValue]![0],
                        description: "raising-views.levels.goldPlus.description".tr(),
                      ),
                      _divider,
                      LevelCard(
                        value: 1,
                        groupValue: store.levelGroupValue,
                        onChanged: store.changeLevel,
                        color: Color(0xFFF6CF00),
                        level: "raising-views.levels.gold.title".tr(),
                        price: store.price[store.periodGroupValue]![1],
                        description: "raising-views.levels.gold.description".tr(),
                      ),
                      _divider,
                      LevelCard(
                        value: 2,
                        onChanged: store.changeLevel,
                        groupValue: store.levelGroupValue,
                        color: Color(0xFFBBC0C7),
                        level: "raising-views.levels.silver.title".tr(),
                        price: store.price[store.periodGroupValue]![2],
                        description: "raising-views.levels.silver.description".tr(),
                      ),
                      _divider,
                      LevelCard(
                        value: 3,
                        groupValue: store.levelGroupValue,
                        onChanged: store.changeLevel,
                        color: Color(0xFFB79768),
                        level: "raising-views.levels.bronze.title".tr(),
                        price: store.price[store.periodGroupValue]![3],
                        description: "raising-views.levels.bronze.description".tr(),
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

  _onPressedPay() {
    store.setAmount(
      isQuest: widget.questId.isNotEmpty,
      tariff: store.levelGroupValue,
      period: RaiseViewUtils.getPeriod(
        periodGroupValue: store.periodGroupValue,
        isQuest: widget.questId.isNotEmpty,
      ),
    );
    AlertDialogUtils.showLoadingDialog(context);
    store.checkAllowance();
  }

  _approve() {
    confirmTransaction(
      context,
      fee: store.gas,
      transaction: "Raise view Approve",
      address: Web3Utils.getAddressWorknetWQPromotion(),
      amount: store.amount,
      onPressConfirm: () async {
        Navigator.pop(context);
        AlertDialogUtils.showLoadingDialog(context);
        store.approve();
      },
      onPressCancel: () {
        Navigator.pop(context);
      },
    );
  }

  _promotion() async {
    confirmTransaction(
      context,
      fee: store.gas,
      transaction: "Raise views",
      address: Web3Utils.getAddressWorknetWQPromotion(),
      amount: store.amount,
      onPressConfirm: () {
        Navigator.pop(context);
        AlertDialogUtils.showLoadingDialog(context);
        if (widget.questId.isEmpty) {
          store.raiseProfile();
        } else {
          store.raiseQuest(widget.questId);
        }
      },
      onPressCancel: () {
        Navigator.pop(context);
      },
    );
  }
}
