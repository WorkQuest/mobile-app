import 'package:app/ui/pages/main_page/quest_page/quest_page.dart';
import 'package:app/ui/pages/main_page/settings_page/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'my_quests_page/my_quests_page.dart';

final firstTabNavKey = GlobalKey<NavigatorState>();
final secondTabNavKey = GlobalKey<NavigatorState>();
final thirdTabNavKey = GlobalKey<NavigatorState>();
final forthTabNavKey = GlobalKey<NavigatorState>();
final fiveTabNavKey = GlobalKey<NavigatorState>();

const _tabBarIconsData = [
  const _TabBarIconData('assets/search.svg', 'Quest'),
  const _TabBarIconData('assets/list.svg', 'My quests'),
  const _TabBarIconData('assets/message.svg', 'Chat'),
  const _TabBarIconData('assets/user.svg', 'Profile'),
  const _TabBarIconData('assets/settings.svg', 'Settings'),
];

class MainPage extends StatelessWidget {
  static const String routeName = '/mainPage';

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: _tabBarIconsData
            .map((item) => BottomNavigationBarItem(
                  icon: SvgPicture.asset(item.svgPath),
                  activeIcon: SvgPicture.asset(
                    item.svgPath,
                    color: CupertinoTheme.of(context).primaryColor,
                  ),
                  label: item.label,
                ))
            .toList(),
      ),
      tabBuilder: (context, index) {
        if (index == 0) {
          return CupertinoTabView(
            navigatorKey: firstTabNavKey,
            builder:  (context) {
              return QuestPage();
            }
          );
        } else if (index == 1) {
          return CupertinoTabView(
            navigatorKey: secondTabNavKey,
            builder: (context) {
              return MyQuestsPage();
            },
          );
        } else if (index == 2) {
          return CupertinoTabView(
            navigatorKey: thirdTabNavKey,
            builder: (context) {
              return MyQuestsPage();
            },
          );
        } else if (index == 3) {
          return CupertinoTabView(
            navigatorKey: forthTabNavKey,
            builder: (BuildContext context) => CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: Text("Profile"),
              ),
              child: Column(),
            ),
          );
        } else {
          return CupertinoTabView(
            navigatorKey: fiveTabNavKey,
            builder: (context) {
              return SettingsPage();
            },
          );
        }
      },
    );
  }
}

class _TabBarIconData {
  final String svgPath;
  final String label;

  const _TabBarIconData(
    this.svgPath,
    this.label,
  );
}