import 'package:app/model/chat_model/message_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageCell extends StatefulWidget {
  final Map<String, dynamic> arguments;
  // final int index;

  MessageCell(this.arguments,
      // {this.index = 0}
      );

  @override
  _MessageCellState createState() => _MessageCellState();
}

class _MessageCellState extends State<MessageCell> {
  late MessageModel mess;
  late String userId;

  @override
  void initState() {
    mess = widget.arguments["message"];
    userId = widget.arguments["userId"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // key: Key("${widget.index}"),
      // onLongPress: ,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            if (mess.senderUserId == userId) Spacer(),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 16),
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                color: mess.senderUserId != userId
                    ? Color(0xFF0083C7)
                    : Color(0xFFF7F8FA),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mess.text!,
                    style: TextStyle(
                      color: mess.senderUserId != userId
                          ? Color(0xFFFFFFFF)
                          : Color(0xFF1D2127),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      // if (widget.mess.status != MessageStatus.None)
                      //   Icon(
                      //     widget.mess.status == MessageStatus.Wait
                      //         ? Icons.watch_later
                      //         : widget.mess.status == MessageStatus.Send
                      //             ? Icons.check
                      //             : Icons.error,
                      //     size: 15,
                      //     color: widget.mess.isMy
                      //         ? Color(0xFF0083C7)
                      //         : Color(0xFFF7F8FA),
                      //   ),
                      Text(
                        "${mess.createdAt.hour < 10 ? "0${mess.createdAt.hour}" : mess.createdAt.hour}:" +
                            "${mess.createdAt.minute < 10 ? "0${mess.createdAt.minute}" : mess.createdAt.minute}",
                        style: TextStyle(
                          color: mess.senderUserId != userId
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
        ),
      ),
    );
  }

// @override
// void dispose() {
//   if (widget.mess.status != MessageStatus.None)
//     widget.mess.status = MessageStatus.None;
//   super.dispose();
// }
}
