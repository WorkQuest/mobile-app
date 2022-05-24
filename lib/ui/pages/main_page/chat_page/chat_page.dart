import 'dart:math';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/group_chat/create_group_page.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/starred_message/starred_message.dart';
import 'package:app/ui/pages/main_page/chat_page/chat.dart';
import 'package:app/ui/pages/main_page/chat_page/store/chat_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/user_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import "package:provider/provider.dart";
import '../../../../model/profile_response/profile_me_response.dart';
import '../../../widgets/shimmer.dart';
import 'chat_room_page/chat_room_page.dart';
import 'package:easy_localization/easy_localization.dart';

class ChatPage extends StatefulWidget {
  static const String routeName = "/chatPage";

  const ChatPage();

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatStore store;
  late ProfileMeStore userData;

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
                backgroundColor: store.chatSelected ? Color(0xFF0083C7) : Colors.white,
                largeTitle: store.chatSelected
                    ? Observer(
                        builder: (_) => _SelectedAppBarWidget(
                          onPressedClose: () {
                            store.setChatSelected(false);
                            store.uncheck();
                          },
                          onPressedStar: () {
                            store.setChatSelected(false);
                            store.setStar();
                          },
                          lengthSelectedChats: store.chatsId.length.toString(),
                        ),
                      )
                    : Observer(
                        builder: (_) => _AppBarWidget(
                          onSelected: (value) {
                            switch (value) {
                              case "chat.starredMessage":
                                Navigator.of(context, rootNavigator: true)
                                    .pushNamed(StarredMessage.routeName, arguments: userData.userData!.id);
                                break;
                              case "chat.starredChat":
                                store.loadChats(true, true);
                                store.starred = true;
                                break;
                              case "chat.allChat":
                                store.loadChats(true, false);
                                store.starred = false;
                                break;
                              case "chat.createGroupChat":
                                Navigator.of(context, rootNavigator: true).pushNamed(
                                  CreateGroupPage.routeName,
                                  arguments: userData.userData!.id,
                                );
                                break;
                            }
                          },
                          isStarred: store.starred,
                        ),
                      ),
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
            builder: (_) {
              if (store.isLoading) {
                return SingleChildScrollView(
                  child: Column(children: List.generate(10, (index) => const _ShimmerChatItem())),
                );
              }
              if (store.chats.isNotEmpty) {
                return NotificationListener<ScrollEndNotification>(
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
                        children: store.chatKeyList.map((key) {
                          final chat = store.chats[key]!;
                          return _ChatListTileWidget(
                            onLongPress: () {
                              store.setChatSelected(true);
                              store.setChatHighlighted(chat);
                            },
                            onTap: () {
                              if (store.chatSelected) {
                                store.setChatHighlighted(chat);
                                for (int i = 0; i < store.idChatsForStar.values.length; i++)
                                  if (store.idChatsForStar.values.toList()[i] == true) return;
                                store.setChatSelected(false);
                              } else {
                                if (chat.chatModel.lastMessage.senderUserId != userData.userData!.id) {
                                  store.setMessageRead(chat.chatModel.id, chat.chatModel.lastMessageId);
                                  chat.chatModel.lastMessage.senderStatus = "read";
                                }
                                Navigator.of(context, rootNavigator: true)
                                    .pushNamed(ChatRoomPage.routeName, arguments: chat.chatModel.id);
                                store.checkMessage();
                              }
                            },
                            chatDetails: chat,
                            userId: userData.userData!.id,
                            infoActionMessage: () =>
                                store.setInfoMessage(chat.chatModel.lastMessage.infoMessage!.messageAction),
                            chatStarred: store.idChatsForStar[chat.chatModel.id]!,
                          );
                        }).toList(),
                      );
                    }),
                  ),
                );
              }
              return Center(
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      SvgPicture.asset(
                        "assets/empty_quest_icon.svg",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "chat.noChats".tr(),
                        style: TextStyle(
                          color: Color(0xFFD8DFE3),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AppBarWidget extends StatelessWidget {
  final Function(String) onSelected;
  final bool isStarred;

  const _AppBarWidget({
    Key? key,
    required this.onSelected,
    required this.isStarred,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            "chat.chat".tr(),
          ),
        ),
        PopupMenuButton<String>(
          elevation: 10,
          icon: Icon(Icons.more_vert),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          onSelected: onSelected,
          itemBuilder: (BuildContext context) {
            return {
              "chat.starredMessage",
              !isStarred ? "chat.starredChat" : "chat.allChat",
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
      ],
    );
  }
}

class _SelectedAppBarWidget extends StatelessWidget {
  final Function()? onPressedClose;
  final Function()? onPressedStar;
  final String lengthSelectedChats;

  const _SelectedAppBarWidget({
    Key? key,
    required this.onPressedClose,
    required this.onPressedStar,
    required this.lengthSelectedChats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          onPressed: onPressedClose,
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
        Text(
          "$lengthSelectedChats",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: onPressedStar,
              icon: Icon(
                Icons.star,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ChatListTileWidget extends StatelessWidget {
  final Function()? onLongPress;
  final Function()? onTap;
  final Chats chatDetails;
  final String userId;
  final Function infoActionMessage;
  final bool chatStarred;

  const _ChatListTileWidget({
    Key? key,
    required this.onLongPress,
    required this.onTap,
    required this.chatDetails,
    required this.userId,
    required this.infoActionMessage,
    required this.chatStarred,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final differenceTime = DateTime.now().difference(chatDetails.chatModel.lastMessageDate).inDays;
    ProfileMeResponse user;
    if (chatDetails.chatModel.userMembers[0].id != userId) {
      user = chatDetails.chatModel.userMembers[0];
    } else {
      user = chatDetails.chatModel.userMembers[1];
    }
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        color: chatStarred ? Color(0xFFE9EDF2) : Color(0xFFFFFFFF),
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
                            ? UserAvatar(
                                width: 56,
                                height: 56,
                                url: user.avatar?.url,
                              )
                            : Stack(
                                children: [
                                  Container(
                                    color: _getRandomColor(
                                      chatDetails.chatModel.id,
                                    ),
                                    height: 56,
                                    width: 56,
                                  ),
                                  Positioned.fill(
                                    child: Center(
                                      child: Text(
                                        chatDetails.chatModel.name!.length == 1
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
                                ? "${user.firstName} ${user.lastName}"
                                : "${chatDetails.chatModel.name}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            chatDetails.chatModel.lastMessage.senderUserId == userId
                                ? "chat.you".tr() +
                                    " ${chatDetails.chatModel.lastMessage.text ?? infoActionMessage.call()} "
                                : "${chatDetails.chatModel.lastMessage.sender!.firstName}:" +
                                    " ${chatDetails.chatModel.lastMessage.text ?? infoActionMessage.call()} ",
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
                        if (chatDetails.chatModel.lastMessage.senderStatus == "unread")
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
                            margin: chatDetails.chatModel.lastMessage.senderStatus == "unread"
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
    );
  }

  Color _getRandomColor(String id) {
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
}

class _ShimmerChatItem extends StatelessWidget {
  const _ShimmerChatItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
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
                  child: _ShimmerItem(
                    width: 56,
                    height: 56,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _ShimmerItem(width: double.infinity, height: 20),
                    const SizedBox(height: 5),
                    _ShimmerItem(width: double.infinity, height: 20),
                    const SizedBox(height: 5),
                    _ShimmerItem(width: 50, height: 20),
                  ],
                ),
              ),
              const SizedBox(width: 50),
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

class _ShimmerItem extends StatelessWidget {
  final double width;
  final double height;

  const _ShimmerItem({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.stand(
      child: Container(
        child: SizedBox(
          height: height,
          width: width,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
        ),
      ),
    );
  }
}
