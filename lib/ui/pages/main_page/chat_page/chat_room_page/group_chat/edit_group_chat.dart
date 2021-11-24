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
            IconButton(
              onPressed: () {},
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
                TextFormField(
                  initialValue: store.chat!.chatModel.name,
                  onChanged: (text) => store.setChatName(text),
                  decoration: InputDecoration(
                    hintText: "modals.modals.chatName".tr(),
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
                      itemBuilder: (context, index) => EditUserCell(
                        store.chat!.chatModel.userMembers[index],
                        index,
                        store.chat!.chatModel.userMembers[index].id ==
                            store.chat!.chatModel.ownerUserId,
                      ),
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.black12,
                        endIndent: 50.0,
                        indent: 50.0,
                      ),
                      itemCount: store.chat!.chatModel.userMembers.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
