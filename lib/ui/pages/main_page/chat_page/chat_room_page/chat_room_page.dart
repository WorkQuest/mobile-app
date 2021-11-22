import 'package:app/ui/pages/main_page/chat_page/chat_room_page/input_tool_bar.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/message_cell.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

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
  ScrollController _controller = ScrollController();

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

  @override
  void initState() {
    _store = context.read<ChatRoomStore>();
    _store.idChat = widget.arguments["chatId"];
    super.initState();
    _controller.addListener(() {
      if (_controller.position.extentAfter < 500) if (!_store.isLoadingMessages)
        _store.getMessages();
    });
    _store.loadChat(widget.arguments["chatId"]);
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
                    // : _store.flag
                    : ListView(
                        controller: _controller,
                        reverse: true,
                        children: [
                          for (final mess in _store.chat?.messages ?? [])
                            MessageCell(
                              UniqueKey(),
                              {
                                "message": mess,
                                "userId": widget.arguments["userId"]
                              },
                            )
                        ],
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
          widget.arguments["userId"] != id
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
        Observer(
          builder: (_) => CircleAvatar(
            backgroundImage: NetworkImage(
              widget.arguments["userId"] != id ? url1 : url2,
            ),
            maxRadius: 20,
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}
