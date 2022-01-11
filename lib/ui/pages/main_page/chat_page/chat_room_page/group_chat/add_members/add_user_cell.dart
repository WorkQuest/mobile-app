import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart';
import 'package:app/ui/widgets/running_line.dart';
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
    return Container(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(
              widget.user.avatar!.url,
              width: 32,
              height: 32,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: SizedBox(
              height: 20,
              child: RunningLine(
                children: [
                  Text(
                    "${widget.user.firstName} ${widget.user.lastName}",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ),
          ),
          Observer(
            builder: (_) => Container(
              width: 30.0,
              child: Checkbox(
                value: widget.store.selectedUsers[widget.index],
                onChanged: (value) {
                  widget.store.selectedUsers[widget.index] = value!;
                  widget.store.selectUser(widget.index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
