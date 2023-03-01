import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AppBarWidget extends StatelessWidget {
  final Function(String) onSelected;
  final bool isStarred;

  const AppBarWidget({
    Key? key,
    required this.onSelected,
    required this.isStarred,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text("chat.chat".tr()),
        ),
        PopupMenuButton<String>(
          elevation: 10,
          icon: Icon(Icons.more_vert),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          onSelected: onSelected,
          itemBuilder: (BuildContext context) {
            return {
              "chat.starredMessage",
              "Create private chat",
              "chat.createGroupChat",
            }.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice.tr()),
              );
            }).toList();
          },
        ),
      ],
    );
  }
}
