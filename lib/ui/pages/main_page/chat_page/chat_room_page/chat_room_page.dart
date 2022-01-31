import 'dart:async';

import 'package:app/ui/pages/main_page/chat_page/chat_room_page/group_chat/edit_group_chat.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/input_tool_bar.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/message_cell.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/user_profile_page.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:provider/provider.dart";

class ChatRoomPage extends StatefulWidget {
  static const String routeName = "/chatRoomPage";
  final String idChat;

  ChatRoomPage(this.idChat);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  late final ChatRoomStore _store;
  ProfileMeStore? profile;

  String get id1 => _store.chat?.chatModel.userMembers[0].id ?? "--";

  String get id2 => _store.chat?.chatModel.userMembers[1].id ?? "--";

  String get ownersChatId => _store.chat?.chatModel.ownerUserId ?? "--";

  String get firstName1 =>
      _store.chat?.chatModel.userMembers[0].firstName ?? "--";

  String get lastName1 =>
      _store.chat?.chatModel.userMembers[0].lastName ?? "--";

  String get firstName2 =>
      _store.chat?.chatModel.userMembers[1].firstName ?? "--";

  String get lastName2 =>
      _store.chat?.chatModel.userMembers[1].lastName ?? "--";

  String get url1 =>
      _store.chat?.chatModel.userMembers[0].avatar?.url ??
      "https://workquest-cdn.fra1.digitaloceanspaces.com/sUYNZfZJvHr8fyVcrRroVo8PpzA5RbTghdnP0yEcJuIhTW26A5vlCYG8mZXs";

  String get url2 =>
      _store.chat?.chatModel.userMembers[1].avatar?.url ??
      "https://workquest-cdn.fra1.digitaloceanspaces.com/sUYNZfZJvHr8fyVcrRroVo8PpzA5RbTghdnP0yEcJuIhTW26A5vlCYG8mZXs";

  String get chatType => _store.chat?.chatModel.type ?? "";

  String get chatName => _store.chat?.chatModel.name ?? "--";

  @override
  void initState() {
    _store = context.read<ChatRoomStore>();
    profile = context.read<ProfileMeStore>();
    _store.idChat = widget.idChat;
    _store.getMessages(true);
    super.initState();
    if (_store.chat!.chatModel.type == "group") _store.generateListUserInChat();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        appBar: _store.messageSelected ? _selectedMessages() : _appBar(),
        body: Container(
          alignment: Alignment.bottomLeft,
          height: MediaQuery.of(context).size.height,
          child: Observer(
            builder: (_) => Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Observer(
                    builder: (_) => _store.isLoading
                        ? Center(child: CircularProgressIndicator.adaptive())
                        : NotificationListener<ScrollStartNotification>(
                            onNotification: (scrollStart) {
                              final metrics = scrollStart.metrics;
                              if (metrics.maxScrollExtent < metrics.pixels) {
                                _store.getMessages(true);
                              }
                              return true;
                            },
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(),
                              ),
                              itemCount: _store.chat?.messages.length,
                              itemBuilder: (context, index) => MessageCell(
                                UniqueKey(),
                                _store.chat!.messages[index],
                                profile!.userData!.id,
                                _store,
                              ),
                              reverse: true,
                            ),
                          ),
                  ),
                ),
                InputToolbar(_store, profile!.userData!.id),
                if (_store.media.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 16.0,
                    ),
                    child: _media(),
                  ),
                const SizedBox(
                  height: 16.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _media() {
    return SizedBox(
      height: 150.0,
      child: Observer(
        builder: (_) => ListView.separated(
          separatorBuilder: (_, index) => SizedBox(
            width: 10.0,
          ),
          shrinkWrap: false,
          scrollDirection: Axis.horizontal,
          itemCount: _store.media.length,
          itemBuilder: (_, index) {
            String dataType = _store.media[index].path
                .split("/")
                .reversed
                .first
                .split(".")
                .reversed
                .toList()[0];
            return SizedBox(
              width: 120.0,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  // Media
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Observer(
                        builder: (_) => dataType == "jpeg" ||
                                dataType == "png" ||
                                dataType == "jpg"
                            ? Image.memory(
                                _store.media[index].readAsBytesSync(),
                                fit: BoxFit.cover,
                              )
                            : Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(0xFFE9EDF2),
                                      ),
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        dataType == "mp4" || dataType == "mov"
                                            ? 'assets/play.svg'
                                            : 'assets/document.svg',
                                        color: Color(0xFFAAB0B9),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                        // _store.fileNameBytes == null
                        //         ? CircularProgressIndicator()
                        //         : Image.memory(
                        //             _store.fileNameBytes!,
                        //             fit: BoxFit.cover,
                        //           ),
                        ),
                  ),
                  Positioned(
                    top: -15.0,
                    right: -15.0,
                    child: IconButton(
                      onPressed: () => _store.media.removeAt(index),
                      icon: Icon(Icons.cancel_outlined),
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _selectedMessages() {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Color(0xFF0083C7),
      leading: IconButton(
        onPressed: () {
          _store.setMessageSelected(false);
          _store.uncheck();
        },
        icon: Icon(
          Icons.close,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      title: Observer(
        builder: (_) => Text(
          "${_store.idMessages.length}",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            _store.setStar(true);
            _store.setMessageSelected(false);
            _store.uncheck();
          },
          icon: Icon(
            Icons.star,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {
            Clipboard.setData(
              new ClipboardData(
                text: _store.copyMessage(),
              ),
            ).then(
              (_) {
                SnackBarUtils.success(
                  context,
                  title: "chat.copy".tr(),
                );
              },
            );
            _store.setMessageSelected(false);
            _store.uncheck();
          },
          icon: SvgPicture.asset(
            "assets/copy_icon.svg",
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back_ios_sharp,
        ),
      ),
      centerTitle: true,
      title: Observer(
        builder: (_) => chatType == "group"
            ? Text(
                "$chatName",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              )
            : GestureDetector(
                onTap: () async {
                  _store.getCompanion(profile!.userData!.id != id1 ? id1 : id2);
                  Timer.periodic(Duration(milliseconds: 100), (timer) {
                    if (_store.companion != null) {
                      timer.cancel();
                      Navigator.of(context, rootNavigator: true).pushNamed(
                        UserProfile.routeName,
                        arguments: _store.companion,
                      );
                      _store.companion = null;
                    }
                  });
                },
                child: Text(
                  profile!.userData!.id != id1
                      ? "$firstName1 $lastName1"
                      : "$firstName2 $lastName2",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.fade,
                ),
              ),
      ),
      actions: [
        chatType == "group"
            ? profile!.userData!.id == ownersChatId
                ? IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, EditGroupChat.routeName,
                          arguments: _store);
                    },
                    icon: Icon(Icons.edit),
                  )
                : SizedBox()
            : GestureDetector(
                onTap: () async {
                  _store.getCompanion(profile!.userData!.id != id1 ? id1 : id2);
                  Timer.periodic(Duration(milliseconds: 100), (timer) {
                    if (_store.companion != null) {
                      timer.cancel();
                      Navigator.of(context, rootNavigator: true).pushNamed(
                        UserProfile.routeName,
                        arguments: _store.companion,
                      );
                      _store.companion = null;
                    }
                  });
                },
                child: Observer(
                  builder: (_) => CircleAvatar(
                    backgroundImage: NetworkImage(
                      profile!.userData!.id != id1 ? url1 : url2,
                    ),
                    maxRadius: 20,
                  ),
                ),
              ),
        const SizedBox(width: 16),
      ],
    );
  }
}
