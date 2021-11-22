import 'package:app/ui/pages/main_page/chat_page/chat_room_page/input_tool_bar.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/message_cell.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart';
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
  ChatRoomStore? _store;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    _store = context.read<ChatRoomStore>();
    _store!.loadChat(widget.arguments["chatId"]);
    super.initState();
    _controller.addListener(() {
      if (_controller.position.extentAfter < 500) if (_store !=
          null) if (!_store!.isLoadingMessages)
        _store!.getMessages(widget.arguments["chatId"]);
    });
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
            Flexible(
              child: Observer(
                builder: (_) => _store!.isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Observer(
                        builder: (_) => ListView.builder(
                          reverse: true,
                          controller: _controller,
                          itemCount: _store!.messages.length,
                          itemBuilder: (context, index) => MessageCell({
                            "message": _store!.messages[index],
                            "userId": widget.arguments["userId"]
                          }),
                        ),
                      ),
              ),
            ),
            InputToolbar((text) {
              _store!.sendMessage(
                text,
                _store!.chat!.id,
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
          widget.arguments["userId"] != _store!.chat!.userMembers[0].id
              ? "${_store!.chat!.userMembers[0].firstName} ${_store!.chat!.userMembers[0].lastName}"
              : "${_store!.chat!.userMembers[1].firstName} ${_store!.chat!.userMembers[1].lastName}",
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
              widget.arguments["userId"] != _store!.chat!.userMembers[0].id
                  ? _store!.chat!.userMembers[0].avatar.url
                  : _store!.chat!.userMembers[1].avatar.url,
            ),
            maxRadius: 20,
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}
