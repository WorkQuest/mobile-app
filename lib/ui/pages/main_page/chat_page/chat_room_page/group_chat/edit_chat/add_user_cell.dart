import 'package:app/constants.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class AddUserCell<T> extends StatefulWidget {
  final ProfileMeResponse user;
  final int index;
  final T store;
  final bool isGroupChat;

  const AddUserCell(
    this.user,
    this.index,
    this.store,
    this.isGroupChat,
  );

  @override
  _AddUserCellState createState() => _AddUserCellState();
}

class _AddUserCellState extends State<AddUserCell> {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => widget.isGroupChat
          ? CheckboxListTile(
              title: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      widget.user.avatar?.url ?? Constants.defaultImageNetwork,
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Text(
                      "${widget.user.firstName} ${widget.user.lastName}",
                      style: TextStyle(fontSize: 18.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              value: widget.store.users[widget.user],
              onChanged: (value) => widget.store.users[widget.user] = value!,
            )
          : RadioListTile<String>(
              title: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      widget.user.avatar?.url ?? Constants.defaultImageNetwork,
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Text(
                      "${widget.user.firstName} ${widget.user.lastName}",
                      style: TextStyle(fontSize: 18.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              value: widget.user.id!,
              onChanged: (value) {
                widget.store.setUserId(widget.user.id!);
              },
              groupValue: widget.store.userId,
              contentPadding: EdgeInsets.zero,
            ),
    );
  }
}
