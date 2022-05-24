import 'dart:async';
import 'dart:math';
import 'package:app/constants.dart';
import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/group_chat/create_group_page.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/starred_message/starred_message.dart';
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
import '../../../widgets/default_textfield.dart';
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

  late TextEditingController _searchTextController;

  Timer? _timer;

  _loadAllChats() {
    store.loadChats(type: TypeChat.active);
    store.loadChats(type: TypeChat.favourites);
    store.loadChats(type: TypeChat.group);
    store.loadChats(type: TypeChat.completed);
  }

  @override
  void initState() {
    store = context.read<ChatStore>();
    userData = context.read<ProfileMeStore>();
    _loadAllChats();
    _searchTextController = TextEditingController();
    _searchTextController.addListener(() {
      if (_timer?.isActive ?? false) _timer!.cancel();
      _timer = Timer(const Duration(milliseconds: 300), () {
        store.loadChats(query: _searchTextController.text);
      });
    });
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
                                store.loadChats(starred: true);
                                store.starred = true;
                                break;
                              case "chat.allChat":
                                store.loadChats(starred: false);
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
        body: DefaultTabController(
          length: 4,
          initialIndex: 0,
          animationDuration: const Duration(milliseconds: 500),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.5, horizontal: 16.0),
                child: DefaultTextField(
                  hint: 'Name/Quest/Group',
                  inputFormatters: [],
                  prefixIcon: Icon(
                    Icons.search,
                    size: 24.0,
                    color: AppColor.enabledButton,
                  ),
                  controller: _searchTextController,
                ),
              ),
              TabBar(
                tabs: [
                  Tab(
                    child: Text(
                      'chat.tabs.active'.tr(),
                      style: TextStyle(
                        color: AppColor.enabledButton,
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'chat.tabs.favorite'.tr(),
                      style: TextStyle(
                        color: AppColor.enabledButton,
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'chat.tabs.group'.tr(),
                      style: TextStyle(
                        color: AppColor.enabledButton,
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'chat.tabs.completed'.tr(),
                      style: TextStyle(
                        color: AppColor.enabledButton,
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _ListChatsWidget(
                      userData: userData,
                      store: store,
                      typeChat: TypeChat.active,
                    ),
                    _ListChatsWidget(
                      userData: userData,
                      store: store,
                      typeChat: TypeChat.favourites,
                    ),
                    _ListChatsWidget(
                      userData: userData,
                      store: store,
                      typeChat: TypeChat.group,
                    ),
                    _ListChatsWidget(
                      userData: userData,
                      store: store,
                      typeChat: TypeChat.completed,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListChatsWidget extends StatelessWidget {
  final ChatStore store;
  final ProfileMeStore userData;
  final TypeChat typeChat;

  const _ListChatsWidget({
    Key? key,
    required this.store,
    required this.userData,
    required this.typeChat,
  }) : super(key: key);

  List<ChatModel> _getListChats() {
    switch (typeChat) {
      case TypeChat.active:
        return store.activeChats;
      case TypeChat.favourites:
        return store.favouritesChats;
      case TypeChat.group:
        return store.groupChats;
      case TypeChat.completed:
        return store.completedChats;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: 40,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      notificationPredicate: (ScrollNotification notification) {
        return notification.depth == 0;
      },
      onRefresh: () => store.loadChats(starred: store.starred, type: typeChat),
      child: Observer(
        builder: (_) {
          final chats = _getListChats();
          if (store.isLoading) {
            return SingleChildScrollView(
              child: Column(children: List.generate(10, (index) => const _ShimmerChatItem())),
            );
          }
          if (chats.isNotEmpty) {
            return NotificationListener<ScrollEndNotification>(
              onNotification: (scrollEnd) {
                final metrics = scrollEnd.metrics;
                if (metrics.maxScrollExtent < metrics.pixels) {
                  store.loadChats(loadMore: true, starred: store.starred);
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
                    children: chats.map((chat) {
                      final widget = _ChatListTileWidget(
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
                            if (chat.lastMessage.senderUserId != userData.userData!.id) {
                              store.setMessageRead(chat.id, chat.lastMessageId);
                              chat.lastMessage.senderStatus = "read";
                            }
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(ChatRoomPage.routeName, arguments: chat.id);
                            store.checkMessage();
                          }
                        },
                        chat: chat,
                        userId: userData.userData!.id,
                        infoActionMessage: () => store.setInfoMessage(chat.lastMessage.infoMessage!.messageAction),
                        chatStarred: store.idChatsForStar[chat.id] ?? false,
                      );
                      if (store.isLoadingChats && chat == chats.last) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            widget,
                            SizedBox(
                              height: 5,
                            ),
                            CircularProgressIndicator.adaptive(),
                          ],
                        );
                      }
                      return widget;
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
  final ChatModel chat;
  final String userId;
  final Function infoActionMessage;
  final bool chatStarred;

  const _ChatListTileWidget({
    Key? key,
    required this.onLongPress,
    required this.onTap,
    required this.chat,
    required this.userId,
    required this.infoActionMessage,
    required this.chatStarred,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final differenceTime = DateTime.now().difference(chat.lastMessage.createdAt).inDays;
    ProfileMeResponse user;
    if (chat.userMembers[0].id != userId) {
      user = chat.userMembers[0];
    } else {
      try {
        user = chat.userMembers[1];
      } catch (e) {
        user = chat.userMembers[0];
      }
    }
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        color: chatStarred ? Color(0xFFE9EDF2) : Color(0xFFFFFFFF),
        child: Column(
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
                      child: chat.type != "group"
                          ? UserAvatar(
                              width: 56,
                              height: 56,
                              url: user.avatar?.url,
                            )
                          : Stack(
                              children: [
                                Container(
                                  color: _getRandomColor(
                                    chat.id,
                                  ),
                                  height: 56,
                                  width: 56,
                                ),
                                Positioned.fill(
                                  child: Center(
                                    child: Text(
                                      chat.name!.length == 1
                                          ? "${chat.name![0].toUpperCase()}"
                                          : "${chat.name![0].toUpperCase()}" + "${chat.name?[1]}",
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
                          chat.name == null ? "${user.firstName} ${user.lastName}" : "${chat.name}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          chat.lastMessage.senderUserId == userId
                              ? "chat.you".tr() + " ${chat.lastMessage.text ?? infoActionMessage.call()} "
                              : "${chat.lastMessage.sender!.firstName}:" +
                                  " ${chat.lastMessage.text ?? infoActionMessage.call()} ",
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
                      if (chat.lastMessage.senderStatus == "unread")
                        Container(
                          width: 11,
                          height: 11,
                          margin: chat.star == null
                              ? const EdgeInsets.only(top: 25, right: 16)
                              : const EdgeInsets.only(top: 20, right: 16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF0083C7),
                          ),
                        ),
                      if (chat.star != null)
                        Container(
                          margin: chat.lastMessage.senderStatus == "unread"
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
            ),
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
