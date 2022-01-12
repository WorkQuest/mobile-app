import 'package:app/ui/pages/main_page/chat_page/chat_room_page/group_chat/add_members/add_members.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/group_chat/edit_user_cell.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';

class EditGroupChat extends StatelessWidget {
  static const String routeName = "/editPageChat";

  final ChatRoomStore store;

  const EditGroupChat(this.store);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
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
            "modals.modals.edit".tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          actions: [
            store.isLoading
                ? SizedBox()
                : IconButton(
                    onPressed: () async {
                      // store.usersId.clear();
                      await store.getUsersForGroupCHat();
                      Navigator.pushNamed(context, AddMembers.routeName,
                          arguments: store);
                    },
                    icon: SvgPicture.asset(
                      "assets/plus_icon.svg",
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
            const SizedBox(width: 16),
          ],
        ),
        body: Container(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "modals.modals.chatName".tr(),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Container(
                  height: 50,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFF7F8FA),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(6.0),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Flexible(
                          child: Text(
                            store.chat!.chatModel.name!,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Observer(
                  builder: (_) => store.isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Expanded(
                          child: Observer(
                            builder: (_) => ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (context, index) => EditUserCell(
                                store.chat!.chatModel.userMembers[index],
                                store.chat!.chatModel.userMembers[index].id ==
                                    store.chat!.chatModel.ownerUserId,
                                store,
                              ),
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                color: Colors.black12,
                                endIndent: 50.0,
                                indent: 50.0,
                              ),
                              itemCount:
                                  store.chat!.chatModel.userMembers.length,
                            ),
                          ),
                        ),
                ),
                buttonRow(store, context: context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonRow(
    ChatRoomStore store, {
    required BuildContext context,
  }) =>
      Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 45.0,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
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
                onPressed: () {
                  store.removeUserFromChat();
                  if (!store.isLoading) {
                    store.getMessages(true);
                    Navigator.pop(context);
                  }
                },
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
