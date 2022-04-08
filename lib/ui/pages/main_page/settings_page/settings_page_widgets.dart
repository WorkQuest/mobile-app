import 'dart:convert';
import 'dart:typed_data';

import 'package:app/constants.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/user_profile_page.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/pages/sign_in_page/sign_in_page.dart';
import 'package:app/ui/widgets/alert_dialog.dart';
import 'package:app/ui/widgets/gradient_icon.dart';
import 'package:app/ui/widgets/web_view_page/web_view_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app/utils/storage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

///Instrument Card
class InstrumentCard extends StatelessWidget {
  final String urlArgument;
  final String iconPath;
  final String title;

  const InstrumentCard({
    required this.urlArgument,
    required this.iconPath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pushNamed(
          WebViewPage.routeName,
          arguments: urlArgument,
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

///Logout button
Widget logOutButton(context) {
  return OutlinedButton(
    onPressed: () {
      dialog(
        context,
        title: "ui.profile.logout".tr(),
        message: "modals.areYouSure".tr(),
        confirmAction: () {
          Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
            SignInPage.routeName,
            (route) => false,
          );
          final cookieManager = WebviewCookieManager();
          cookieManager.clearCookies();
          SharedPreferences.getInstance().then((sharedPrefs) {
            sharedPrefs.remove('2FAStatus');
          });
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

///Profile Image Widget
class MyProfileImage extends StatelessWidget {
  final ProfileMeStore userStore;

  const MyProfileImage(this.userStore);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pushNamed(UserProfile.routeName);
      },
      child: Container(
        height: 150.0,
        decoration: BoxDecoration(
          // color: Colors.blue,
          borderRadius: BorderRadius.circular(
            6.0,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: FadeInImage(
                width: MediaQuery.of(context).size.width,
                height: 300,
                placeholder: MemoryImage(
                  Uint8List.fromList(base64Decode(Constants.base64BlueHolder)),
                ),
                image: NetworkImage(
                  userStore.userData!.avatar?.url ?? Constants.defaultImageNetwork,
                ),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 16.0,
              left: 16.0,
              child: Container(
                width: 300,
                child: Text(
                  " ${userStore.userData?.firstName ?? " "}  ${userStore.userData?.lastName ?? " "} ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  overflow: TextOverflow.clip,
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
    );
  }
}
