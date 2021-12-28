import 'package:app/enums.dart';
import 'package:app/ui/pages/main_page/chat_page/store/chat_store.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_page.dart';
import 'package:app/ui/pages/main_page/settings_page/settings_page.dart';
import 'package:app/ui/pages/main_page/wallet_page/wallet_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../background_observer_page.dart';
import '../../../routes.dart';
import 'chat_page/chat_page.dart';
import 'my_quests_page/my_quests_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

final firstTabNavKey = GlobalKey<NavigatorState>();
final secondTabNavKey = GlobalKey<NavigatorState>();
final thirdTabNavKey = GlobalKey<NavigatorState>();
final forthTabNavKey = GlobalKey<NavigatorState>();
final fiveTabNavKey = GlobalKey<NavigatorState>();

final key = GlobalKey<FormState>();

class MainPage extends StatelessWidget {
  final controller = CupertinoTabController();
  static const String routeName = '/mainPage';

  MainPage(this.role);

  final UserRole role;

  @override
  Widget build(BuildContext context) {
    context.read<ChatStore>().initialStore();
    List<_TabBarIconData> _tabBarIconsData = [
      _TabBarIconData(
        'assets/list_alt.svg',
        role == UserRole.Worker ? 'quests.quests' : "ui.workers",
      ),
      _TabBarIconData(
        'assets/list.svg',
        'quests.MyQuests',
      ),
      _TabBarIconData(
        'assets/message.svg',
        'chat.chat',
      ),
      _TabBarIconData(
        'assets/wallet_icon.svg',
        'wallet.wallet',
      ),
      _TabBarIconData(
        'assets/more.svg',
        'settings.more',
      ),
    ];

    return BackgroundObserverPage(
      con: context,
      child: CupertinoTabScaffold(
        controller: controller,
        tabBar: CupertinoTabBar(
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(_tabBarIconsData[0].svgPath),
              activeIcon: SvgPicture.asset(
                _tabBarIconsData[0].svgPath,
                color: CupertinoTheme.of(context).primaryColor,
              ),
              label: _tabBarIconsData[0].label.tr(),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(_tabBarIconsData[1].svgPath),
              activeIcon: SvgPicture.asset(
                _tabBarIconsData[1].svgPath,
                color: CupertinoTheme.of(context).primaryColor,
              ),
              label: _tabBarIconsData[1].label.tr(),
            ),
            BottomNavigationBarItem(
              icon: StreamBuilder<bool>(
                key: key,
                initialData: false,
                stream:
                    context.read<ChatStore>().streamChatNotification!.stream,
                builder: (context, snapshot) {
                  if (controller.index == 2 && snapshot.data!) {
                    return SvgPicture.asset(
                      'assets/message_mark.svg',
                      color: CupertinoTheme.of(context).primaryColor,
                    );
                  } else if (controller.index == 2 && !snapshot.data!) {
                    return SvgPicture.asset(
                      _tabBarIconsData[2].svgPath,
                      color: CupertinoTheme.of(context).primaryColor,
                    );
                  }
                  if (snapshot.data!)
                    return SvgPicture.asset('assets/message_mark.svg');
                  else
                    return SvgPicture.asset(_tabBarIconsData[2].svgPath);
                },
              ),
              label: _tabBarIconsData[2].label.tr(),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(_tabBarIconsData[3].svgPath),
              activeIcon: SvgPicture.asset(
                _tabBarIconsData[3].svgPath,
                color: CupertinoTheme.of(context).primaryColor,
              ),
              label: _tabBarIconsData[3].label.tr(),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(_tabBarIconsData[4].svgPath),
              activeIcon: SvgPicture.asset(
                _tabBarIconsData[4].svgPath,
                color: CupertinoTheme.of(context).primaryColor,
              ),
              label: _tabBarIconsData[4].label.tr(),
            ),
          ],
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
                builder: (BuildContext context) {
                  return ChatPage();
                },
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
