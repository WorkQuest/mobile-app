import 'package:app/enums.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/choose_quest/choose_quest_page.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditUserCell extends StatefulWidget {
  final ProfileMeResponse user;
  final bool? owner;
  final ChatRoomStore store;
  final UserRole ownerRole;

  const EditUserCell(
    this.user,
    this.owner,
    this.store,
    this.ownerRole,
  );

  @override
  _EditUserCellState createState() => _EditUserCellState();
}

class _EditUserCellState extends State<EditUserCell> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.network(
            widget.user.avatar?.url ??
                "https://workquest-cdn.fra1.digitaloceanspaces.com/sUYNZfZJvHr8fyVcrRroVo8PpzA5RbTghdnP0yEcJuIhTW26A5vlCYG8mZXs",
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Text(
            "${widget.user.firstName} ${widget.user.lastName}",
            style: TextStyle(fontSize: 18.0),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        widget.owner ?? false
            ? Text(
                "chat.owner".tr(),
              )
            : widget.ownerRole == UserRole.Worker
                ? Observer(
                    builder: (_) => widget.store.userInChat[widget.user.id]!
                        ? IconButton(
                            onPressed: () {
                              widget.store.deleteUser(widget.user);
                              widget.store.userInChat[widget.user.id] = false;
                            },
                            icon: SvgPicture.asset(
                              "assets/minus_icon.svg",
                              color: Color(0xFFDF3333),
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              widget.store.undeletingUser(widget.user);
                              widget.store.userInChat[widget.user.id] = true;
                            },
                            icon: SvgPicture.asset(
                              "assets/plus_icon.svg",
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                  )
                : PopupMenuButton<String>(
                    elevation: 10,
                    icon: Icon(Icons.more_vert),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    onSelected: (value) async {
                      switch (value) {
                        case "Give a quest":
                          await Navigator.of(context, rootNavigator: true)
                              .pushNamed(
                            ChooseQuestPage.routeName,
                            arguments: ChooseQuestArguments(
                              workerId: widget.user.id,
                              workerAddress: null,
                            ),
                          );
                          break;
                        case "Remove from the chat":
                          await AlertDialogUtils.showAlertDialog(
                            context,
                            title: Text("Warning"),
                            content: Padding(
                              padding: const EdgeInsets.only(
                                left: 25.0,
                                top: 16.0,
                                right: 25.0,
                              ),
                              child: Text(
                                "Remove ${widget.user.firstName} "
                                "${widget.user.lastName} from the chat?",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            needCancel: true,
                            titleCancel: "Cancel",
                            titleOk: "Ok",
                            onTabCancel: null,
                            onTabOk: () async {
                              widget.store.deleteUser(widget.user);
                              await widget.store.removeUserFromChat();
                              if (widget.store.isSuccess) {
                                Navigator.pop(context);
                                await AlertDialogUtils.showSuccessDialog(
                                    context);
                              }
                            },
                            colorCancel: Colors.blue,
                            colorOk: Colors.red,
                          );
                          break;
                        default:
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return {
                        "Give a quest",
                        "Remove from the chat",
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
}
