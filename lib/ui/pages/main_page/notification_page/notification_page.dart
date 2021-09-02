import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class NotificationPage extends StatelessWidget {
  final List<String> item = List<String>.generate(10, (i) => 'Samantha Sparcs');

  static const String routeName = "/notificationsPage";

  Widget build(context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        CupertinoSliverNavigationBar(
          largeTitle: Text(
            "ui.notifications.title".tr(),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: item.length,
                separatorBuilder: (context, index) => Divider(
                  thickness: 1,
                ),
                itemBuilder: (context, index) => notificationCard(
                  item[index],
                  "",
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget notificationCard(
    String firstName,
    String lastName,
  ) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  child: Image.asset(
                    "assets/test_employer_avatar.jpg",
                    width: 40,
                    height: 40,
                  ),
                ),
                SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 11),
                  child: Text(firstName),
                ),
                Spacer(),
                Text(
                  '14 Jan 2021, 14:54',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFAAB0B9),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                'Invites you to a quest:',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFFAAB0B9),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Color(0xFFF7F8FA),
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
              ),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    child: Text(
                      'Paint the garage quickly',
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_forward_ios_sharp,
                        size: 20,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
