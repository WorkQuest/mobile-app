import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/edit_chat_page/store/edit_chat_store.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/edit_chat_page/widgets/add_members.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/edit_chat_page/widgets/edit_user_cell.dart';
import 'package:app/ui/widgets/dismiss_keyboard.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';

class EditChatPage extends StatelessWidget {
  static const String routeName = "/editChatPage";

  final ChatModel chat;

  const EditChatPage(this.chat);

  @override
  Widget build(BuildContext context) {
    final store = context.read<EditChatStore>();
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
                      Navigator.pushNamed(
                        context,
                        AddMembers.routeName,
                        arguments: chat.id,
                      );
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
                const SizedBox(height: 5.0),
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
                            chat.groupChat!.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Observer(
                  builder: (_) => store.isLoading
                      ? Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) => EditUserCell(
                              chat.members![index],
                              chat,
                            ),
                            separatorBuilder: (context, index) => const Divider(
                              color: Colors.black12,
                              endIndent: 50.0,
                              indent: 50.0,
                            ),
                            itemCount: chat.members!.length,
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
