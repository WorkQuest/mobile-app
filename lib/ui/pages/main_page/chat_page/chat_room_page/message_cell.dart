import 'package:app/model/chat_model/message_model.dart';
import 'package:app/model/quests_models/create_quest_model/media_model.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/video_file.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
  late String date;

  @override
  void initState() {
    store = context.read<ChatRoomStore>();
    date = widget.mess.createdAt.year == DateTime.now().year &&
            widget.mess.createdAt.month == DateTime.now().month &&
            widget.mess.createdAt.day == DateTime.now().day
        ? ""
        : DateFormat('dd MMM, kk:mm').format(widget.mess.createdAt);
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
                                  date,
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

  Widget media() {
    return SizedBox(
      height: 150.0,
      child: ListView.separated(
          separatorBuilder: (_, index) => SizedBox(
            width: 10.0,
          ),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.mess.medias.length,
          itemBuilder: (_, index) {
            if (widget.mess.medias[index].type == TypeMedia.Video) {
              store.setThumbnailPath(widget.mess.medias[index].url, widget.mess.medias[index].id);
            }
            return widget.mess.medias[index].type == TypeMedia.Image
                ? Image.network(
                    widget.mess.medias[index].url,
                    fit: BoxFit.cover,
                  )
                : widget.mess.medias[index].type == TypeMedia.Video
                    ?
            Observer(
              builder: (_) => store.mapOfPath[widget.mess.medias[index].id] != null
                          ? InkWell(
                              child: Image.asset(
                                store.mapOfPath[widget.mess.medias[index].id],
                                fit: BoxFit.cover,
                              ),
                              onTap: () {
                                store.urlVideo = widget.mess.medias[index].url;
                                Navigator.of(context, rootNavigator: true)
                                    .pushNamed(VideoFile.routeName,
                                        arguments: store);
                              },
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            ),
            )
                    : Center(
                        child: Text("This isn't video or image"),
                      );
          },
        ),
    );
  }
}
