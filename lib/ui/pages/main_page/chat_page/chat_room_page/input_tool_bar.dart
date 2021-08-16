import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InputToolbar extends StatefulWidget {
  final void Function(String) onSend;
  InputToolbar(this.onSend);
  @override
  _InputToolbarState createState() => _InputToolbarState();
}

class _InputToolbarState extends State<InputToolbar> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18, right: 12),
          child: InkWell(
              onTap: () {},
              child: SvgPicture.asset("assets/attach_media_icon.svg")),
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
          onTap: _controller.text.isEmpty
              ? null
              : () {
                  widget.onSend(_controller.text);
                  _controller.text = "";
                },
          child: Padding(
            padding:
                const EdgeInsets.only(left: 14, right: 20, top: 10, bottom: 10),
            child: SvgPicture.asset(
              "assets/send_message_icon.svg",
              color: _controller.text.isEmpty ? Colors.grey : Color(0xFF0083C7),
            ),
          ),
        ),
      ],
    );
  }
}
