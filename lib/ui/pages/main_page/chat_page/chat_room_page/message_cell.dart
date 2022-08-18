import 'package:app/model/chat_model/message_model.dart';
import 'package:app/model/media_model.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart';
import 'package:app/ui/widgets/image_viewer_widget.dart';
import 'package:app/utils/info_message_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class MessageCell extends StatelessWidget {
  final LocalKey key;
  final MessageModel mess;
  final String userId;
  final Map<Media, String> medias;

  MessageCell(
    this.key,
    this.mess,
    this.userId,
    this.medias,
  );

  @override
  Widget build(BuildContext context) {
    final store = context.read<ChatRoomStore>();
    final date = mess.createdAt!.year == DateTime.now().year &&
            mess.createdAt!.month == DateTime.now().month &&
            mess.createdAt!.day == DateTime.now().day
        ? DateFormat('kk:mm').format(mess.createdAt!)
        : DateFormat('dd MMM, kk:mm').format(mess.createdAt!);
    final itsMe = mess.sender!.userId == userId;
    bool isNeedNameStart = false;
    bool isNeedNameFinish = false;
    String infoMessage = "";
    String message = "";
    String senderName =
        mess.sender!.user!.firstName + " " + mess.sender!.user!.lastName;
    if (mess.infoMessage != null) {
      infoMessage =
          InfoMessageUtil().getMessage(mess.infoMessage!.messageAction, itsMe);
      isNeedNameStart = InfoMessageUtil().needNameStart(infoMessage);
      isNeedNameFinish = InfoMessageUtil().needNameFinish(infoMessage);
      message = "${isNeedNameStart ? senderName + " " : ""}"
          "${infoMessage.tr()}"
          "${isNeedNameFinish ? " " + senderName : ""}";
    }
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        if (mess.infoMessage == null) {
          if (store.messageSelected) {
            store.setMessageHighlighted(mess);

            for (int i = 0; i < store.selectedMessages.length; i++)
              if (store.selectedMessages.values.toList()[i] == true) {
                return;
              }
            store.setMessageSelected(false);
          }
        }
      },
      onLongPress: () {
        if (mess.infoMessage == null) {
          store.setMessageSelected(true);
          store.setMessageHighlighted(mess);
        }
      },
      child: Observer(
        builder: (_) => Container(
          color: store.selectedMessages[mess] ?? false
              ? Color(0xFFE9EDF2)
              : Color(0xFFFFFFFF),
          child: Padding(
            key: key,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: mess.infoMessage == null
                ? Row(
                    children: [
                      if (itsMe) Spacer(),
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 8, top: 8),
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                          color: !itsMe ? Color(0xFF0083C7) : Color(0xFFF7F8FA),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mess.text ?? "",
                              style: TextStyle(
                                color: !itsMe
                                    ? Color(0xFFFFFFFF)
                                    : Color(0xFF1D2127),
                              ),
                            ),
                            const SizedBox(height: 5),
                            if (mess.medias!.isNotEmpty)
                              Center(
                                child: ImageViewerWidget(
                                  mess.medias!,
                                  !itsMe
                                      ? Color(0xFFFFFFFF)
                                      : Color(0xFF1D2127),
                                  medias,
                                ),
                              ),
                            Row(
                              children: [
                                Text(
                                  date,
                                  style: TextStyle(
                                    color: !itsMe
                                        ? Color(0xFFFFFFFF).withOpacity(0.4)
                                        : Color(0xFF8D96A1).withOpacity(0.4),
                                  ),
                                ),
                                const SizedBox(width: 3),
                                if (mess.star != null)
                                  Icon(
                                    Icons.star,
                                    size: 16,
                                    color: !itsMe
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
                        message,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
