import 'dart:io';

import 'package:app/enums.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:easy_localization/easy_localization.dart';

class InputToolbar extends StatefulWidget {
  final ChatRoomStore store;
  final String userId;

  InputToolbar(this.store, this.userId);

  @override
  _InputToolbarState createState() => _InputToolbarState();
}

class _InputToolbarState extends State<InputToolbar> {
  TextEditingController _controller = TextEditingController();
  FilePickerResult? result;
  List<File> files = [];

  int get maxAssetsCount => 9;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 2.0, right: 12.0),
            child: PopupMenuButton<String>(
              elevation: 10,
              icon: SvgPicture.asset("assets/attach_media_icon.svg"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              onSelected: (value) async {
                switch (value) {
                  case "modals.uploadAImages":
                    result = await FilePicker.platform.pickFiles(
                        allowMultiple: true,
                        type: FileType.custom,
                        allowedExtensions: [
                          'jpeg',
                          'webp',
                          'mp4',
                          'mov',
                          'jpg',
                          'png'
                        ]);
                    break;
                  case "modals.uploadADocuments":
                    result = await FilePicker.platform.pickFiles(
                      allowMultiple: true,
                      type: FileType.custom,
                      allowedExtensions: ['pdf', 'doc', 'docx'],
                    );
                    break;
                }
                if (result != null) {
                  result!.files.map((file) {
                    widget.store.setImage(File(file.path!));
                  }).toList();
                }
              },
              itemBuilder: (BuildContext context) {
                return {
                  "modals.uploadAImages",
                  "modals.uploadADocuments",
                }.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(
                      choice.tr(),
                    ),
                  );
                }).toList();
              },
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: _controller,
              textInputAction: TextInputAction.newline,
              minLines: 1,
              maxLines: 8,
              onChanged: (text) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Text',
              ),
            ),
          ),
          Observer(
            builder: (_) => InkWell(
              onTap: (_controller.text.isNotEmpty ||
                          widget.store.progressImages.isNotEmpty) &&
                      !widget.store.sendingMessage
                  ? () {
                      widget.store.sendMessage(
                        _controller.text,
                        widget.store.chatRoom!.type == TypeChat.group
                            ? widget.store.chatRoom!.id
                            : widget.userId,
                        widget.store.chatRoom!.type == TypeChat.group
                            ? "chat"
                            : "user",
                      );
                      _controller.text = "";
                    }
                  : null,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 14,
                  right: 20,
                  top: 10,
                  bottom: 10,
                ),
                child: SvgPicture.asset(
                  "assets/send_message_icon.svg",
                  color: _controller.text.isNotEmpty ||
                          widget.store.progressImages.isNotEmpty
                      ? Color(0xFF0083C7)
                      : Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
