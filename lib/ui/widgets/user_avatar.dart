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
    return Image.network(
      url ?? Constants.defaultImageNetwork,
      fit: BoxFit.cover,
      width: width,
      height: height,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null)
          return child;
        return Center(
          child: SizedBox(
            width: width,
            height: height,
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },

    );
  }
}
