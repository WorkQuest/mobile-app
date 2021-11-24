import 'package:app/model/chat_model/owner.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class EditUserCell extends StatefulWidget {
  final Owner user;
  final int index;
  final bool? owner;

  const EditUserCell(this.user, this.index, this.owner);

  @override
  _EditUserCellState createState() => _EditUserCellState();
}

class _EditUserCellState extends State<EditUserCell> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  widget.user.avatar.url,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Text(
                "${widget.user.firstName} ${widget.user.lastName}",
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
          Observer(
            builder: (_) => widget.owner ?? false
                ? Text(
                    "chat.owner".tr(),
                  )
                : context.read<ChatRoomStore>().userInChat[widget.index]
                    ? SvgPicture.asset("assets/minus.svg")
                    : SvgPicture.asset("assets/plus.svg"),
          ),
        ],
      ),
    );
  }
}
