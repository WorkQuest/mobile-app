import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/chat_page/store/chat_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import 'chat_room_page/chat_room_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage();

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatStore? store;

  @override
  void initState() {
    store = context.read<ChatStore>();
    store!.loadChats();
    super.initState();
  }

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
            return await store!.loadChats();
          },
          child: ObserverListener<ChatStore>(
            onSuccess: () {},
            child: Observer(
              builder: (_) => store!.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        children:
                            store!.chats.map((e) => _chatItem(e)).toList(),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _chatItem(ChatModel chatDetails, {bool hasUnreadMessages = false}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true)
            .pushNamed(ChatRoomPage.routeName, arguments: chatDetails);
      },
      child: Column(
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
                      if (chatDetails.lastMessage != null)
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
                      if (chatDetails.lastMessageDate != null)
                        Text(
                          chatDetails.lastMessageDate!.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFD8DFE3),
                          ),
                        )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                Container(
                  width: 11,
                  height: 11,
                  margin: const EdgeInsets.only(top: 25, right: 16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF0083C7),
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
      ),
    );
  }
}
