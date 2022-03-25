import 'package:app/ui/pages/main_page/raise_views_page/payment_page.dart';
import 'package:app/ui/pages/main_page/raise_views_page/store/raise_views_store.dart';
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
    return Observer(
      builder: (_) => Scaffold(
        persistentFooterButtons: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed(PaymentPage.routeName, arguments: questId);
            },
            child: Text(
              "Go to payment",
            ),
          ),
        ],
        body: CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              trailing: questId.isNotEmpty
                  ? TextButton(
                      onPressed: () {},
                      child: Text("Skip"),
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
                    periodCard(
                      period: "For 1 day",
                      groupValue: raiseViewStore.periodGroupValue,
                      value: 1,
                      onChanged: raiseViewStore.changePeriod,
                    ),
                    _divider,
                    periodCard(
                      period: "For 5 days",
                      groupValue: raiseViewStore.periodGroupValue,
                      value: 2,
                      onChanged: raiseViewStore.changePeriod,
                    ),
                    _divider,
                    periodCard(
                      period: "For 7 days",
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

                    levelCard(
                        value: 1,
                        onChanged: raiseViewStore.changeLevel,
                        groupValue: raiseViewStore.levelGroupValue,
                        color: Color(0xFFF6CF00),
                        level: "GOLD PLUS",
                        price: raiseViewStore
                            .price[raiseViewStore.periodGroupValue]![0],
                        description:
                            "Notifications for employees who were looking for quests, "
                            "via an offer to review the quest that has "
                            "been promoted by the employer. "
                            "The employee will be invited to complete the quest in based on "
                            "the most recent search categories of the employee. "
                            "Plus the ability to choose any category and any "
                            "location to promote the quest."),
                    _divider,

                    levelCard(
                      value: 2,
                      groupValue: raiseViewStore.levelGroupValue,
                      onChanged: raiseViewStore.changeLevel,
                      color: Color(0xFFF6CF00),
                      level: "GOLD",
                      price: raiseViewStore
                          .price[raiseViewStore.periodGroupValue]![1],
                      description:
                          "Notifications for employees who were looking for quests"
                          " with a direct offer to review the promoted quest "
                          "based on the most recent search categories of the "
                          "employee. Plus the ability to choose three categories"
                          " and three locations to promote the quest.",
                    ),
                    _divider,
                    levelCard(
                      value: 3,
                      onChanged: raiseViewStore.changeLevel,
                      groupValue: raiseViewStore.levelGroupValue,
                      color: Color(0xFFBBC0C7),
                      level: "SILVER",
                      price: raiseViewStore
                          .price[raiseViewStore.periodGroupValue]![2],
                      description:
                          "Pin quest on the main page for three hours, with the "
                          "ability to choose two categories and two locations "
                          "for promotion the quest.",
                    ),
                    _divider,

                    levelCard(
                      value: 4,
                      groupValue: raiseViewStore.levelGroupValue,
                      onChanged: raiseViewStore.changeLevel,
                      color: Color(0xFFB79768),
                      level: "BRONZE",
                      price: raiseViewStore
                          .price[raiseViewStore.periodGroupValue]![3],
                      description:
                          "Pin the quest on the main page for one hour, with the "
                          "ability to choose one category and one location "
                          "to promote the quest.",
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

  Widget periodCard({
    required String period,
    required int value,
    required int groupValue,
    required void Function(int?)? onChanged,
  }) =>
      Container(
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

  Widget levelCard({
    required int value,
    required int groupValue,
    required void Function(int?)? onChanged,
    required Color color,
    required String price,
    required String level,
    required String description,
  }) =>
      Container(
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
