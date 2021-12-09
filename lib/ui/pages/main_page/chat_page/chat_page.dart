import 'package:app/ui/pages/main_page/chat_page/chat_room_page/group_chat/create_group_page.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/starred_message/starred_message.dart';
import 'package:app/ui/pages/main_page/chat_page/repository/chat.dart';
import 'package:app/ui/pages/main_page/chat_page/store/chat_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import 'chat_room_page/chat_room_page.dart';
import 'package:easy_localization/easy_localization.dart';

import 'dispute_page/dispute_page.dart';

class ChatPage extends StatefulWidget {
  static const String routeName = "/chatPage";

  const ChatPage();

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatStore store;
  late ProfileMeStore userData;
  ScrollController controller = ScrollController();

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
                  Observer(
                    builder: (_) => PopupMenuButton<String>(
                      elevation: 10,
                      icon: Icon(Icons.more_vert),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      onSelected: (value) {
                        switch (value) {
                          case "Starred message":
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(StarredMessage.routeName,
                                    arguments: userData.userData!.id);
                            break;
                          case "Starred chat":
                            store.openStarredChats(true);
                            break;
                          case "All chat":
                            store.openStarredChats(false);
                            break;
                          case "Report":
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(
                              DisputePage.routeName,
                            );
                            break;
                          case "Create group chat":
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(
                              CreateGroupPage.routeName,
                              arguments: userData.userData!.id,
                            );
                            break;
                        }
                      },
                      itemBuilder: !store.starred
                          ? (BuildContext context) {
                              return {
                                "Starred message",
                                "Starred chat",
                                "Report",
                                "Create group chat",
                              }.map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(
                                    choice.tr(),
                                  ),
                                );
                              }).toList();
                            }
                          : (BuildContext context) {
                              return {
                                "Starred message",
                                "All chat",
                                "Report",
                                "Create group chat",
                              }.map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(
                                    choice.tr(),
                                  ),
                                );
                              }).toList();
                            },
                    ),
                  ),
                ],
              ),
              border: const Border.fromBorderSide(BorderSide.none),
            ),
          ];
        },
        body: RefreshIndicator(
          onRefresh: () {
            store.loadChats(true);
            return Future.value(false);
          },
          child: Observer(
            builder: (_) => store.isLoading
                ? Center(child: CircularProgressIndicator())
                : store.chats.isNotEmpty
                    ? NotificationListener<ScrollEndNotification>(
                        onNotification: (scrollEnd) {
                          final metrics = scrollEnd.metrics;
                          if (metrics.maxScrollExtent < metrics.pixels) {
                            store.loadChats(false);
                          }
                          return true;
                        },
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          child: Observer(builder: (_) {
                            return Column(
                                children: !store.starred
                                    ? store.chatKeyList
                                        .map((key) =>
                                            _chatItem(store.chats[key]!))
                                        .toList()
                                    : store.starredChats
                                        .map((key) => _chatItem(key))
                                        .toList());
                          }),
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
    );
  }

  Widget _chatItem(Chats chatDetails) {
    final differenceTime =
        DateTime.now().difference(chatDetails.chatModel.lastMessageDate).inDays;
    return GestureDetector(
      onTap: () {
        // if (store.messageSelected) {
        //   store.setMessageHighlighted(widget.index, widget.mess);
        // }
        // for (int i = 0; i < store.isMessageHighlighted.length; i++)
        //   if (store.isMessageHighlighted[i] == true) {
        //     return;
        //   }
        // store.setMessageSelected(false);
        Map<String, dynamic> arguments = {
          "chatId": chatDetails.chatModel.id,
          "userId": userData.userData!.id
        };
        if (chatDetails.chatModel.lastMessage.senderUserId !=
            userData.userData!.id) {
          store.setMessageRead(
              chatDetails.chatModel.id, chatDetails.chatModel.lastMessageId);
          chatDetails.chatModel.lastMessage.senderStatus = "read";
        }
        Navigator.of(context, rootNavigator: true)
            .pushNamed(ChatRoomPage.routeName, arguments: arguments);
        store.checkMessage();
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Observer(builder: (_) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.5,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
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
                          chatDetails.chatModel.type == "group"
                              ? "https://workquest-cdn.fra1.digitaloceanspaces.com/sUYNZfZJvHr8fyVcrRroVo8PpzA5RbTghdnP0yEcJuIhTW26A5vlCYG8mZXs"
                              : chatDetails.chatModel.userMembers[0].id !=
                                      userData.userData!.id
                                  ? "${chatDetails.chatModel.userMembers[0].avatar!.url}"
                                  : "${chatDetails.chatModel.userMembers[1].avatar!.url}",
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
                            chatDetails.chatModel.name == null
                                ? chatDetails.chatModel.userMembers[0].id !=
                                        userData.userData!.id
                                    ? "${chatDetails.chatModel.userMembers[0].firstName} ${chatDetails.chatModel.userMembers[0].lastName}"
                                    : "${chatDetails.chatModel.userMembers[1].firstName} ${chatDetails.chatModel.userMembers[1].lastName}"
                                : "${chatDetails.chatModel.name}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            chatDetails.chatModel.lastMessage.senderUserId ==
                                    userData.userData!.id
                                ? "chat.you".tr() +
                                    " ${chatDetails.chatModel.lastMessage.text ?? store.setInfoMessage(chatDetails.chatModel.lastMessage.infoMessage!.messageAction)} "
                                : "${chatDetails.chatModel.lastMessage.sender!.firstName}:" +
                                    " ${chatDetails.chatModel.lastMessage.text ?? store.setInfoMessage(chatDetails.chatModel.lastMessage.infoMessage!.messageAction)} ",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF7C838D),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            differenceTime == 0
                                ? "chat.today".tr()
                                : differenceTime == 1
                                    ? "$differenceTime " + "chat.day".tr()
                                    : "$differenceTime " + "chat.days".tr(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFD8DFE3),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 50),
                    if (chatDetails.chatModel.lastMessage.senderStatus ==
                        "unread")
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
              );
            }),
            Divider(
              height: 1,
              color: Color(0xFFF7F8FA),
            )
          ],
        ),
      ),
    );
  }
}
