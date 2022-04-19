import 'package:app/ui/pages/main_page/chat_page/chat_room_page/chat_room_page.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/group_chat/add_members/add_user_cell.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart';
import 'package:app/ui/widgets/dismiss_keyboard.dart';
import 'package:app/utils/alert_dialog.dart';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

final _spacer = Spacer();

class CreateGroupPage extends StatelessWidget {
  static const String routeName = "/createGroupPage";

  const CreateGroupPage(this.myId);

  final String myId;

  @override
  Widget build(BuildContext context) {
    final store = context.read<ChatRoomStore>();
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_sharp,
            ),
          ),
          centerTitle: true,
          title: Text(
            "modals.modals.title".tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Observer(
            builder: (_) => IndexedStack(
              index: store.index,
              children: [
                addName(store, context),
                addUser(store, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addName(ChatRoomStore store, BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "modals.modals.enterName".tr(),
            style: TextStyle(
              color: Color(0xFF7C838D),
              fontSize: 14.0,
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Text(
            "modals.modals.chatName".tr(),
          ),
          const SizedBox(
            height: 5.0,
          ),
          TextFormField(
            onChanged: (text) => store.setChatName(text),
            decoration: InputDecoration(
              hintText: "modals.modals.enterName".tr(),
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: BorderSide(
                  color: Colors.blue,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: BorderSide(
                  color: Color(0xFFf7f8fa),
                  width: 2.0,
                ),
              ),
            ),
          ),
          _spacer,
          buttonRow(
            store,
            forward: "meta.next".tr(),
            back: "meta.cancel".tr(),
            context: context,
          ),
        ],
      );

  Widget addUser(ChatRoomStore store, BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            onChanged: (text) => store.findUser(text),
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
                size: 25.0,
                color: Color(0xFF0083C7),
              ),
              hintText: "modals.modals.enterUserName".tr(),
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: BorderSide(
                  color: Colors.blue,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: BorderSide(
                  color: Color(0xFFf7f8fa),
                  width: 2.0,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Expanded(
            child: Observer(
              builder: (_) => ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.black12,
                  endIndent: 50.0,
                  indent: 50.0,
                ),
                itemCount:
                    store.foundUsers.length == 0 && store.userName.isEmpty
                        ? store.availableUsers.length
                        : store.foundUsers.length,
                itemBuilder: (context, index) => AddUserCell(
                    store.foundUsers.isEmpty && store.userName.isEmpty
                        ? store.availableUsers[index]
                        : store.foundUsers[index],
                    index,
                    store),
              ),
            ),
          ),
          buttonRow(
            store,
            forward: "profiler.create".tr(),
            back: "meta.back".tr(),
            context: context,
          ),
        ],
      );

  Widget buttonRow(
    ChatRoomStore store, {
    required String forward,
    required String back,
    required BuildContext context,
  }) =>
      Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 45.0,
              child: OutlinedButton(
                onPressed: () {
                  if (store.index == 0)
                    Navigator.popUntil(
                      context,
                      (route) => route.isFirst,
                    );
                  if (store.index == 1) store.index--;
                },
                child: Text(back),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    width: 1.0,
                    color: Color(0xFF0083C7).withOpacity(0.1),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Observer(
              builder: (_) => ElevatedButton(
                onPressed: store.index == 0 &&
                        store.chatName.isNotEmpty &&
                        !store.isLoading
                    ? () async {
                        if (store.index == 0) {
                          store.index++;
                          await store.getUsersForGroupCHat();
                          if (store.availableUsers.isEmpty)
                            AlertDialogUtils.showAlertDialog(
                              context,
                              title: Text("Error"),
                              content: Padding(
                                padding: const EdgeInsets.only(
                                  left: 25.0,
                                  top: 16,
                                ),
                                child: Text(
                                  "You can't create a chat before"
                                  "\nworking on a quest",
                                ),
                              ),
                              needCancel: false,
                              titleCancel: null,
                              titleOk: "Return",
                              onTabCancel: null,
                              onTabOk: () => Navigator.pop(context),
                              colorCancel: null,
                              colorOk: Colors.blue,
                            );
                        }
                      }
                    : store.usersId.isNotEmpty &&
                            store.usersId.length > 1 &&
                            !store.isLoading &&
                            store.index == 1
                        ? () async {
                            await store.createGroupChat();
                            if (store.isSuccess) {
                              Navigator.of(context, rootNavigator: true)
                                  .pushReplacementNamed(ChatRoomPage.routeName,
                                      arguments: store.idGroupChat);
                            }
                          }
                        : null,
                child: store.isLoading
                    ? Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : Text(forward),
              ),
            ),
          ),
        ],
      );
}
