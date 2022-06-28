import 'dart:async';
import 'dart:math';
import 'package:app/constants.dart';
import 'package:app/enums.dart';
import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/model/chat_model/member.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/group_chat/create_group_page.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/starred_message/starred_message.dart';
import 'package:app/ui/pages/main_page/chat_page/store/chat_store.dart';
import 'package:app/ui/widgets/user_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import "package:provider/provider.dart";
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

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  late ChatStore store;

  late TextEditingController _searchTextController;
  late TabController _tabController;
  Timer? _timer;

  @override
  void initState() {
    store = context.read<ChatStore>();
    _searchTextController = TextEditingController();
    _tabController = TabController(vsync: this, length: 5)
      ..addListener(() {
        store.getChatTypeFromIndex(_tabController.index);
        setState(() {});
      });
    _searchTextController.addListener(() {
      if (_timer?.isActive ?? false) _timer!.cancel();
      _timer = Timer(const Duration(milliseconds: 300), () {
        store.loadChats(
          query: _searchTextController.text,
          type: store.typeChat,
        );
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: NestedScrollView(
          physics: const ClampingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              Observer(
                builder: (_) => CupertinoSliverNavigationBar(
                  backgroundColor:
                      store.chatSelected ? Color(0xFF0083C7) : Colors.white,
                  largeTitle: store.chatSelected
                      ? Observer(
                          builder: (_) => _SelectedAppBarWidget(
                            onPressedClose: () {
                              store.setChatSelected(false);
                              store.resetSelectedChats();
                            },
                            onPressedStar: () {
                              store.setChatSelected(false);
                              store.setStar();
                            },
                            lengthSelectedChats: store.getCountStarredChats(),
                          ),
                        )
                      : Observer(
                          builder: (_) => _AppBarWidget(
                            onSelected: (value) {
                              switch (value) {
                                case "chat.starredMessage":
                                  Navigator.of(context, rootNavigator: true)
                                      .pushNamed(
                                    StarredMessage.routeName,
                                    arguments: store.myId,
                                  );
                                  break;
                                case "Create private chat":
                                  Navigator.of(context, rootNavigator: true)
                                      .pushNamed(
                                    CreateGroupPage.routeName,
                                    arguments: false,
                                  );
                                  break;
                                case "chat.createGroupChat":
                                  Navigator.of(context, rootNavigator: true)
                                      .pushNamed(
                                    CreateGroupPage.routeName,
                                    arguments: true,
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
            length: 5,
            initialIndex: 0,
            animationDuration: const Duration(milliseconds: 500),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.5,
                    horizontal: 16.0,
                  ),
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
                  isScrollable: true,
                  controller: _tabController,
                  tabs: [
                    tab(text: 'chat.tabs.active'),
                    tab(text: 'chat.tabs.privates'),
                    tab(text: 'chat.tabs.favorite'),
                    tab(text: 'chat.tabs.group'),
                    tab(text: 'chat.tabs.completed'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _ListChatsWidget(
                        typeChat: TypeChat.active,
                        query: _searchTextController.text,
                        myId: store.myId,
                        store: store,
                        onLongPress: onLongPress,
                        onPress: onPress,
                      ),
                      _ListChatsWidget(
                        typeChat: TypeChat.privates,
                        query: _searchTextController.text,
                        myId: store.myId,
                        store: store,
                        onLongPress: onLongPress,
                        onPress: onPress,
                      ),
                      _ListChatsWidget(
                        typeChat: TypeChat.favourites,
                        query: _searchTextController.text,
                        myId: store.myId,
                        store: store,
                        onLongPress: onLongPress,
                        onPress: onPress,
                      ),
                      _ListChatsWidget(
                        typeChat: TypeChat.group,
                        query: _searchTextController.text,
                        myId: store.myId,
                        store: store,
                        onLongPress: onLongPress,
                        onPress: onPress,
                      ),
                      _ListChatsWidget(
                        typeChat: TypeChat.completed,
                        query: _searchTextController.text,
                        myId: store.myId,
                        store: store,
                        onLongPress: onLongPress,
                        onPress: onPress,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tab({
    required String text,
  }) =>
      Tab(
        child: Text(
          text.tr(),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColor.enabledButton,
            fontSize: 13.0,
          ),
        ),
      );

  void onLongPress(ChatModel chat) {
    store.setChatSelected(true);
    store.setChatHighlighted(chat);
  }

  void onPress(ChatModel chat) {
    if (store.chatSelected) {
      store.setChatHighlighted(chat);
      for (int i = 0; i < store.selectedChats.values.length; i++)
        if (store.selectedChats.values.toList()[i] == true) return;
      store.setChatSelected(false);
    } else {
      if (chat.chatData.lastMessage?.sender?.userId != store.myId &&
          chat.chatData.lastMessage?.senderStatus == "Unread") {
        store.setMessageRead(
          chat.id,
          chat.chatData.lastMessageId,
        );
        chat.chatData.lastMessage?.senderStatus = "Read";
      }
      Navigator.of(context, rootNavigator: true).pushNamed(
        ChatRoomPage.routeName,
        arguments: ChatRoomArguments(chat.id, false),
      );
    }
  }
}

class _ListChatsWidget extends StatefulWidget {
  final TypeChat typeChat;
  final String query;
  final String myId;
  final ChatStore store;
  final void Function(ChatModel) onLongPress;
  final void Function(ChatModel) onPress;

  const _ListChatsWidget({
    Key? key,
    required this.typeChat,
    required this.query,
    required this.myId,
    required this.store,
    required this.onLongPress,
    required this.onPress,
  }) : super(key: key);

  @override
  State<_ListChatsWidget> createState() => _ListChatsWidgetState();
}

class _ListChatsWidgetState extends State<_ListChatsWidget>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      widget.store.loadChats(
        starred: widget.store.starred,
        type: widget.typeChat,
        questChatStatus: widget.typeChat == TypeChat.active
            ? 0
            : widget.typeChat == TypeChat.completed
                ? -1
                : null,
        query: widget.query,
      );
    });
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Observer(
      builder: (_) {
        final chats = widget.store.chats[widget.typeChat]?.chat;
        if (widget.store.isLoading) {
          return SingleChildScrollView(
            child: Column(
              children: List.generate(
                10,
                (index) => const _ShimmerChatItem(),
              ),
            ),
          );
        }
        if (chats?.isNotEmpty ?? false) {
          return NotificationListener<ScrollEndNotification>(
            onNotification: (scrollEnd) {
              final metrics = scrollEnd.metrics;
              if (metrics.maxScrollExtent < metrics.pixels) {
                widget.store.loadChats(
                  loadMore: true,
                  starred: widget.store.starred,
                  type: widget.typeChat,
                  questChatStatus: widget.typeChat == TypeChat.active
                      ? 0
                      : widget.typeChat == TypeChat.completed
                          ? -1
                          : null,
                  query: widget.query,
                );
              }
              return true;
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              clipBehavior: Clip.none,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              child: Observer(builder: (_) {
                return Column(
                  children: chats!.map((chat) {
                    final chatListWidget = _ChatListTileWidget(
                      onLongPress: () => widget.onLongPress(chat),
                      onTap: () => widget.onPress(chat),
                      chat: chat,
                      userId: widget.store.myId,
                      infoActionMessage: "chat.infoMessage."
                              "${chat.chatData.lastMessage?.infoMessage?.messageAction ?? "message"}"
                          .tr(),
                      chatStarred: widget.store.selectedChats[chat]!,
                    );
                    if (widget.store.isLoading && chat == chats.last) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          chatListWidget,
                          SizedBox(
                            height: 5,
                          ),
                          CircularProgressIndicator.adaptive(),
                        ],
                      );
                    }
                    return chatListWidget;
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
          child: Text("chat.chat".tr()),
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
              "Create private chat",
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
  final String infoActionMessage;
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
    final differenceTime = DateTime.now()
        .difference(chat.chatData.lastMessage?.createdAt ?? DateTime.now())
        .inDays;
    Member? member;
    chat.members?.forEach((element) {
      if (element.type != "Admin" || chat.type != TypeChat.active)
        member = element;
    });
    final text = chat.chatData.lastMessage?.sender?.userId == userId
        ? "chat.you".tr() +
            " ${chat.chatData.lastMessage?.text ?? infoActionMessage} "
        : "${chat.chatData.lastMessage?.sender!.user?.firstName ?? member!.user?.firstName ?? member!.admin?.firstName ?? ""}:" +
            " ${chat.chatData.lastMessage?.text ?? infoActionMessage} ";
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
                      child: chat.type != TypeChat.group
                          ? UserAvatar(
                              width: 56,
                              height: 56,
                              url: member!.user?.avatar?.url ??
                                  Constants.defaultImageNetwork,
                            )
                          : Stack(
                              children: [
                                Container(
                                  color: _getRandomColor(chat.id),
                                  height: 56,
                                  width: 56,
                                ),
                                Positioned.fill(
                                  child: Center(
                                    child: Text(
                                      chat.groupChat!.name.length == 1
                                          ? "${chat.groupChat!.name[0].toUpperCase()}"
                                          : "${chat.groupChat!.name[0].toUpperCase()}" +
                                              "${chat.groupChat!.name[1]}",
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
                        Row(
                          children: [
                            Text(
                              chat.type == TypeChat.group
                                  ? "${chat.groupChat!.name}"
                                  : "${member!.user?.firstName ?? member!.admin?.firstName ?? "--"} "
                                      "${member!.user?.lastName ?? member!.admin?.lastName ?? "--"}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: 5),
                            if (chat.type == TypeChat.active ||
                                chat.type == TypeChat.completed)
                              Expanded(
                                child: Text(
                                  "Quest: ${chat.questChat?.quest?.title}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColor.enabledButton,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          text,
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
                      if (chat.chatData.lastMessage?.senderStatus == "Unread")
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
                          margin: chat.chatData.lastMessage?.senderStatus ==
                                  "Unread"
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
