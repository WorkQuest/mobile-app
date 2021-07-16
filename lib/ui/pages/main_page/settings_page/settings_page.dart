import 'package:app/enums.dart';
import 'package:app/ui/pages/main_page/profile_reviews_page/profileMe_reviews_page.dart';
import 'package:app/ui/pages/main_page/settings_page/store/settings_store.dart';
import 'package:app/ui/widgets/web_view_page/web_view_page.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/gradient_icon.dart';
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
            padding: EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  _myProfileImage(context, userStore),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 125.0,
                              width: 165.0,
                              child: Material(
                                color: Color(0xFFF7F8FA),
                                borderRadius: BorderRadius.circular(
                                  6.0,
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 8.0,
                                      left: 8.0,
                                      child: IconButton(
                                        onPressed: null,
                                        icon: GradientIcon(
                                          SvgPicture.asset(
                                            "assets/settings_password_icon.svg",
                                          ),
                                          20.0,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 16.0,
                                      left: 16.0,
                                      right: 60.0,
                                      child: Text(
                                        "Change Password",
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 16.0,
                                      right: 26.0,
                                      child: Icon(
                                        Icons.arrow_right_sharp,
                                        color: Color(0xFFD8DFE3),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 125.0,
                              width: 165.0,
                              child: Material(
                                color: Color(0xFFF7F8FA),
                                borderRadius: BorderRadius.circular(
                                  6.0,
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: 16.0,
                                      left: 16.0,
                                      right: 60.0,
                                      child: Text(
                                        "2FA",
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 16.0,
                                      right: 26.0,
                                      child: Icon(
                                        Icons.arrow_right_sharp,
                                        color: Color(0xFFD8DFE3),
                                      ),
                                    ),
                                    Positioned(
                                      top: 16.0,
                                      left: 16.0,
                                      bottom: 83,
                                      child: CupertinoSwitch(
                                        onChanged: null,
                                        value: false,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 125.0,
                                width: 165.0,
                                child: Material(
                                  color: Color(0xFFF7F8FA),
                                  borderRadius: BorderRadius.circular(
                                    6.0,
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        bottom: 16.0,
                                        left: 16.0,
                                        right: 60.0,
                                        child: Text(
                                          "SMS \nVerification",
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 16.0,
                                        right: 26.0,
                                        child: Icon(
                                          Icons.arrow_right_sharp,
                                          color: Color(0xFFD8DFE3),
                                        ),
                                      ),
                                      Positioned(
                                        top: 16.0,
                                        left: 16.0,
                                        bottom: 83,
                                        child: CupertinoSwitch(
                                          onChanged: null,
                                          value: false,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 125.0,
                                width: 165.0,
                                child: Material(
                                  color: Color(0xFFF7F8FA),
                                  borderRadius: BorderRadius.circular(
                                    6.0,
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 8.0,
                                        left: 8.0,
                                        child: IconButton(
                                          onPressed: null,
                                          icon: GradientIcon(
                                            SvgPicture.asset(
                                              "assets/settings_role_icon.svg",
                                            ),
                                            20.0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 16.0,
                                        left: 16.0,
                                        right: 60.0,
                                        child: Text(
                                          "Change \nRole",
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 16.0,
                                        right: 26.0,
                                        child: Icon(
                                          Icons.arrow_right_sharp,
                                          color: Color(0xFFD8DFE3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
                  userStore.userData!.role == UserRole.Worker
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

  Widget workerSettings(context) {
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
        GestureDetector(
          onTap: () {
            Navigator.of(context, rootNavigator: true).pushNamed(
              WebViewPage.routeName,
              arguments: "pension",
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
                        "assets/settings_pension_icon.svg",
                      ),
                      16.0,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Pension program",
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
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context, rootNavigator: true)
                .pushNamed(WebViewPage.routeName, arguments: "referral");
          },
          child: Container(
            height: 54.0,
            margin: EdgeInsets.only(
              bottom: 10.0,
            ),
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
                        "assets/settings_referral_icon.svg",
                      ),
                      16.0,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Referral Program",
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
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context, rootNavigator: true)
                .pushNamed(WebViewPage.routeName, arguments: "insuring");
          },
          child: Container(
            margin: EdgeInsets.only(
              bottom: 10.0,
            ),
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
                        "assets/settings_p2p_icon.svg",
                      ),
                      16.0,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "P2P insurance",
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
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context, rootNavigator: true)
                .pushNamed(WebViewPage.routeName, arguments: "savings");
          },
          child: Container(
            margin: EdgeInsets.only(
              bottom: 10.0,
            ),
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
                        "assets/setting_saving_product_icon.svg",
                      ),
                      16.0,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Savings product",
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
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context, rootNavigator: true)
                .pushNamed(WebViewPage.routeName, arguments: "crediting");
          },
          child: Container(
            margin: EdgeInsets.only(
              bottom: 10.0,
            ),
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
                        "assets/settings_wallet.svg",
                      ),
                      16.0,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Сrediting",
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
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context, rootNavigator: true)
                .pushNamed(WebViewPage.routeName, arguments: "mining");
          },
          child: Container(
            height: 54.0,
            margin: EdgeInsets.only(
              bottom: 10.0,
            ),
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
                        "assets/setting_chart.svg",
                      ),
                      16.0,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Liquidity mining",
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

  Widget _myProfileImage(context, userStore) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true)
            .pushNamed(ProfileReviews.routeName);
      },
      child: Container(
        height: 125.0,
        width: 343.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              userStore.userData!.avatar.url,
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
                userStore.userData!.firstName + userStore.userData!.lastName,
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
}
