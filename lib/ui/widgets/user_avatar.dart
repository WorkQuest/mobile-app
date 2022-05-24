import 'dart:convert';
import 'dart:typed_data';

import 'package:app/ui/widgets/gradient_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants.dart';

class UserAvatar extends StatelessWidget {
  final double width;
  final double height;
  final String? url;

  const UserAvatar({
    Key? key,
    required this.width,
    required this.height,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   width: width,
    //   height: height,
    //   decoration: BoxDecoration(
    //     shape: BoxShape.circle,
    //   ),
    //   child: Image.asset('assets/wq_default_avatar.png'),
    // );
    return FadeInImage.memoryNetwork(
      width: width,
      height: height,
      fit: BoxFit.cover,
      fadeOutDuration: const Duration(milliseconds: 250),
      image: url ?? Constants.defaultImageNetwork,
      imageErrorBuilder: (context, error, _) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Image.asset('assets/wq_default_avatar.png'),
        );
      },
      placeholder: Uint8List.fromList(
        base64Decode(Constants.base64WhiteHolder),
      ),
    );
  }
}
