import 'dart:io';

import 'package:app/di/injector.dart';
import 'package:app/enums.dart';
import 'package:app/ui/pages/main_page/profile_reviews_page/profileMe_reviews_page.dart';
import 'package:app/ui/pages/main_page/settings_page/change_password_page.dart';
import 'package:app/ui/pages/main_page/settings_page/store/settings_store.dart';
import 'package:app/ui/pages/sign_in_page/sign_in_page.dart';
import 'package:app/ui/pages/sign_in_page/store/sign_in_store.dart';
import 'package:app/ui/widgets/web_view_page/web_view_page.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/gradient_icon.dart';
import 'package:app/utils/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import "package:provider/provider.dart";

class SettingsPage extends StatelessWidget {
  static const String routeName = "/settingsPageEmployer";

  @override
  Widget build(context) {
    final settingStore = context.read<SettingsPageStore>();
    final userStore = context.read<ProfileMeStore>();

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(
              "Settings",
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  _myProfileImage(context, userStore),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ///Change Password
                            settingsCard(
                              icon: GradientIcon(
                                SvgPicture.asset(
                                  "assets/settings_password_icon.svg",
                                ),
                                20.0,
                              ),
                              title: "Change\nPassword",
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pushNamed(
                                  ChangePasswordPage.routeName,
                                );
                              },
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),

                            ///2FA
                            settingsCard(
                              icon: CupertinoSwitch(
                                onChanged: null,
                                value: false,
                              ),
                              title: "2FA",
                              onTap: () {},
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ///SMS Verification
                              settingsCard(
                                icon: CupertinoSwitch(
                                  onChanged: null,
                                  value: false,
                                ),
                                title: "SMS \nVerification",
                                onTap: () {},
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),

                              ///Change Role
                              settingsCard(
                                icon: GradientIcon(
                                  SvgPicture.asset(
                                    "assets/settings_role_icon.svg",
                                  ),
                                  20.0,
                                ),
                                title: "Change \nRole",
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _logOutButton(context),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 10.0,
              width: double.infinity,
              color: Color(0xFFF7F8FA),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  userStore.userData?.role == UserRole.Worker
                      ? workerSettings(context)
                      : employerSettings(settingStore),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget workerSettings(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(
            bottom: 16.0,
            top: 16.0,
          ),
          child: Text(
            "Instruments",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
        ),
        instrumentsCard(
          context,
          urlArgument: "pension",
          iconPath: "assets/settings_pension_icon.svg",
          title: "Retirement program",
        ),
        instrumentsCard(
          context,
          urlArgument: "referral",
          iconPath: "assets/settings_referral_icon.svg",
          title: "Referral Program",
        ),
        instrumentsCard(
          context,
          urlArgument: "insuring",
          iconPath: "assets/settings_p2p_icon.svg",
          title: "P2P insurance",
        ),
        instrumentsCard(
          context,
          urlArgument: "savings",
          iconPath: "assets/setting_saving_product_icon.svg",
          title: "Savings product",
        ),
        instrumentsCard(
          context,
          urlArgument: "crediting",
          iconPath: "assets/settings_wallet.svg",
          title: "Lending",
        ),
        instrumentsCard(
          context,
          urlArgument: "mining",
          iconPath: "assets/setting_chart.svg",
          title: "Liquidity mining",
        ),
      ],
    );
  }

  Widget employerSettings(settingStore) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            "Settings",
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
        Observer(
          builder: (_) => Material(
            color: Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(6.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Who can see my profile?",
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  RadioListTile(
                    dense: true,
                    activeColor: Colors.blueAccent,
                    value: 1,
                    onChanged: (_) => settingStore.changePrivacy(1),
                    groupValue: settingStore.privacy,
                    contentPadding: EdgeInsets.zero,
                    title: Transform.translate(
                      offset: Offset(-20.0, 0.0),
                      child: const Text(
                        "All registered users",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Color(0xFF7C838D),
                        ),
                      ),
                    ),
                  ),
                  RadioListTile(
                    dense: true,
                    activeColor: Colors.blueAccent,
                    value: 2,
                    onChanged: (_) => settingStore.changePrivacy(2),
                    groupValue: settingStore.privacy,
                    contentPadding: EdgeInsets.zero,
                    title: Transform.translate(
                      offset: Offset(-20.0, 0.0),
                      child: const Text(
                        "All people in internet",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Color(0xFF7C838D),
                        ),
                      ),
                    ),
                  ),
                  RadioListTile(
                    dense: true,
                    activeColor: Colors.blueAccent,
                    value: 3,
                    onChanged: (_) => settingStore.changePrivacy(3),
                    groupValue: settingStore.privacy,
                    contentPadding: EdgeInsets.zero,
                    title: Transform.translate(
                      offset: Offset(-20.0, 0.0),
                      child: const Text(
                        "Only when submitted work proposal",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Color(0xFF7C838D),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Observer(
            builder: (_) => Material(
              color: Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(6.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Filter all work proposals",
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    RadioListTile(
                      dense: true,
                      activeColor: Colors.blueAccent,
                      value: 1,
                      onChanged: (_) {
                        settingStore.changeFilter(1);
                      },
                      groupValue: settingStore.filter,
                      contentPadding: EdgeInsets.zero,
                      title: Transform.translate(
                        offset: Offset(-20.0, 0.0),
                        child: const Text(
                          "Only urgent proposals",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFF7C838D),
                          ),
                        ),
                      ),
                    ),
                    RadioListTile(
                      dense: true,
                      activeColor: Colors.blueAccent,
                      value: 2,
                      onChanged: (_) {
                        settingStore.changeFilter(2);
                      },
                      groupValue: settingStore.filter,
                      contentPadding: EdgeInsets.zero,
                      title: Transform.translate(
                        offset: Offset(-20.0, 0.0),
                        child: const Text(
                          "Only implementation",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFF7C838D),
                          ),
                        ),
                      ),
                    ),
                    RadioListTile(
                      dense: true,
                      activeColor: Colors.blueAccent,
                      value: 3,
                      onChanged: (_) {
                        settingStore.changeFilter(3);
                      },
                      groupValue: settingStore.filter,
                      contentPadding: EdgeInsets.zero,
                      title: Transform.translate(
                        offset: Offset(-20.0, 0.0),
                        child: const Text(
                          "Only ready for execution",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFF7C838D),
                          ),
                        ),
                      ),
                    ),
                    RadioListTile(
                      dense: true,
                      activeColor: Colors.blueAccent,
                      value: 4,
                      onChanged: (_) {
                        settingStore.changeFilter(4);
                      },
                      groupValue: settingStore.filter,
                      contentPadding: EdgeInsets.zero,
                      title: Transform.translate(
                        offset: Offset(-20.0, 0.0),
                        child: const Text(
                          "All registered users",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFF7C838D),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  ///Settings Card
  Widget settingsCard({
    required Widget icon,
    required String title,
    required void Function() onTap,
  }) =>
      Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: SizedBox(
            height: 130.0,
            child: Material(
              color: Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(
                6.0,
              ),
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

  ///Instrument Card

  Widget instrumentsCard(
    context, {
    required String urlArgument,
    required String iconPath,
    required String title,
  }) =>
      GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).pushNamed(
            WebViewPage.routeName,
            arguments: urlArgument,
          );
        },
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

  Widget _myProfileImage(context, ProfileMeStore userStore) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true)
            .pushNamed(ProfileReviews.routeName);
      },
      child: Container(
        height: 150.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              userStore.userData!.avatar!.url,
            ),
            fit: BoxFit.cover,
          ),
          color: Colors.blue,
          borderRadius: BorderRadius.circular(
            6.0,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 16.0,
              left: 16.0,
              child: Text(
                " ${userStore.userData?.firstName ?? " "}  ${userStore.userData?.lastName ?? " "} ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
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

  Widget _logOutButton(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: OutlinedButton(
        onPressed: () {
          showCupertinoDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext contextDialog) {
              return Platform.isIOS
                  ? CupertinoAlertDialog(
                      title: Text('Go out?'),
                      content: Text("Are you sure you want to log out?"),
                      actions: [
                        CupertinoDialogAction(
                          child: Text("Yes"),
                          onPressed: () => _onLogout(context),
                        ),
                        CupertinoDialogAction(
                          child: Text("No"),
                          onPressed: (){Navigator.pop(contextDialog);},
                        ),
                      ],
                    )
                  : AlertDialog(
                      title: Text('Go out?'),
                      content: Text("Are you sure you want to log out?"),
                      actions: [
                        CupertinoDialogAction(
                          child: Text("Yes"),
                          onPressed: () => _onLogout(context),
                        ),
                        CupertinoDialogAction(
                          child: Text("No"),
                          onPressed:(){Navigator.pop(contextDialog);},
                        ),
                      ],
                    );
            },
          );
        },
        child: Text(
          "Logout",
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
      ),
    );
  }

  _onLogout(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => Provider(
          create: (context) => getIt.get<SignInStore>(),
          child: SignInPage(),
        ),
      ),
      (route) => false,
    );

    Storage.deleteAllFromSecureStorage();
  }
}
