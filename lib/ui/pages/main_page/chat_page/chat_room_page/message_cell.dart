import 'package:app/model/chat_model/message_model.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageCell extends StatefulWidget {
  final Map<String, dynamic> arguments;

  final LocalKey key;

  MessageCell(this.key, this.arguments);

  @override
  _MessageCellState createState() => _MessageCellState();
}

class _MessageCellState extends State<MessageCell> {
  late MessageModel mess;
  late String userId;
  late ChatRoomStore store;

  @override
  void initState() {
    mess = widget.arguments["message"];
    userId = widget.arguments["userId"];
    store = context.read<ChatRoomStore>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: widget.key,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: mess.infoMessage == null
          ? Row(
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
            )
          : Center(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "${store.setInfoMessage(mess.infoMessage!.messageAction)}",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
    );
  }
}
