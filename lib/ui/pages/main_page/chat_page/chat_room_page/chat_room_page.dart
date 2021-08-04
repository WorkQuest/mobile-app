import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatRoomPage extends StatefulWidget {
  static const String routeName = "/chatRoomPage";

  const ChatRoomPage();

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  List<Message> listMessages = List.generate(
    20,
    (index) => Message(
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit ut aliquam",
        index % 2 == 1),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        physics: const ClampingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            CupertinoSliverNavigationBar(
              largeTitle: Text("Chat"),
              border: const Border.fromBorderSide(BorderSide.none),
              trailing: Container(
                transform: Matrix4.translationValues(0, 50, 0),
                child: InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.more_vert,
                  ),
                ),
              ),
            ),
          ];
        },
        body: RefreshIndicator(
          onRefresh: () async {
            return Future.delayed(
              Duration(milliseconds: 1000),
            );
          },
          child: SingleChildScrollView(
            child: Column(
              children: listMessages.map((e) => _message(e)).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _message(Message e) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (!e.myMessage) Spacer(),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 16),
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              color: e.myMessage ? Color(0xFF0083C7) : Color(0xFFF7F8FA),
              // Color(0xFFF7F8FA)
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.text,
                  style: TextStyle(
                    color: e.myMessage ? Color(0xFFFFFFFF) : Color(0xFF1D2127),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "14:47",
                  style: TextStyle(
                    color: e.myMessage
                        ? Color(0xFFFFFFFF).withOpacity(0.4)
                        : Color(0xFF8D96A1).withOpacity(0.4),
                  ),
                ),
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
