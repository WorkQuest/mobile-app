import 'package:app/constants.dart';
import 'package:app/enums.dart';
import 'package:app/ui/pages/main_page/chat_page/store/chat_store.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_page.dart';
import 'package:app/ui/pages/main_page/settings_page/settings_page.dart';
import 'package:app/ui/pages/main_page/wallet_page/wallet_page.dart';
import 'package:app/ui/widgets/alert_dialog.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return WillPopScope(
      onWillPop: () async {
        dialog(
          context,
          title: "modals.exit".tr(),
          message: "modals.areYouSure".tr(),
          confirmAction: () =>
              SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
        );
        return true;
      },
      child: BackgroundObserverPage(
        con: context,
        child: Stack(
          children: [
            CupertinoTabScaffold(
              controller: controller,
              tabBar: CupertinoTabBar(
                items: [
                  NavBarItem(
                    svgPath: 'assets/list_alt.svg',
                    title: role == UserRole.Worker ? 'quests.quests' : "ui.workers",
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
                      stream:
                      context
                          .read<ChatStore>()
                          .streamChatNotification!
                          .stream,
                      builder: (context, snapshot) {
                        if (controller.index == 2 && snapshot.data!) {
                          return SvgPicture.asset(
                            'assets/message_mark.svg',
                            color: CupertinoTheme
                                .of(context)
                                .primaryColor,
                          );
                        } else if (controller.index == 2 && !snapshot.data!) {
                          return SvgPicture.asset(
                            'assets/message.svg',
                            color: CupertinoTheme
                                .of(context)
                                .primaryColor,
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
            ValueListenableBuilder<NetworkName?>(
              valueListenable: AccountRepository().networkName,
              builder: (_, value, child) {
                final _title = Web3Utils.getTitleOtherNetwork(value ?? NetworkName.workNetMainnet);
                if (_title == null) {
                  return const SizedBox.shrink();
                }
                return Container(
                  height: 20,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 50.0 + MediaQuery.of(context).padding.bottom),
                  color: AppColor.enabledButton,
                  alignment: Alignment.center,
                  child: Text(
                    _title,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                );
              },
            ),
          ],
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
      color: CupertinoTheme
          .of(context)
          .primaryColor,
    ),
    label: title.tr(),
  );
}
