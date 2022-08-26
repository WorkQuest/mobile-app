import 'package:app/enums.dart';
import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/chat_page/widgets/chat_cell.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/chat_page/store/chat_store.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/chat_page/widgets/shimmer/shimmer_chat_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

class ListChatsWidget extends StatefulWidget {
  final TypeChat typeChat;
  final String query;
  final ChatStore store;
  final void Function(ChatModel) onLongPress;
  final void Function(ChatModel) onPress;

  const ListChatsWidget({
    Key? key,
    required this.typeChat,
    required this.query,
    required this.store,
    required this.onLongPress,
    required this.onPress,
  }) : super(key: key);

  @override
  State<ListChatsWidget> createState() => _ListChatsWidgetState();
}

class _ListChatsWidgetState extends State<ListChatsWidget>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = ScrollController();

  late String id;

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
              children: List.generate(10, (index) => const ShimmerChatItem()),
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
                    final infoMessage = "chat.infoMessage."
                            "${chat.chatData.lastMessage?.infoMessage?.messageAction ?? chat.meMember?.deletionData?.message.infoMessage?.messageAction ?? "message"}"
                        .tr();
                    final chatListWidget = ChatCell(
                      onLongPress: () => widget.onLongPress(chat),
                      onTap: () => widget.onPress(chat),
                      chat: chat,
                      userId: widget.store.myId,
                      infoActionMessage: infoMessage,
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
                const SizedBox(height: 15),
                SvgPicture.asset("assets/empty_quest_icon.svg"),
                const SizedBox(height: 10),
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
