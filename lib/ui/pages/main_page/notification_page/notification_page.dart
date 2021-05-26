import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final List<String> item = List<String>.generate(10, (i) => 'Samantha Sparcs');

  static const String routeName = "/notifications";

  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          textAlign: TextAlign.start,
          style: TextStyle(
              color: Colors.black87,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.separated(
          itemCount: item.length,
          separatorBuilder: (context, index) => Divider(
            thickness: 3,
          ),
          itemBuilder: (context, index) => userView(item[index], item[index])),
    );
  }

  Widget userView(
    String firstName,
    String lastName,
  ) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                '14 Jan 2021, 14:54',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
              leading: CircleAvatar(
                //  backgroundImage: NetworkImage(avatar),
                radius: 30,
              ),
              title: Text(firstName + '  ' + lastName),
              //subtitle: Text('Email : ' + email),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.centerLeft,
              child: Text(
                'Invites you to a quest :',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ),
            Container(
              width: double.infinity,
              height: 50,
              padding: EdgeInsets.only(left: 10),
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
