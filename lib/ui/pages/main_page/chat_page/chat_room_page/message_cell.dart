import 'package:app/model/chat_model/message_model.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart';
import 'package:app/ui/widgets/image_viewer/image_viewer_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class MessageCell extends StatefulWidget {
  final LocalKey key;
  final MessageModel mess;
  final String userId;

  MessageCell(this.key, this.mess, this.userId);

  @override
  _MessageCellState createState() => _MessageCellState();
}

class _MessageCellState extends State<MessageCell> {
  late ChatRoomStore store;
  late String date;
  List<String> pathList = [];
  bool loading = false;

  @override
  void initState() {
    store = context.read<ChatRoomStore>();
    date = widget.mess.createdAt.year == DateTime.now().year &&
            widget.mess.createdAt.month == DateTime.now().month &&
            widget.mess.createdAt.day == DateTime.now().day
        ? DateFormat('kk:mm').format(widget.mess.createdAt)
        : DateFormat('dd MMM, kk:mm').format(widget.mess.createdAt);
    getThumbnail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        if (widget.mess.infoMessage == null) {
          if (store.messageSelected) {
            store.setMessageHighlighted(widget.mess);

            for (int i = 0; i < store.idMessagesForStar.length; i++)
              if (store.idMessagesForStar.values.toList()[i] == true) {
                return;
              }
            store.setMessageSelected(false);
          }
        }
      },
      onLongPress: () {
        if (widget.mess.infoMessage == null) {
          store.setMessageSelected(true);
          store.setMessageHighlighted(widget.mess);
        }
      },
      child: Observer(
        builder: (_) => Container(
          color: store.idMessagesForStar[widget.mess.id] ?? false
              ? Color(0xFFE9EDF2)
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
                                child: ImageViewerWidget(
                                  widget.mess.medias,
                                  widget.mess.senderUserId != widget.userId
                                      ? Color(0xFFFFFFFF)
                                      : Color(0xFF1D2127),
                                  pathList,
                                  loading,
                                ),
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
                            ),
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

  Future<void> getThumbnail() async {
    String filePath = "";
    loading = true;
    for (int i = 0; i < widget.mess.medias.length; i++) {
      filePath = await VideoThumbnail.thumbnailFile(
        video: widget.mess.medias[i].url,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.PNG,
        quality: 100,
      ) ??
          "";
      pathList.add(filePath);
    }
    loading = false;
    setState(() {});
  }
}
