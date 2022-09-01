import 'package:app/ui/pages/main_page/tabs/more/pages/profile_details/pages/user_profile_page/user_profile_page.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/filter_quests_page/store/filter_quests_store.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/search_list_page/store/search_list_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/pages/sign_in_page/sign_in_page.dart';
import 'package:app/ui/widgets/alert_dialog.dart';
import 'package:app/ui/widgets/gradient_icon.dart';
import 'package:app/ui/widgets/user_avatar.dart';
import 'package:app/ui/widgets/web_view_page/web_view_page.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/web3/repository/wallet_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app/utils/storage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

///Instrument Card
class InstrumentCard extends StatelessWidget {
  final String urlArgument;
  final String iconPath;
  final String title;
  final bool enable;

  const InstrumentCard({
    required this.urlArgument,
    required this.iconPath,
    required this.title,
    required this.enable,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: enable
          ? () {
              Navigator.of(context, rootNavigator: true).pushNamed(
                WebViewPage.routeName,
                arguments: urlArgument,
              );
            }
          : () {
              AlertDialogUtils.showInfoAlertDialog(
                context,
                title: title,
                content: "Coming soon, still under construction",
              );
            },
      padding: EdgeInsets.zero,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        height: 54.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            6.0,
          ),
        ),
        child: Material(
          color: Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(
            6.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 14.0,
                  left: 17.0,
                ),
                child: GradientIcon(
                  SvgPicture.asset(
                    iconPath,
                  ),
                  16.0,
                ),
              ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 19.0,
                ),
                child: Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Color(0xFFD8DFE3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///Settings Card
class SettingsCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final void Function() onTap;

  const SettingsCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 130.0,
        child: Material(
          color: Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(
            6.0,
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  icon,
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_right_sharp,
                        color: Color(0xFFD8DFE3),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        dialog(
          context,
          title: "ui.profile.logout".tr(),
          message: "modals.areYouSure".tr(),
          confirmAction: () async {
            Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
              SignInPage.routeName,
              (route) => false,
            );
            context.read<ProfileMeStore>().deletePushToken();
            context.read<SearchListStore>().clearData();
            context.read<FilterQuestsStore>().clearFilters();
            context.read<MyQuestStore>().clearData();
            final cookieManager = WebviewCookieManager();
            cookieManager.clearCookies();
            WalletRepository().clearData();
            Storage.deleteAllFromSecureStorage();
          },
        );
      },
      child: Text(
        "ui.profile.logout".tr(),
        style: TextStyle(
          color: Color(0xFFDF3333),
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          width: 1.0,
          color: Color.fromRGBO(223, 51, 51, 0.1),
        ),
      ),
    );
  }
}

///Profile Image Widget
class MyProfileImage extends StatelessWidget {
  final ProfileMeStore userStore;

  const MyProfileImage(this.userStore);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).pushNamed(
            UserProfile.routeName,
          );
        },
        child: SizedBox(
          height: 190.0,
          child: Stack(
            children: [
              Positioned.fill(child: ColoredBox(color: Colors.black)),
              Positioned.fill(
                child: UserAvatar(
                  url: userStore.userData!.avatar?.url,
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  fit: BoxFit.fitHeight,
                  loadingFitSize: false,
                ),
              ),
              Positioned(
                bottom: 16.0,
                left: 16.0,
                child: Container(
                  width: 300,
                  child: Stack(
                    children: [
                      Text(
                        " ${userStore.userData?.firstName ?? " "}  ${userStore.userData?.lastName ?? " "} ",
                        style: TextStyle(
                          fontSize: 16.0,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 1
                            ..color = Colors.black,
                        ),
                        overflow: TextOverflow.clip,
                      ),
                      Text(
                        " ${userStore.userData?.firstName ?? " "}  ${userStore.userData?.lastName ?? " "} ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        overflow: TextOverflow.clip,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 16.0,
                right: 23.0,
                child: Icon(
                  Icons.arrow_right_sharp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}