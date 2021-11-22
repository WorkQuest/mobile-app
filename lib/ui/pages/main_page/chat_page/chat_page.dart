import 'package:app/enums.dart';
import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/chat_page/store/chat_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import 'chat_room_page/chat_room_page.dart';
import 'package:easy_localization/easy_localization.dart';

import 'chat_room_page/test.dart';
import 'dispute_page/dispute_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage();

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatStore store;
  late ProfileMeStore userData;

  @override
  void initState() {
    store = context.read<ChatStore>();
    userData = context.read<ProfileMeStore>();
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
              largeTitle: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "chat.chat".tr(),
                    ),
                  ),
                  PopupMenuButton<String>(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    itemBuilder: (BuildContext context) {
                      return store.role == UserRole.Worker
                          ? store.selectedCategoriesWorker.map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                enabled: false,
                                child: TextButton(
                                  onPressed: () {
                                    if (choice ==
                                        "chat.favoriteMessages".tr()) {
                                    } else if (choice ==
                                        "chat.openDispute".tr()) {
                                      Navigator.pushNamed(
                                          context, DisputePage.routeName,
                                          arguments: store
                                              .selectedCategoriesWorker[1]);
                                    } else {}
                                  },
                                  child: Text(
                                    choice,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            }).toList()
                          : store.selectedCategoriesEmployer
                              .map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                enabled: false,
                                child: TextButton(
                                  onPressed: () {
                                    if (choice ==
                                        "chat.favoriteMessages".tr()) {
                                    } else {}
                                  },
                                  child: Text(
                                    choice,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            }).toList();
                    },
                  ),
                ],
              ),
              border: const Border.fromBorderSide(BorderSide.none),
            ),
          ];
        },
        body: RefreshIndicator(
          onRefresh: store.loadChats,
          child: ObserverListener<ChatStore>(
            onSuccess: () {},
            child: Observer(
              builder: (_) => store.chats.isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(
                        children: store.chats.map((e) => _chatItem(e)).toList(),
                      ),
                    )
                  : Center(
                      child: Text(
                        "chat.noChats".tr(),
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
        Map<String, dynamic> arguments = {
          "chatId": chatDetails.id,
          "userId": userData.userData!.id
        };
        Navigator.of(context, rootNavigator: true)
            .pushNamed(Test.routeName, arguments: arguments);
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
                      chatDetails.userMembers[0].id != userData.userData!.id
                          ? "${chatDetails.userMembers[0].avatar.url}"
                          : "${chatDetails.userMembers[1].avatar.url}",
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
                        chatDetails.userMembers[0].id != userData.userData!.id
                            ? "${chatDetails.userMembers[0].firstName} ${chatDetails.userMembers[0].lastName}"
                            : "${chatDetails.userMembers[1].firstName} ${chatDetails.userMembers[1].lastName}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      if (chatDetails.lastMessage != null)
                        Text(
                          chatDetails.lastMessage!.senderUserId ==
                                  userData.userData!.id
                              ? "chat.you".tr() +
                                  " ${chatDetails.lastMessage!.text} "
                              : "${chatDetails.lastMessage!.sender!.firstName}:" +
                                  " ${chatDetails.lastMessage!.text} ",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF7C838D),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 5),
                      if (chatDetails.lastMessage != null)
                        Text(
                          chatDetails.lastMessageDate.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFD8DFE3),
                          ),
                        )
                    ],
                  ),
                ),
                const SizedBox(width: 50),
                if (chatDetails.lastMessage!.senderStatus == "unread")
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
