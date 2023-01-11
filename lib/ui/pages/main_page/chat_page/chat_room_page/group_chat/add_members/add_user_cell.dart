import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class AddUserCell extends StatefulWidget {
  final ProfileMeResponse user;
  final int index;
  final ChatRoomStore store;

  const AddUserCell(this.user, this.index, this.store);

  @override
  _AddUserCellState createState() => _AddUserCellState();
}

class _AddUserCellState extends State<AddUserCell> {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => CheckboxListTile(
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                widget.user.avatar?.url ??
                    "https://workquest-cdn.fra1.digitaloceanspaces.com/sUYNZfZJvHr8fyVcrRroVo8PpzA5RbTghdnP0yEcJuIhTW26A5vlCYG8mZXs",
                width: 32,
                height: 32,
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
          ],
        ),
        value: widget.store.selectedUsers[widget.index],
        onChanged: (value) {
          widget.store.selectedUsers[widget.index] = value!;
          widget.store.selectUser(widget.index);
        },
        // controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}
