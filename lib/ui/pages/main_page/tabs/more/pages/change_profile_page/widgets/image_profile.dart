import 'dart:io';
import 'dart:typed_data';

import 'package:app/constants.dart';
import 'package:flutter/material.dart';

class ImageProfile extends StatefulWidget {
  final Function() onPressed;
  final bool hasMedia;
  final String? url;
  final File? file;

  const ImageProfile({
    Key? key,
    required this.onPressed,
    required this.hasMedia,
    required this.file,
    required this.url,
  }) : super(key: key);

  @override
  State<ImageProfile> createState() => _ImageProfileState();
}

class _ImageProfileState extends State<ImageProfile> {
  late Future<Uint8List> future;
  File? file;

  @override
  void initState() {
    super.initState();
    if (!widget.hasMedia) {
      file = widget.file!;
      future = file!.readAsBytes();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.hasMedia) {
      if (file == null || file != widget.file) {
        future = widget.file!.readAsBytes();
        file = widget.file!;
      }
    }
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(65),
            child: widget.hasMedia
                ? Image.network(
                    widget.url ?? Constants.defaultImageNetwork,
                    height: 130,
                    width: 130,
                    fit: BoxFit.cover,
                  )
                : FutureBuilder<Uint8List>(
                    future: future,
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Image.memory(
                          snapshot.data!,
                          height: 130,
                          width: 130,
                          fit: BoxFit.cover,
                        );
                      }
                      return SizedBox(
                        height: 130,
                        width: 130,
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      );
                    },
                  ),
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: widget.onPressed,
          ),
        ],
      ),
    );
  }
}
