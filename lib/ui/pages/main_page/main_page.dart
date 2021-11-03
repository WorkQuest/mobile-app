import 'package:app/enums.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_page.dart';
import 'package:app/ui/pages/main_page/settings_page/settings_page.dart';
import 'package:app/ui/pages/main_page/wallet_page/wallet_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../background_observer_page.dart';
import '../../../routes.dart';
import 'chat_page/chat_page.dart';
import 'my_quests_page/my_quests_page.dart';
import 'package:easy_localization/easy_localization.dart';

final firstTabNavKey = GlobalKey<NavigatorState>();
final secondTabNavKey = GlobalKey<NavigatorState>();
final thirdTabNavKey = GlobalKey<NavigatorState>();
final forthTabNavKey = GlobalKey<NavigatorState>();
final fiveTabNavKey = GlobalKey<NavigatorState>();

class MainPage extends StatelessWidget {
  static const String routeName = '/mainPage';

  MainPage(this.role);

  final UserRole role;

  late final List<_TabBarIconData> _tabBarIconsData = [
    _TabBarIconData(
      'assets/list_alt.svg',
      role == UserRole.Worker ? 'quests.quests'.tr() : "ui.workers".tr(),
    ),
    _TabBarIconData(
      'assets/list.svg',
      'quests.MyQuests'.tr(),
    ),
    _TabBarIconData(
      'assets/message.svg',
      'chat.chat'.tr(),
    ),
    _TabBarIconData(
      'assets/wallet_icon.svg',
      'wallet.wallet'.tr(),
    ),
    _TabBarIconData(
      'assets/more.svg',
      'settings.more'.tr(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BackgroundObserverPage(
      con: context,
      child: CupertinoTabScaffold(
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
          switch (index) {
            case 0:
              return CupertinoTabView(
                  onGenerateRoute: Routes.generateRoute,
                  navigatorKey: firstTabNavKey,
                  builder: (context) {
                    return QuestPage();
                  });
            case 1:
              return CupertinoTabView(
                onGenerateRoute: Routes.generateRoute,
                navigatorKey: secondTabNavKey,
                builder: (context) {
                  return MyQuestsPage();
                },
              );
            case 2:
              return CupertinoTabView(
                onGenerateRoute: Routes.generateRoute,
                navigatorKey: thirdTabNavKey,
                builder: (BuildContext context) => ChatPage(),
              );
            case 3:
              return CupertinoTabView(
                onGenerateRoute: Routes.generateRoute,
                navigatorKey: forthTabNavKey,
                builder: (BuildContext context) {
                  return WalletPage();
                },
              );
            default:
              return CupertinoTabView(
                onGenerateRoute: Routes.generateRoute,
                navigatorKey: fiveTabNavKey,
                builder: (context) {
                  return SettingsPage();
                },
              );
          }
        },
      ),
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
