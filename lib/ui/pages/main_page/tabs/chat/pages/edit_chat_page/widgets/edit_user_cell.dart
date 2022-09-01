import 'package:app/constants.dart';
import 'package:app/enums.dart';
import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/model/chat_model/member.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/chat_page/store/chat_store.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/create_private_chat/create_private_page.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/edit_chat_page/store/edit_chat_store.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/profile_details/pages/choose_quest_page/choose_quest_page.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class EditUserCell extends StatefulWidget {
  final Member user;
  final ChatModel chat;

  const EditUserCell(
    this.user,
    this.chat,
  );

  @override
  _EditUserCellState createState() => _EditUserCellState();
}

class _EditUserCellState extends State<EditUserCell> {
  late EditChatStore store;
  late ChatStore chatStore;
  late ProfileMeStore profileStore;

  @override
  void initState() {
    store = context.read<EditChatStore>();
    chatStore = context.read<ChatStore>();
    store.getChatMembers(widget.chat.members!);
    profileStore = context.read<ProfileMeStore>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.network(
            widget.user.user!.avatar?.url ?? Constants.defaultImageNetwork,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Text(
            "${widget.user.user!.firstName} ${widget.user.user!.lastName}",
            style: TextStyle(fontSize: 18.0),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        profileStore.userData!.id == widget.user.userId
            ? Text("chat.owner".tr())
            : PopupMenuButton<String>(
                elevation: 10,
                icon: Icon(Icons.more_vert),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                onSelected: (value) async {
                  if (profileStore.userData!.role == UserRole.Employer &&
                      widget.user.user!.role == UserRole.Worker)
                    employerMenu(
                      value,
                    );
                  else
                    workerMenu(value);
                },
                itemBuilder: (BuildContext context) {
                  return {
                    if (profileStore.userData!.role == UserRole.Employer)
                      "chat.giveQuest",
                    "chat.privateChat",
                    "chat.removeFromChat",
                  }.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice.tr()),
                    );
                  }).toList();
                },
              ),
      ],
    );
  }

  Future<void> workerMenu(String value) async {
    switch (value) {
      case "chat.privateChat":
        await Navigator.of(context, rootNavigator: true).pushNamed(
          CreatePrivatePage.routeName,
          arguments: widget.user.userId,
        );
        break;
      case "chat.removeFromChat":
        await AlertDialogUtils.showAlertDialog(
          context,
          title: Text("modals.warning".tr()),
          content: Padding(
            padding: const EdgeInsets.only(
              left: 25.0,
              top: 16.0,
              right: 25.0,
            ),
            child: Text(
              "chat.quesRemoveFromChat".tr(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          needCancel: true,
          titleCancel: "meta.cancel".tr(),
          titleOk: "Ok",
          onTabCancel: null,
          onTabOk: () async {
            await store.removeUser(
              widget.chat.id,
              widget.user.userId!,
            );
            if (store.isSuccess) {
              widget.chat.members!.remove(widget.user);
              chatStore.chats.forEach((key, chats) {
                chats.chat.forEach((chat) {
                  if (chat.id == widget.chat.id) {
                    store.setNewMessage(widget.chat, profileStore.userData!);
                    chat.chatData.lastMessage = store.newMessage;
                    chatStore.chats[key]!.chat.remove(chat);
                    chatStore.chats[key]!.chat.insert(0, chat);
                  }
                });
              });
            }
          },
          colorCancel: Colors.blue,
          colorOk: Colors.red,
        );
        break;
      default:
    }
  }

  Future<void> employerMenu(String value) async {
    switch (value) {
      case "chat.giveQuest":
        await Navigator.of(context, rootNavigator: true).pushNamed(
          ChooseQuestPage.routeName,
          arguments: widget.user.userId!,
        );
        break;
      case "chat.privateChat":
        await Navigator.of(context, rootNavigator: true).pushNamed(
          CreatePrivatePage.routeName,
          arguments: widget.user.userId,
        );
        break;
      case "chat.removeFromChat":
        await AlertDialogUtils.showAlertDialog(
          context,
          title: Text("modals.warning".tr()),
          content: Padding(
            padding: const EdgeInsets.only(
              left: 25.0,
              top: 16.0,
              right: 25.0,
            ),
            child: Text(
              "chat.quesRemoveFromChat".tr(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          needCancel: true,
          titleCancel: "meta.cancel".tr(),
          titleOk: "Ok",
          onTabCancel: null,
          onTabOk: () async {
            await store.removeUser(
              widget.chat.id,
              widget.user.userId!,
            );
            if (store.isSuccess) {
              widget.chat.members!.remove(widget.user);
              chatStore.chats.forEach((key, chats) {
                chats.chat.forEach((chat) {
                  if (chat.id == widget.chat.id) {
                    store.setNewMessage(widget.chat, profileStore.userData!);
                    chat.chatData.lastMessage = store.newMessage;
                    chatStore.chats[key]!.chat.remove(chat);
                    chatStore.chats[key]!.chat.insert(0, chat);
                  }
                });
              });
            }
          },
          colorCancel: Colors.blue,
          colorOk: Colors.red,
        );
        break;
      default:
    }
  }
}