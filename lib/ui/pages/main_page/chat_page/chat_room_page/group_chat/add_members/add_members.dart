import 'package:app/ui/pages/main_page/chat_page/chat_room_page/group_chat/add_members/add_user_cell.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart';
import 'package:app/ui/widgets/dismiss_keyboard.dart';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class AddMembers extends StatelessWidget {
  static const String routeName = "/addMembers";

  final ChatRoomStore store;

  const AddMembers(this.store);

  @override
  Widget build(BuildContext context) {
    store.availableUsersForAdding(store.chat!.chatModel.userMembers);
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
            "chat.addMembers".tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
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
                    shrinkWrap: true,
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
                      store,
                    ),
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
          ),
        ),
      ),
    );
  }

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
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "meta.cancel".tr(),
                ),
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
                onPressed: store.usersId.isNotEmpty
                    ? () async {
                        await store.addUsersInChat();
                        store.getMessages(true);
                        if (!store.isLoading) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      }
                    : null,
                child: store.isLoading
                    ? Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : Text(
                        "meta.save".tr(),
                      ),
              ),
            ),
          ),
        ],
      );
}
