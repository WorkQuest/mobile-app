import 'package:app/ui/pages/singleton_stores/profile_me_store.dart';
import 'package:app/ui/widgets/gradient_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:provider/provider.dart";

class SettingsPageWorker extends StatelessWidget {
  static const String routeName = "/settingsPageWorker";

  @override
  Widget build(context) {
    // final userStore = context.read<ProfileMeStore>();

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
                  Container(
                    height: 125.0,
                    width: 343.0,
                    decoration: BoxDecoration(
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
                            "userStore.userData!.firstName + userStore.userData!.lastName",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 60.0,
                          left: 16.0,
                          child: Container(
                            height: 16.0,
                            padding: EdgeInsets.symmetric(
                              vertical: 2.0,
                              horizontal: 5.0,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFFF6CF00),
                              borderRadius: BorderRadius.circular(
                                3.0,
                              ),
                            ),
                            child: Text(
                              "HIGHER LEVEL",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
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
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 125.0,
                              width: 164.0,
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
                                          Icons.lock_outline,
                                          20.0,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 16.0,
                                      left: 16.0,
                                      right: 60.0,
                                      child: Text(
                                        "Change password",
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
                              width: 164.0,
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
                                width: 164.0,
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
                                          "SMS Verification",
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
                                width: 164.0,
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
                                            Icons.person,
                                            20.0,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 16.0,
                                        left: 16.0,
                                        right: 60.0,
                                        child: Text(
                                          "Change \nrole",
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
                  Column(
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
                      Container(
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
                                  Icons.storage_outlined,
                                  20.0,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Pension program",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
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
                      Container(
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
                                  Icons.people_alt_outlined,
                                  20.0,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Referral Program",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
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
                      Container(
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
                                  Icons.house_outlined,
                                  20.0,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "P2P insurance",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
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
                      Container(
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
                                  Icons.shopping_bag_outlined,
                                  20.0,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Savings product",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
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
                      Container(
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
                                  Icons.account_balance_wallet_outlined,
                                  20.0,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Сrediting",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
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
                      Container(
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
                                  Icons.auto_graph,
                                  20.0,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Liquidity mining",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
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
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
