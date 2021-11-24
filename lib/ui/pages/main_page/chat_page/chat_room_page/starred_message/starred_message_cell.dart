import 'package:app/model/chat_model/message_model.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class StarredMessageCell extends StatefulWidget {
  final MessageModel message;
  final int index;
  final String userId;

  const StarredMessageCell(this.message, this.index, this.userId);

  @override
  _StarredMessageCellState createState() => _StarredMessageCellState();
}

class _StarredMessageCellState extends State<StarredMessageCell> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      key: widget.key,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          widget.message.senderUserId == widget.userId
              ? Text(
                  "chat.you".tr(),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            widget.message.sender!.avatar.url,
                            width: 30,
                            height: 30,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          "${widget.message.sender!.firstName} ${widget.message.sender!.lastName}:",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),

                    Observer(
                      builder: (_) => IconButton(
                        icon: Icon(
                          store.quest.value!.star ? Icons.star : Icons.star_border,
                          color:
                          store.quest.value!.star ? Color(0xFFE8D20D) : Color(0xFFD8DFE3),
                        ),
                        onPressed: (){},
                      ),
                    )
                  ],
                ),
          Row(
            children: [
              if (widget.message.senderUserId == widget.userId) Spacer(),
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 16),
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  color: widget.message.senderUserId != widget.userId
                      ? Color(0xFF0083C7)
                      : Color(0xFFF7F8FA),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.message.text ?? "",
                      style: TextStyle(
                        color: widget.message.senderUserId != widget.userId
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
                          "${widget.message.createdAt.hour < 10 ? "0${widget.message.createdAt.hour}" : widget.message.createdAt.hour}:" +
                              "${widget.message.createdAt.minute < 10 ? "0${widget.message.createdAt.minute}" : widget.message.createdAt.minute}",
                          style: TextStyle(
                            color: widget.message.senderUserId != widget.userId
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
        ],
      ),
    );
  }
}
