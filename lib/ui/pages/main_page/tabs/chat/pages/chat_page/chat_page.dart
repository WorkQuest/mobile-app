import 'dart:async';
import 'package:app/constants.dart';
import 'package:app/enums.dart';
import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/chat_page/widgets/app_bar_widget.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/create_group_page/create_group_page.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/chat_page/widgets/list_chats_widget.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/chat_page/widgets/selected_app_bar_widget.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/chat_page/store/chat_store.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/starred_messages_page/starred_message_page.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import '../../../../../../widgets/default_textfield.dart';
import '../chat_room_page/chat_room_page.dart';
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
    _tabController = TabController(vsync: this, length: 6)
      ..addListener(() {
        store.setChatType(_tabController.index);
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
    store.setMyId(context.read<ProfileMeStore>().userData?.id ?? '');
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
                          builder: (_) => SelectedAppBarWidget(
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
                          builder: (_) => AppBarWidget(
                            onSelected: (value) {
                              switch (value) {
                                case "chat.starredMessage":
                                  Navigator.of(context, rootNavigator: true)
                                      .pushNamed(
                                    StarredMessagePage.routeName,
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
                    tab(text: 'chat.tabs.all'),
                    tab(text: 'chat.tabs.privates'),
                    tab(text: 'chat.tabs.group'),
                    tab(text: 'chat.tabs.active'),
                    tab(text: 'chat.tabs.completed'),
                    tab(text: 'chat.tabs.favorite'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ListChatsWidget(
                        typeChat: TypeChat.all,
                        query: _searchTextController.text,
                        store: store,
                        onLongPress: onLongPress,
                        onPress: onPress,
                      ),
                      ListChatsWidget(
                        typeChat: TypeChat.privates,
                        query: _searchTextController.text,
                        store: store,
                        onLongPress: onLongPress,
                        onPress: onPress,
                      ),
                      ListChatsWidget(
                        typeChat: TypeChat.group,
                        query: _searchTextController.text,
                        store: store,
                        onLongPress: onLongPress,
                        onPress: onPress,
                      ),
                      ListChatsWidget(
                        typeChat: TypeChat.active,
                        query: _searchTextController.text,
                        store: store,
                        onLongPress: onLongPress,
                        onPress: onPress,
                      ),
                      ListChatsWidget(
                        typeChat: TypeChat.completed,
                        query: _searchTextController.text,
                        store: store,
                        onLongPress: onLongPress,
                        onPress: onPress,
                      ),
                      ListChatsWidget(
                        typeChat: TypeChat.favourites,
                        query: _searchTextController.text,
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
          chat.chatData.lastMessage?.senderStatus == "Unread")
        store.setMessageRead(
          chat.id,
          chat.chatData.lastMessageId,
        );
      Navigator.of(context, rootNavigator: true).pushNamed(
        ChatRoomPage.routeName,
        arguments: ChatRoomArguments(chat.id, false),
      );
    }
  }
}
