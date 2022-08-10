import 'package:app/constants.dart';
import 'package:app/enums.dart';
import 'package:app/model/chat_model/member.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/group_chat/edit_chat/edit_chat_page.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/input_tool_bar.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/message_cell.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart';
import 'package:app/ui/pages/main_page/chat_page/store/chat_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/choose_quest/choose_quest_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/create_review_page/create_review_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/user_profile_page.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/login_button.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/quest_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import "package:provider/provider.dart";

import '../../../../../utils/snack_bar.dart';
import '../../../../widgets/media_upload/media_upload_widget.dart';

class ChatRoomPage extends StatefulWidget {
  static const String routeName = "/chatRoomPage";
  final ChatRoomArguments arguments;

  ChatRoomPage(this.arguments);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  late final ChatRoomStore _store;
  ChatStore? _chatStore;
  ProfileMeStore? profile;

  String? id1;
  String? id2;
  String? firstName1;
  String? lastName1;
  String? firstName2;
  String? lastName2;
  String? url1;
  String? url2;
  TypeChat? chatType;
  String? chatName;
  UserRole? role1;
  UserRole? role2;
  bool meMember = false;

  @override
  void initState() {
    super.initState();
    _store = context.read<ChatRoomStore>();
    profile = context.read<ProfileMeStore>();
    _chatStore = context.read<ChatStore>();
    _store.idChat = widget.arguments.chatId;
    _store.getMessages(chatId: _store.idChat!).then((value) {
      chatType = _store.chatRoom?.type;
      List<Member> members = _store.chatRoom!.members!;
      members.forEach((element) {
        if (element.userId == profile!.userData!.id) meMember = true;
      });

      if (chatType == TypeChat.group) {
        _store.getOwnerId();
        chatName = _store.chatRoom!.groupChat?.name ?? "--";
      } else {
        if (_store.chatRoom?.questChat?.quest?.openDispute != null) {
          _store.getQuest(_store.chatRoom!.questChat!.quest!.id);
          _store.getDispute(_store.chatRoom!.questChat!.quest!.openDispute!.id);
        }
        if (members.length > 2) members.removeWhere((element) => element.type == "Admin");
        id1 = members[0].userId;
        firstName1 = members[0].user!.firstName;
        lastName1 = members[0].user!.lastName;
        url1 = members[0].user!.avatar?.url ?? Constants.defaultImageNetwork;
        id2 = members[1].userId;
        firstName2 = members[1].user?.firstName ?? members[1].admin!.firstName;
        lastName2 = members[1].user?.lastName ?? members[1].admin!.lastName;
        url2 = members[1].user?.avatar?.url ?? Constants.defaultImageNetwork;
        if (_store.chatRoom?.questChat != null)
          role1 = _store.chatRoom!.members![0].user!.role;
        role2 = _store.chatRoom!.members![1].user?.role ?? UserRole.Admin;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('_store.chatRoom!.questChat: ${_store.chatRoom!.questChat?.toJson()}');
    return Observer(
      builder: (_) => _store.initPage || _store.isLoading
          ? Scaffold(
              body: Center(child: CircularProgressIndicator.adaptive()),
            )
          : Scaffold(
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
                        child: NotificationListener<ScrollStartNotification>(
                          onNotification: (scrollStart) {
                            final metrics = scrollStart.metrics;
                            if (metrics.maxScrollExtent < metrics.pixels &&
                                !_store.loadMessage) {
                              _store.getMessages(chatId: _store.idChat!);
                            }
                            return true;
                          },
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics(),
                            ),
                            itemCount: _store.messages.length,
                            itemBuilder: (context, index) => MessageCell(
                              UniqueKey(),
                              _store.messages[index],
                              profile!.userData!.id,
                              _store.mediaPaths,
                            ),
                            reverse: true,
                          ),
                        ),
                      ),
                      _store.chatRoom!.questChat?.status != -1 &&
                              (_store.chatRoom!.meMember?.status == 0 || meMember)
                          ? InputToolbar(_store)
                          : profile!.userData!.role == UserRole.Employer &&
                                  _store.chatRoom!.questChat != null &&
                                  _store.chatRoom!.questChat!.status !=
                                      QuestConstants.questRejected
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: LoginButton(
                                    title: "quests.addToQuest".tr(),
                                    onTap: () async {
                                      await Navigator.of(
                                        context,
                                        rootNavigator: true,
                                      ).pushNamed(
                                        ChooseQuestPage.routeName,
                                        arguments:
                                            profile!.userData!.id != id1 ? id1! : id2!,
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
                        ),
                      const SizedBox(height: 16.0),
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
          _store.resetSelectedMessages();
        },
        icon: Icon(
          Icons.close,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      title: Observer(
        builder: (_) => Text(
          "${_store.getCountStarredChats()}",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: _store.setStar,
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
            _store.resetSelectedMessages();
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
      title: chatType == TypeChat.group
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
        chatType == TypeChat.group
            ? profile!.userData!.id == _store.ownerId
                ? IconButton(
                    onPressed: () async {
                      await Navigator.pushNamed(
                        context,
                        EditChatPage.routeName,
                        arguments: _store.chatRoom,
                      );
                      await _store.getMessages(
                        chatId: _store.idChat!,
                        newList: true,
                      );
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
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    profile!.userData!.id != id1! ? url1! : url2!,
                  ),
                  maxRadius: 20,
                ),
              ),
        chatType == TypeChat.group && _store.ownerId != profile!.userData!.id
            ? PopupMenuButton<String>(
                elevation: 10,
                icon: Icon(Icons.more_vert),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                onSelected: (value) async {
                  switch (value) {
                    case "chat.leaveFromChat":
                      await _store.leaveFromChat();
                      if (_store.isSuccess) {
                        await _chatStore!.loadChats(starred: false);
                        Navigator.pop(context);
                        AlertDialogUtils.showSuccessDialog(context);
                      }
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {
                    "chat.leaveFromChat",
                  }.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice.tr()),
                    );
                  }).toList();
                },
              )
            : const SizedBox(width: 16),
        _store.dispute?.currentUserDisputeReview == null &&
                _store.chatRoom?.questChat?.quest?.openDispute?.status == 4
            ? PopupMenuButton<String>(
                elevation: 10,
                icon: Icon(Icons.more_vert),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                onSelected: (value) async {
                  switch (value) {
                    case "chat.addReviewArbiter":
                      await Navigator.pushNamed(
                        context,
                        CreateReviewPage.routeName,
                        arguments: CreateReviewArguments(
                          null,
                          _store.chatRoom!.questChat?.quest?.openDispute!.id,
                        ),
                      );
                      await _store.getMessages(
                        chatId: _store.chatRoom!.chatData.chatId,
                      );
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {
                    "chat.addReviewArbiter",
                  }.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice.tr()),
                    );
                  }).toList();
                },
              )
            : const SizedBox(width: 16),
      ],
    );
  }
}

class ChatRoomArguments {
  ChatRoomArguments(this.chatId, this.refreshChat);

  final String chatId;
  final bool refreshChat;
}
