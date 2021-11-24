import 'package:app/model/chat_model/message_model.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageCell extends StatefulWidget {

  final LocalKey key;
  final MessageModel mess;
  final String userId;
  final int index;

  MessageCell(this.key, this.mess, this.userId, this.index);

  @override
  _MessageCellState createState() => _MessageCellState();
}

class _MessageCellState extends State<MessageCell> {
  late ChatRoomStore store;

  @override
  void initState() {
    store = context.read<ChatRoomStore>();
    // store.setLists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // if (store.messageSelected) {
        //   store.setStar();
        // }
      },
      onLongPress: () {

      },
      child: Padding(
        key: widget.key,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: widget.mess.infoMessage == null
            ? Row(
                children: [
                  if (widget.mess.senderUserId == widget.userId) Spacer(),
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 16),
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      color: widget.mess.senderUserId != widget.userId
                          ? Color(0xFF0083C7)
                          : Color(0xFFF7F8FA),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.mess.text!,
                          style: TextStyle(
                            color: widget.mess.senderUserId != widget.userId
                                ? Color(0xFFFFFFFF)
                                : Color(0xFF1D2127),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              "${widget.mess.createdAt.hour < 10 ? "0${widget.mess.createdAt.hour}" : widget.mess.createdAt.hour}:" +
                                  "${widget.mess.createdAt.minute < 10 ? "0${widget.mess.createdAt.minute}" : widget.mess.createdAt.minute}",
                              style: TextStyle(
                                color: widget.mess.senderUserId != widget.userId
                                    ? Color(0xFFFFFFFF).withOpacity(0.4)
                                    : Color(0xFF8D96A1).withOpacity(0.4),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              )
            : Center(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "${store.setInfoMessage(widget.mess.infoMessage!.messageAction)}",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
      ),
    );
  }
}
