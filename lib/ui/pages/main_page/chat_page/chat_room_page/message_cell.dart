import 'package:app/model/chat_model/message_model.dart';
import 'package:app/model/quests_models/create_quest_model/media_model.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

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
  late VideoPlayerController _controller;

  @override
  void initState() {
    store = context.read<ChatRoomStore>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        if (widget.mess.infoMessage == null) {
          if (store.messageSelected) {
            store.setMessageHighlighted(widget.index, widget.mess);
          }
          for (int i = 0; i < store.isMessageHighlighted.length; i++)
            if (store.isMessageHighlighted[i] == true) {
              return;
            }
          store.setMessageSelected(false);
        }
      },
      onLongPress: () {
        if (widget.mess.infoMessage == null) {
          store.setMessageSelected(true);
          store.setMessageHighlighted(widget.index, widget.mess);
        }
      },
      child: Observer(
        builder: (_) => Container(
          color: store.isMessageHighlighted.isNotEmpty
              ? store.isMessageHighlighted[widget.index]
                  ? Color(0xFFE9EDF2)
                  : Color(0xFFFFFFFF)
              : Color(0xFFFFFFFF),
          child: Padding(
            key: widget.key,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: widget.mess.infoMessage == null
                ? Row(
                    children: [
                      if (widget.mess.senderUserId == widget.userId) Spacer(),
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 8, top: 8),
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
                            if (widget.mess.medias.isNotEmpty)
                              Center(
                                child: media(),
                              ),
                            Row(
                              children: [
                                Text(
                                  "${widget.mess.createdAt.hour < 10 ? "0${widget.mess.createdAt.hour}" : widget.mess.createdAt.hour}:" +
                                      "${widget.mess.createdAt.minute < 10 ? "0${widget.mess.createdAt.minute}" : widget.mess.createdAt.minute}",
                                  style: TextStyle(
                                    color: widget.mess.senderUserId !=
                                            widget.userId
                                        ? Color(0xFFFFFFFF).withOpacity(0.4)
                                        : Color(0xFF8D96A1).withOpacity(0.4),
                                  ),
                                ),
                                if (widget.mess.star != null)
                                  Icon(
                                    Icons.star,
                                    size: 16,
                                    color: widget.mess.senderUserId !=
                                            widget.userId
                                        ? Color(0xFFFFFFFF).withOpacity(0.4)
                                        : Color(0xFF8D96A1).withOpacity(0.4),
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
        ),
      ),
    );
  }

  Widget media() => SizedBox(
        height: 150.0,
        child: ListView.separated(
          separatorBuilder: (_, index) => SizedBox(
            width: 10.0,
          ),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.mess.medias.length,
          itemBuilder: (_, index) =>
              widget.mess.medias[index].type == TypeMedia.Image
                  ? imageItem(index)
                  : videoItem(index),
        ),
      );

  imageItem(int index) {
    return SizedBox(
      width: 120.0,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          // Media
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              width: double.infinity,
              height: 300,
              child: PageView(
                onPageChanged: store.changePageNumber,
                children: widget.mess.medias
                    .map(
                      (e) => Image.network(
                        e.url,
                        fit: BoxFit.fitHeight,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  videoItem(int index) {
    // final fileName = await VideoThumbnail.thumbnailFile(
    //     video: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
    //     thumbnailPath: (await getApplicationDocumentsDirectory()).path,
    // imageFormat: ImageFormat.WEBP,
    // maxHeight: 64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
    // quality: 75,
    // );
    return SizedBox(
      width: 120.0,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          // Media
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              width: double.infinity,
              height: 300,
              child: PageView(
                onPageChanged: store.changePageNumber,
                children: widget.mess.medias
                    .map(
                      (e) => Image.network(
                        e.url,
                        fit: BoxFit.fitHeight,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
