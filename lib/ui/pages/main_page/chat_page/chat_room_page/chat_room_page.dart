import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/model/chat_model/message_model.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/input_tool_bar.dart';
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
  ChatRoomStore? store;

  @override
  void initState() {
    store = context.read<ChatRoomStore>();
    store!.chat = widget.chat;
    store!.loadChat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          store!.chat!.name,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage(store!.chat!.imageUrl),
            maxRadius: 20,
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Container(
        alignment: Alignment.bottomLeft,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Observer(
                builder: (_) => store!.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Observer(
                        builder: (_) => ListView.builder(
                          reverse: true,
                          itemCount: store?.messages!.length,
                          itemBuilder: (context, index) {
                            return _message(store!.messages![index]);
                          },
                        ),
                      ),
              ),
            ),
            InputToolbar(store!.sendMessage),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _message(MessageModel mess) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (!mess.isMy) Spacer(),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 16),
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              color: mess.isMy ? Color(0xFF0083C7) : Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mess.text,
                  style: TextStyle(
                    color: mess.isMy ? Color(0xFFFFFFFF) : Color(0xFF1D2127),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    if (mess.status != MessageStatus.None)
                      Icon(
                        mess.status == MessageStatus.Wait
                            ? Icons.watch_later
                            : mess.status == MessageStatus.Send
                                ? Icons.check
                                : Icons.error,
                        size: 15,
                        color:
                            !mess.isMy ? Color(0xFF0083C7) : Color(0xFFF7F8FA),
                      ),
                    Text(
                      "${mess.updatedAt.hour < 10 ? "0${mess.updatedAt.hour}" : mess.updatedAt.hour}:" +
                          "${mess.updatedAt.minute < 10 ? "0${mess.updatedAt.minute}" : mess.updatedAt.minute}",
                      style: TextStyle(
                        color: mess.isMy
                            ? Color(0xFFFFFFFF).withOpacity(0.4)
                            : Color(0xFF8D96A1).withOpacity(0.4),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  String text;
  bool myMessage;

  Message(this.text, this.myMessage);
}
