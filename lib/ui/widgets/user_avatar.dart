import 'package:flutter/material.dart';

import '../../constants.dart';

class UserAvatar extends StatefulWidget {
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
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      widget.url ?? Constants.defaultImageNetwork,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      frameBuilder: (BuildContext context, Widget child, int? frame,
          bool wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        }
        return AnimatedOpacity(
          child: child,
          opacity: loading ? 0 : 1,
          duration: const Duration(seconds: 1),
          curve: Curves.easeOut,
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            if (mounted) {
              setState(() => loading = false);
            }
          });
          return child;
        }
        loading = true;
        final _circular = CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null,
        );
        return Center(
          child: widget.loadingFitSize
              ? SizedBox(
                  width: widget.width,
                  height: widget.height,
                  child: _circular,
                )
              : _circular,
        );
      },
    );
  }
}
