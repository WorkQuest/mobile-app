import 'package:app/model/chat_model/message_model.dart';
import 'package:flutter/material.dart';

class MessageCell extends StatefulWidget {
  final MessageModel mess;
  MessageCell(this.mess);
  @override
  _MessageCellState createState() => _MessageCellState();
}

class _MessageCellState extends State<MessageCell> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (widget.mess.isMy) Spacer(),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 16),
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              color: !widget.mess.isMy ? Color(0xFF0083C7) : Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.mess.text,
                  style: TextStyle(
                    color: !widget.mess.isMy
                        ? Color(0xFFFFFFFF)
                        : Color(0xFF1D2127),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    if (widget.mess.status != MessageStatus.None)
                      Icon(
                        widget.mess.status == MessageStatus.Wait
                            ? Icons.watch_later
                            : widget.mess.status == MessageStatus.Send
                                ? Icons.check
                                : Icons.error,
                        size: 15,
                        color: widget.mess.isMy
                            ? Color(0xFF0083C7)
                            : Color(0xFFF7F8FA),
                      ),
                    Text(
                      "${widget.mess.updatedAt.hour < 10 ? "0${widget.mess.updatedAt.hour}" : widget.mess.updatedAt.hour}:" +
                          "${widget.mess.updatedAt.minute < 10 ? "0${widget.mess.updatedAt.minute}" : widget.mess.updatedAt.minute}",
                      style: TextStyle(
                        color: !widget.mess.isMy
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
    );
  }

  @override
  void dispose() {
    if (widget.mess.status != MessageStatus.None)
      widget.mess.status = MessageStatus.None;
    super.dispose();
  }
}
