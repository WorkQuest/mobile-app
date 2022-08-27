import 'package:app/background_observer_page.dart';
import 'package:app/enums.dart';
import 'package:app/routes.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/my_quests_page/my_quests_page.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/filter_quests_page/store/filter_quests_store.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/search_page/search_page.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/settings_page/settings_page.dart';
import 'package:app/ui/pages/main_page/tabs/wallet/pages/wallet_page/store/wallet_store.dart';
import 'package:app/ui/pages/main_page/tabs/wallet/pages/wallet_page/wallet_page.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'tabs/chat/pages/chat_page/chat_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import 'tabs/chat/pages/chat_page/store/chat_store.dart';

final firstTabNavKey = GlobalKey<NavigatorState>();
final secondTabNavKey = GlobalKey<NavigatorState>();
final thirdTabNavKey = GlobalKey<NavigatorState>();
final forthTabNavKey = GlobalKey<NavigatorState>();
final fiveTabNavKey = GlobalKey<NavigatorState>();

final key = GlobalKey<FormState>();

class MainPage extends StatefulWidget {
  static const String routeName = '/mainPage';

  MainPage(this.role);

  final UserRole role;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final controller = CupertinoTabController();

  @override
  void initState() {
    context.read<ChatStore>().initialStore();
    context.read<FilterQuestsStore>()..getFilters([], {});
    context.read<WalletStore>().getCoins();
    context.read<ProfileMeStore>().getProfileMe().then((value) {
      context.read<ChatStore>().initialSetup(context.read<ProfileMeStore>().userData!.id);
      context.read<MyQuestStore>().setRole(context.read<ProfileMeStore>().userData!.role);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        dialog(
          context,
          title: "modals.exit".tr(),
          message: "modals.areYouSure".tr(),
          confirmAction: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
        );
        return true;
      },
      child: BackgroundObserverPage(
        con: context,
        child: CupertinoTabScaffold(
          controller: controller,
          tabBar: CupertinoTabBar(
            items: [
              NavBarItem(
                svgPath: 'assets/list_alt.svg',
                title: widget.role == UserRole.Worker ? 'quests.quests' : "ui.workers",
                context: context,
              ),
              NavBarItem(
                svgPath: 'assets/list.svg',
                title: 'quests.MyQuests',
                context: context,
              ),
              BottomNavigationBarItem(
                icon: StreamBuilder<bool>(
                  key: key,
                  initialData: false,
                  stream: context.read<ChatStore>().streamChatNotification!.stream,
                  builder: (context, snapshot) {
                    if (controller.index == 2 && snapshot.data!) {
                      return SvgPicture.asset(
                        'assets/message_mark.svg',
                        color: CupertinoTheme.of(context).primaryColor,
                      );
                    } else if (controller.index == 2 && !snapshot.data!) {
                      return SvgPicture.asset(
                        'assets/message.svg',
                        color: CupertinoTheme.of(context).primaryColor,
                      );
                    }
                    if (snapshot.data!)
                      return SvgPicture.asset('assets/message_mark.svg');
                    else
                      return SvgPicture.asset('assets/message.svg');
                  },
                ),
                label: 'chat.chat'.tr(),
              ),
              NavBarItem(
                svgPath: 'assets/wallet_icon.svg',
                title: 'wallet.wallet',
                context: context,
              ),
              NavBarItem(
                svgPath: 'assets/more.svg',
                title: 'settings.more',
                context: context,
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
                      return SearchPage();
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
      ),
    );
  }
}

class NavBarItem extends BottomNavigationBarItem {
  NavBarItem({
    required String svgPath,
    required String title,
    required BuildContext context,
  }) : super(
          icon: SvgPicture.asset(svgPath),
          activeIcon: SvgPicture.asset(
            svgPath,
            color: CupertinoTheme.of(context).primaryColor,
          ),
          label: title.tr(),
        );
}
