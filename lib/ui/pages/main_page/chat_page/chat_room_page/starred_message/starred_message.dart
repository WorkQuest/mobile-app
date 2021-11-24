import 'package:app/ui/pages/main_page/chat_page/chat_room_page/starred_message/starred_message_cell.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class StarredMessage extends StatefulWidget {
  static const String routeName = "/starredMessage";

  final String userId;

  const StarredMessage(this.userId);

  @override
  _StarredMessageState createState() => _StarredMessageState();
}

class _StarredMessageState extends State<StarredMessage> {
  late ChatRoomStore store;

  void initState() {
    store = context.read<ChatRoomStore>();
    store.getStarredMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_sharp,
          ),
        ),
        centerTitle: true,
        title: Text(
          "chat.starredMessages".tr(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: store.starredMessage.isNotEmpty
          ? Padding(
              padding: EdgeInsets.all(16.0),
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.black12,
                  endIndent: 50.0,
                  indent: 50.0,
                ),
                itemCount: store.starredMessage.length,
                itemBuilder: (context, index) => StarredMessageCell(
                  store.starredMessage[index],
                  index,
                  widget.userId,
                ),
              ),
            )
          : Center(
              child: Text(
                "chat.noMessages".tr(),
              ),
            ),
    );
  }
}
