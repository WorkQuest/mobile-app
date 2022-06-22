import 'package:app/constants.dart';
import 'package:app/model/chat_model/message_model.dart';
import 'package:app/model/chat_model/star.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/starred_message/store/starred_message_store.dart';
import 'package:app/ui/widgets/image_viewer_widget.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class StarredMessageCell extends StatefulWidget {
  final MessageModel message;
  final int index;
  final String userId;
  final StarredMessageStore store;

  const StarredMessageCell(
    this.message,
    this.index,
    this.userId,
    this.store,
  );

  @override
  State<StarredMessageCell> createState() => _StarredMessageCellState();
}

class _StarredMessageCellState extends State<StarredMessageCell> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.message.sender!.userId == widget.userId
                ? Text("chat.you".tr())
                : Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          widget.message.sender!.user!.avatar?.url ??
                              Constants.defaultImageNetwork,
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Text(
                        "${widget.message.sender!.user!.firstName} "
                        "${widget.message.sender!.user!.lastName}:",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
            IconButton(
              icon: Icon(Icons.star),
              iconSize: 22,
              color: widget.message.star != null
                  ? Color(0xFFE8D20D)
                  : Color(0xFFE9EDF2),
              onPressed: () {
                widget.store.removeStar(widget.message);
                widget.message.star != null
                    ? widget.message.star = null
                    : widget.message.star = Star();
                setState(() {});
              },
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 16),
          width: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
            color: widget.message.sender!.userId != widget.userId
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
                  color: widget.message.sender!.userId != widget.userId
                      ? Color(0xFFFFFFFF)
                      : Color(0xFF1D2127),
                ),
              ),
              const SizedBox(height: 5),
              if (widget.message.medias!.isNotEmpty)
                Center(
                  child: ImageViewerWidget(
                    widget.message.medias!,
                    widget.message.sender!.userId != widget.userId
                        ? Color(0xFFFFFFFF)
                        : Color(0xFF1D2127),
                    widget.store.mediaPaths,
                  ),
                ),
              Row(
                children: [
                  Text(
                    "${widget.message.createdAt!.hour < 10 ? "0${widget.message.createdAt!.hour}" : widget.message.createdAt!.hour}:" +
                        "${widget.message.createdAt!.minute < 10 ? "0${widget.message.createdAt!.minute}" : widget.message.createdAt!.minute}",
                    style: TextStyle(
                      color: widget.message.sender!.userId != widget.userId
                          ? Color(0xFFFFFFFF).withOpacity(0.4)
                          : Color(0xFF8D96A1).withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
