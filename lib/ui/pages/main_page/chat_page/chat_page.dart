import 'dart:math';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/group_chat/create_group_page.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/starred_message/starred_message.dart';
import 'package:app/ui/pages/main_page/chat_page/chat.dart';
import 'package:app/ui/pages/main_page/chat_page/store/chat_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  // static const _indicatorSize = 150.0;
  // final _helper = IndicatorStateHelper();
  ScrollDirection prevScrollDirection = ScrollDirection.idle;

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
            Observer(
              builder: (_) => CupertinoSliverNavigationBar(
                backgroundColor:
                    store.chatSelected ? Color(0xFF0083C7) : Colors.white,
                largeTitle:
                    store.chatSelected ? _selectedChatAppBar() : _appBar(),
                border: const Border.fromBorderSide(BorderSide.none),
              ),
            ),
          ];
        },
        body: RefreshIndicator(
          displacement: 40,
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          notificationPredicate: (ScrollNotification notification) {
            return notification.depth == 0;
          },
          onRefresh: () => store.loadChats(true, store.starred),
          child: Observer(
            builder: (_) => store.isLoading
                ? Center(child: CircularProgressIndicator.adaptive())
                : store.chats.isNotEmpty
                    ? NotificationListener<ScrollEndNotification>(
                        onNotification: (scrollEnd) {
                          final metrics = scrollEnd.metrics;
                          if (metrics.maxScrollExtent < metrics.pixels) {
                            store.loadChats(false, store.starred);
                          }
                          return true;
                        },
                        child: SingleChildScrollView(
                          clipBehavior: Clip.none,
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          child: Observer(builder: (_) {
                            return Column(
                              children:
                              // !store.starred
                              //     ?
                              store.chatKeyList
                                      .map(
                                          (key) => _chatItem(store.chats[key]!))
                                      .toList(),
                                  // : store.starredChats
                                  //     .map(
                                  //         (key) => _chatItem(store.chats[key]!))
                                  //     .toList(),
                            );
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

  Widget _appBar() => Row(
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
                  case "chat.starredMessage":
                    Navigator.of(context, rootNavigator: true).pushNamed(
                        StarredMessage.routeName,
                        arguments: userData.userData!.id);
                    break;
                  case "chat.starredChat":
                    store.loadChats(true, true);
                    store.starred = true;
                    break;
                  case "chat.allChat":
                    store.loadChats(true, false);
                    store.starred = false;
                    break;
                  case "chat.report":
                    Navigator.of(context, rootNavigator: true).pushNamed(
                      DisputePage.routeName,
                    );
                    break;
                  case "chat.createGroupChat":
                    Navigator.of(context, rootNavigator: true).pushNamed(
                      CreateGroupPage.routeName,
                      arguments: userData.userData!.id,
                    );
                    break;
                }
              },
              itemBuilder: !store.starred
                  ? (BuildContext context) {
                      return {
                        "chat.starredMessage",
                        "chat.starredChat",
                        "chat.report",
                        "chat.createGroupChat",
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
                        "chat.starredMessage",
                        "chat.allChat",
                        "chat.report",
                        "chat.createGroupChat",
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
      );

  Widget _selectedChatAppBar() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            onPressed: () {
              store.setChatSelected(false);
              store.uncheck();
            },
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
          Observer(
            builder: (_) => Text(
              "${store.chatsId.length}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  store.setChatSelected(false);
                  store.setStar();
                },
                icon: Icon(
                  Icons.star,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  "assets/trash.svg",
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      );

  Widget _chatItem(Chats chatDetails) {
    Color getRandomColor(String id) {
      Random random = Random(id.hashCode.toInt());

      List<Color> colors = [
        Color(0xFF00ABEA),
        Color(0xFF3C6AD7),
        Color(0xFF582BD3),
        Color(0xFF812ED3),
        Color(0xFFAE29C9),
        Color(0xFFD4344F),
        Color(0xFFE05300),
        Color(0xFF29C6B7),
        Color(0xFFEEAD00),
      ];

      return colors[random.nextInt(colors.length)];
    }

    final differenceTime =
        DateTime.now().difference(chatDetails.chatModel.lastMessageDate).inDays;
    store.chatSort();
    return GestureDetector(
      onLongPress: () {
        store.setChatSelected(true);
        store.setChatHighlighted(chatDetails);
      },
      onTap: () {
        if (store.chatSelected) {
          store.setChatHighlighted(chatDetails);
          for (int i = 0; i < store.idChatsForStar.values.length; i++)
            if (store.idChatsForStar.values.toList()[i] == true) return;
          store.setChatSelected(false);
        } else {
          if (chatDetails.chatModel.lastMessage.senderUserId !=
              userData.userData!.id) {
            store.setMessageRead(
                chatDetails.chatModel.id, chatDetails.chatModel.lastMessageId);
            chatDetails.chatModel.lastMessage.senderStatus = "read";
          }
          Navigator.of(context, rootNavigator: true).pushNamed(
              ChatRoomPage.routeName,
              arguments: chatDetails.chatModel.id);
          store.checkMessage();
        }
      },
      child: Observer(
        builder: (_) => Container(
          color: store.idChatsForStar[chatDetails.chatModel.id]!
              ? Color(0xFFE9EDF2)
              : Color(0xFFFFFFFF),
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
                          child: chatDetails.chatModel.type != "group"
                              ? Image.network(
                                  chatDetails.chatModel.userMembers[0].id !=
                                          userData.userData!.id
                                      ? "${chatDetails.chatModel.userMembers[0].avatar!.url}"
                                      : "${chatDetails.chatModel.userMembers[1].avatar!.url}",
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                )
                              : Stack(
                                  children: [
                                    Container(
                                      color: getRandomColor(
                                        chatDetails.chatModel.id,
                                      ),
                                      height: 56,
                                      width: 56,
                                    ),
                                    Positioned.fill(
                                      child: Center(
                                        child: Text(
                                          chatDetails.chatModel.name!.length ==
                                                  1
                                              ? "${chatDetails.chatModel.name![0].toUpperCase()}"
                                              : "${chatDetails.chatModel.name![0].toUpperCase()}" +
                                                  "${chatDetails.chatModel.name?[1]}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 32,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
                      Column(
                        children: [
                          if (chatDetails.chatModel.lastMessage.senderStatus ==
                              "unread")
                            Container(
                              width: 11,
                              height: 11,
                              margin: chatDetails.chatModel.star == null
                                  ? const EdgeInsets.only(top: 25, right: 16)
                                  : const EdgeInsets.only(top: 20, right: 16),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF0083C7),
                              ),
                            ),
                          if (chatDetails.chatModel.star != null)
                            Container(
                              margin: chatDetails
                                          .chatModel.lastMessage.senderStatus ==
                                      "unread"
                                  ? const EdgeInsets.only(top: 3, right: 16)
                                  : const EdgeInsets.only(top: 23, right: 16),
                              child: Icon(
                                Icons.star,
                                color: Color(0xFFE8D20D),
                                size: 20.0,
                              ),
                            ),
                        ],
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
      ),
    );
  }
}
