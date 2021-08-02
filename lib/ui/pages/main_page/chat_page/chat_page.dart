import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage();

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatDetails> currentList = List<ChatDetails>.generate(
    100,
    (index) => ChatDetails(
      "Samantha Sparcks",
      "https://decimalchain.com/_nuxt/img/image.b668d57.jpg",
      "Hello Samantha!",
      "14 days ago",
    ),
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
              children: currentList.map((e) => _chatItem(e)).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _chatItem(ChatDetails chatDetails) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12.5,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    chatDetails.imageUrl,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      chatDetails.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "You: ${chatDetails.lastMessage} " * 10,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7C838D),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      chatDetails.dateOfLastMessage,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFD8DFE3),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Divider(
          height: 1,
          color: Color(0xFFF7F8FA),
        )
      ],
    );
  }
}

class ChatDetails {
  String imageUrl;
  String name;
  String lastMessage;
  String dateOfLastMessage;

  ChatDetails(
    this.name,
    this.imageUrl,
    this.lastMessage,
    this.dateOfLastMessage,
  );
}
