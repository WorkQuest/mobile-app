import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/input_tool_bar.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/message_cell.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";

class ChatRoomPage extends StatefulWidget {
  static const String routeName = "/chatRoomPage";
  final ChatModel chat;
  ChatRoomPage(this.chat);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  ChatRoomStore? _store;
  ScrollController _controller = ScrollController();
  @override
  void initState() {
    _store = context.read<ChatRoomStore>();
    _store!.chat = widget.chat;
    _store!.loadChat();
    super.initState();
    _controller.addListener(() {
      if (_controller.position.extentAfter < 500) if (_store !=
          null) if (!_store!.isloadingMessages) _store!.getMessages();
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
                    ? Center(child: CircularProgressIndicator())
                    : Observer(
                        builder: (_) => ListView.builder(
                          reverse: true,
                          controller: _controller,
                          itemCount: _store!.chat!.messages!.length,
                          itemBuilder: (context, index) =>
                              MessageCell(_store!.chat!.messages![index]),
                        ),
                      ),
              ),
            ),
            InputToolbar(_store!.sendMessage),
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
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      title: Text(
        "${_store!.chat!.otherMember.firstName} ${_store!.chat!.otherMember.lastName}",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundImage: NetworkImage(_store!.chat!.otherMember.avatar.url),
          maxRadius: 20,
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}
