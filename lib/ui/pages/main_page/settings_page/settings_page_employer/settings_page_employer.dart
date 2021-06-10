import 'package:app/ui/pages/main_page/settings_page/settings_page_employer/store/settings_store.dart';
import 'package:app/ui/pages/singleton_stores/profile_me_store.dart';
import 'package:app/ui/widgets/gradient_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";

class SettingsPageEmployer extends StatelessWidget {
  static const String routeName = "/settingsPageEmployer";

  @override
  Widget build(context) {
    final store = context.read<SettingsPageStore>();
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
                                  onChanged: (_) => store.changePrivacy(1),
                                  groupValue: store.privacy,
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
                                  onChanged: (_) => store.changePrivacy(2),
                                  groupValue: store.privacy,
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
                                  onChanged: (_) => store.changePrivacy(3),
                                  groupValue: store.privacy,
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
                                      store.changeFilter(1);
                                    },
                                    groupValue: store.filter,
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
                                      store.changeFilter(2);
                                    },
                                    groupValue: store.filter,
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
                                      store.changeFilter(3);
                                    },
                                    groupValue: store.filter,
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
                                      store.changeFilter(4);
                                    },
                                    groupValue: store.filter,
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
