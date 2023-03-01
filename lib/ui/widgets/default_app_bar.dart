import 'package:app/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultAppBar extends StatelessWidget with PreferredSizeWidget {
  final Function()? onPressed;
  final String? title;
  final bool titleCenter;
  final List<Widget>? actions;

  const DefaultAppBar({
    Key? key,
    this.onPressed,
    this.titleCenter = true,
    this.title,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: Colors.white,
      shadowColor: Colors.transparent,
      centerTitle: titleCenter,
      title: Text(
        title ?? '',
        style: const TextStyle(
          fontSize: 17,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      leading: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          if (onPressed != null) {
            onPressed!.call();
          } else {
            Navigator.pop(context);
          }
        },
        child: const Icon(
          Icons.arrow_back_ios,
          color: AppColor.enabledButton,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
