import 'package:flutter/material.dart';

import '../../constants.dart';

class UserAvatar extends StatelessWidget {
  final double width;
  final double height;
  final String? url;
  final BoxFit fit;
  final bool loadingFitSize;

  const UserAvatar({
    Key? key,
    required this.width,
    required this.height,
    required this.url,
    this.fit = BoxFit.cover,
    this.loadingFitSize = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url ?? Constants.defaultImageNetwork,
      fit: fit,
      width: width,
      height: height,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        final _circular = CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null,
        );
        return Center(
          child: loadingFitSize
              ? SizedBox(
                  width: width,
                  height: height,
                  child: _circular,
                )
              : _circular,
        );
      },
    );
  }
}
