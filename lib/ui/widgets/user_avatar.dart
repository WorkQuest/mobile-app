import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

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
    return FadeInImage.memoryNetwork(
      width: width,
      height: height,
      fit: BoxFit.cover,
      fadeOutDuration: const Duration(milliseconds: 250),
      image: url ?? Constants.defaultImageNetwork,
      placeholder: Uint8List.fromList(
        base64Decode(Constants.base64WhiteHolder),
      ),
    );
  }
}
