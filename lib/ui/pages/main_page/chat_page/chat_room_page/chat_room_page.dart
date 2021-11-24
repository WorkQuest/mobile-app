import 'package:app/ui/pages/main_page/chat_page/chat_room_page/group_chat/edit_group_chat.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/input_tool_bar.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/message_cell.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart';
import 'package:app/ui/widgets/media_upload_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import "package:provider/provider.dart";

class ChatRoomPage extends StatefulWidget {
  static const String routeName = "/chatRoomPage";
  final Map<String, dynamic> arguments;

  ChatRoomPage(this.arguments);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  late final ChatRoomStore _store;

  String get id => _store.chat?.chatModel.userMembers[0].id ?? "--";

  String get firstName1 =>
      _store.chat?.chatModel.userMembers[0].firstName ?? "--";

  String get lastName1 =>
      _store.chat?.chatModel.userMembers[0].lastName ?? "--";

  String get firstName2 =>
      _store.chat?.chatModel.userMembers[1].firstName ?? "--";

  String get lastName2 =>
      _store.chat?.chatModel.userMembers[1].lastName ?? "--";

  String get url1 =>
      _store.chat?.chatModel.userMembers[0].avatar.url ??
      "https://workquest-cdn.fra1.digitaloceanspaces.com/sUYNZfZJvHr8fyVcrRroVo8PpzA5RbTghdnP0yEcJuIhTW26A5vlCYG8mZXs";

  String get url2 =>
      _store.chat?.chatModel.userMembers[1].avatar.url ??
      "https://workquest-cdn.fra1.digitaloceanspaces.com/sUYNZfZJvHr8fyVcrRroVo8PpzA5RbTghdnP0yEcJuIhTW26A5vlCYG8mZXs";

  String get chatType => _store.chat?.chatModel.type ?? "";

  String get chatName => _store.chat?.chatModel.name ?? "--";

  @override
  void initState() {
    _store = context.read<ChatRoomStore>();
    _store.idChat = widget.arguments["chatId"];
    super.initState();
    if (_store.chat!.chatModel.type == "group") _store.generateListUserInChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        alignment: Alignment.bottomLeft,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Observer(builder: (_) {
                return _store.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : NotificationListener<ScrollStartNotification>(
                        onNotification: (scrollStart) {
                          final metrics = scrollStart.metrics;
                          if (metrics.maxScrollExtent < metrics.pixels) {
                            _store.getMessages(true);
                          }
                          return true;
                        },
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          itemCount: _store.chat?.messages.length,
                          itemBuilder: (context, index) => MessageCell(
                            UniqueKey(),
                            _store.chat!.messages[index],
                            widget.arguments["userId"],
                            index,
                          ),
                          reverse: true,
                        ),
                      );
              }),
            ),
            InputToolbar((text) {
              _store.sendMessage(
                text,
                _store.chat!.chatModel.id,
                widget.arguments["userId"],
              );
            }),
            const SizedBox(height: 10),
            MediaUpload(null,
              mediaDrishya: _store.media,
            )
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back_ios_sharp,
        ),
      ),
      centerTitle: true,
      title: Observer(
        builder: (_) => Text(
          chatType == "group"
              ? "$chatName"
              : widget.arguments["userId"] != id
                  ? "$firstName1 $lastName1"
                  : "$firstName2 $lastName2",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      actions: [
        // chatType == "group"
        //     ? IconButton(
        //         onPressed: () {
        //           Navigator.pushNamed(context, EditGroupChat.routeName,
        //               arguments: _store);
        //         },
        //         icon: Icon(Icons.edit),
        //       )
        //     :
        Observer(
          builder: (_) => CircleAvatar(
            backgroundImage: NetworkImage(
              widget.arguments["userId"] != id ? url1 : url2,
            ),
            maxRadius: 20,
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
