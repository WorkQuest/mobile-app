import 'dart:io';

import 'package:app/ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart';
import 'package:drishya_picker/drishya_picker.dart';
import 'package:flutter/material.dart';
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
  bool checkPermission = false;

  int get maxAssetsCount => 9;
  GalleryController? gallController;
  FilePickerResult? result;

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
                      type: FileType.media,
                    );
                    break;
                  case "modals.uploadADocuments":
                    result = await FilePicker.platform.pickFiles(
                      allowMultiple: true,
                      type: FileType.custom,
                      allowedExtensions: ['mp4', 'jpeg', 'png', 'pdf', 'doc'],
                    );
                    break;
                }
                if (result != null) {
                  List<File> files =
                      result!.paths.map((path) => File(path!)).toList();
                  widget.store.media.addAll(files);
                } else {
                }
                // if (result != null) widget.store.media.add(result!);
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
            // IconButton(
            //   onPressed: () async {
            //    // if (!checkPermission) {
            //       result = await FilePicker.platform.pickFiles(
            //         type: FileType.custom,
            //         allowedExtensions: ['mp4', 'jpeg', 'png', 'pdf', 'doc'],
            //       );
            //       // gallController = GalleryController(
            //       //   gallerySetting: const GallerySetting(
            //       //     maximum: 1,
            //       //     albumSubtitle: 'All',
            //       //   ),
            //       //   panelSetting: PanelSetting(
            //       //     //topMargin: 100.0,
            //       //     headerMaxHeight: 100.0,
            //       //   ),
            //       // );
            //       checkPermission = true;
            //     //}
            //     showGallery();
            //   },
            //   icon: SvgPicture.asset("assets/attach_media_icon.svg"),
            // ),
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
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          InkWell(
            onTap: _controller.text.isNotEmpty
                ? () {
                    widget.store.sendMessage(
                      _controller.text,
                      widget.store.chat!.chatModel.id,
                      widget.userId,
                      // _store.media,
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
                color: _controller.text.isNotEmpty
                    ? Color(0xFF0083C7)
                    : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Future showGallery() async {
  //   final picked = await gallController!.pick(context);
  //   if (picked.isNotEmpty) widget.store.media.addAll(picked);
  // }
}
