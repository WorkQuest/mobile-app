import 'package:app/enums.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/group_chat/edit_group_chat.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/input_tool_bar.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/message_cell.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart';
import 'package:app/ui/pages/main_page/chat_page/store/chat_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/choose_quest.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/create_review_page/create_review_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/user_profile_page.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/login_button.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:provider/provider.dart";

import '../../../../widgets/media_upload/media_upload_widget.dart';

class ChatRoomPage extends StatefulWidget {
  static const String routeName = "/chatRoomPage";
  final String idChat;

  ChatRoomPage(this.idChat);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  late final ChatRoomStore _store;
  ChatStore? _chatStore;
  final String defaultImageUrl =
      "https://workquest-cdn.fra1.digitaloceanspaces.com/sUYNZfZJvHr8fyVcrRroVo8PpzA5RbTghdnP0yEcJuIhTW26A5vlCYG8mZXs";
  ProfileMeStore? profile;
  String? id1;
  String? id2;
  String? ownersChatId;
  String? firstName1;
  String? lastName1;
  String? firstName2;
  String? lastName2;
  String? url1;
  String? url2;
  String? chatType;
  String? chatName;
  UserRole? role1;
  UserRole? role2;

  @override
  void initState() {
    super.initState();
    _store = context.read<ChatRoomStore>();
    profile = context.read<ProfileMeStore>();
    _chatStore = context.read<ChatStore>();
    _store.idChat = widget.idChat;
    _store.getMessages(true);
    id1 = _store.chat?.chatModel.userMembers[0].id ?? "--";
    ownersChatId = _store.chat?.chatModel.ownerUserId ?? "--";
    firstName1 = _store.chat?.chatModel.userMembers[0].firstName ?? "--";
    lastName1 = _store.chat?.chatModel.userMembers[0].lastName ?? "--";
    url1 = _store.chat?.chatModel.userMembers[0].avatar?.url ?? defaultImageUrl;
    chatType = _store.chat?.chatModel.type ?? "";
    chatName = _store.chat?.chatModel.name ?? "--";
    role1 = _store.chat?.chatModel.userMembers[0].role;

    if (_store.chat!.chatModel.type == "group")
      _store.generateListUserInChat();
    else {
      id2 = _store.chat?.chatModel.userMembers[1].id ?? "--";
      firstName2 = _store.chat?.chatModel.userMembers[1].firstName ?? "--";
      lastName2 = _store.chat?.chatModel.userMembers[1].lastName ?? "--";
      url2 =
          _store.chat?.chatModel.userMembers[1].avatar?.url ?? defaultImageUrl;
      role2 = _store.chat?.chatModel.userMembers[1].role;
    }
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
                        ? Center(
                            child: CircularProgressIndicator.adaptive(),
                          )
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
                              ),
                              reverse: true,
                            ),
                          ),
                  ),
                ),
                _store.chat!.chatModel.questChat?.questChatInfo?.status != 5
                    ? InputToolbar(_store, profile!.userData!.id)
                    : profile!.userData!.role == UserRole.Employer
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: LoginButton(
                              title: "quests.addToQuest".tr(),
                              onTap: () async {
                                await _store.getCompanion(
                                  profile!.userData!.id != id1 ? id1! : id2!,
                                );
                                await Navigator.of(context, rootNavigator: true)
                                    .pushNamed(
                                  ChooseQuest.routeName,
                                  arguments: ChooseQuestArguments(
                                    workerId: _store.companion!.id,
                                    workerAddress:
                                        _store.companion!.walletAddress!,
                                  ),
                                );
                              },
                            ),
                          )
                        : SizedBox(),
                if (_store.progressImages.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 16.0,
                    ),
                    child: Container(
                      height: 250,
                      child: ListMediaView(
                        store: _store,
                      ),
                    ),
                    // _media(),
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
      title: chatType == "group"
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
                Navigator.of(context, rootNavigator: true).pushNamed(
                  UserProfile.routeName,
                  arguments: ProfileArguments(
                    role: profile!.userData!.role != role1! ? role1! : role2!,
                    userId: profile!.userData!.id != id1! ? id1! : id2!,
                  ),
                );
                _store.companion = null;
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
                  Navigator.of(context, rootNavigator: true).pushNamed(
                    UserProfile.routeName,
                    arguments: ProfileArguments(
                      role: profile!.userData!.role != role1! ? role1! : role2!,
                      userId: profile!.userData!.id != id1! ? id1! : id2!,
                    ),
                  );
                  _store.companion = null;
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    profile!.userData!.id != id1! ? url1! : url2!,
                  ),
                  maxRadius: 20,
                ),
              ),
        chatType == "group" && ownersChatId != profile!.userData!.id
            ? PopupMenuButton<String>(
                elevation: 10,
                icon: Icon(Icons.more_vert),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                onSelected: (value) async {
                  switch (value) {
                    case "Leave from chat":
                      await _store.leaveFromChat();
                      if (_store.isSuccess) {
                        await _chatStore!.loadChats(true, false);
                        Navigator.pop(context);
                        AlertDialogUtils.showSuccessDialog(context);
                      }
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {
                    "Leave from chat",
                  }.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(
                        choice.tr(),
                      ),
                    );
                  }).toList();
                },
              )
            : const SizedBox(width: 16),
        _store.chat!.chatModel.questChat?.questChatInfo?.quest?.openDispute !=
                null
            ? PopupMenuButton<String>(
                elevation: 10,
                icon: Icon(Icons.more_vert),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                onSelected: (value) async {
                  switch (value) {
                    case "Add review to the arbiter":
                      await Navigator.pushNamed(
                        context,
                        CreateReviewPage.routeName,
                        arguments: ReviewArguments(null, "dispute id"),
                      );
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {
                    "Add review to the arbiter",
                  }.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(
                        choice.tr(),
                      ),
                    );
                  }).toList();
                },
              )
            : const SizedBox(width: 16),
      ],
    );
  }
}
