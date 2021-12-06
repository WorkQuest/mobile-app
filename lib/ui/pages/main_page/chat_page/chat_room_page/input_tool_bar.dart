import 'package:app/ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart';
import 'package:drishya_picker/drishya_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import "package:provider/provider.dart";

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
  late final GalleryController gallController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 12),
            child: InkWell(
              onTap: () {
                if (!checkPermission) {
                  gallController = GalleryController(
                    gallerySetting: const GallerySetting(
                      maximum: 1,
                      albumSubtitle: 'All',
                    ),
                    panelSetting: PanelSetting(
                      //topMargin: 100.0,
                      headerMaxHeight: 100.0,
                    ),
                  );
                  checkPermission = true;
                }
                showGallery();
              },
              child: SvgPicture.asset("assets/attach_media_icon.svg"),
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

  Future showGallery() async {
    final picked = await gallController.pick(
      context,
    );
    if (picked.isNotEmpty) context.read<ChatRoomStore>().media.addAll(picked);
  }
}
