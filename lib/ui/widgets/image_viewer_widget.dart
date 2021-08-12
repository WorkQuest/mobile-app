import 'dart:async';
import 'package:video_player/video_player.dart';
import 'package:app/model/quests_models/create_quest_model/media_model.dart';
import 'package:flutter/material.dart';

class ImageViewerWidget extends StatelessWidget {
  ImageViewerWidget(this.medias, {Key? key}) : super(key: key);
  final List<Media> medias;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      height: 200,
      child: Row(
        children: [
          Flexible(
            flex: 3,
            child: getImageCell(0, context),
          ),
          if (medias.length > 1) ...[
            const SizedBox(width: 10),
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (medias.length >= 2) ...[
                    getImageCell(1, context),
                    const SizedBox(height: 10),
                  ],
                  if (medias.length >= 3) ...[
                    getImageCell(2, context),
                    const SizedBox(height: 10),
                  ],
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ScrollingImages(medias)));
                    },
                    child: Icon(Icons.more_horiz),
                    style: ButtonStyle(
                      fixedSize:
                          MaterialStateProperty.all(Size(double.maxFinite, 60)),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.5);
                          return const Color(0xFFF7F8FA);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  getImageCell(int index, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ScrollingImages(
                      medias,
                      index: index,
                    )));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: medias[index].type == TypeMedia.Image
            ? Image.network(
                medias[index].url,
                fit: BoxFit.cover,
                height: index == 0 ? double.infinity : 60,
                width: double.maxFinite,
              )
            : Container(
                color: Colors.black,
                height: index == 0 ? double.infinity : 60,
                width: double.maxFinite,
                alignment: Alignment.center,
                child: Icon(
                  Icons.play_arrow,
                  size: index == 0 ? 100 : 40,
                  color: Color(0xDDFFFFFF),
                ),
              ),
      ),
    );
  }
}

class ScrollingImages extends StatefulWidget {
  ScrollingImages(this.medias, {this.index});
  final List<Media> medias;
  final int? index;

  @override
  _ScrollingImagesState createState() => _ScrollingImagesState();
}

class _ScrollingImagesState extends State<ScrollingImages> {
  int index = 0;
  double width = 0;
  final scrollController = ScrollController();
  @override
  void initState() {
    Timer(
      Duration(milliseconds: 100),
      () {
        width = MediaQuery.of(context).size.width;
        if (widget.index != null) {
          index = widget.index!;
          scrollController.jumpTo(width * widget.index!);
        }
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.medias.forEach((element) {
      print("RTag   ${element.id}  ${element.type}  ${element.url}");
    });
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "${index + 1} of ${widget.medias.length}",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: GestureDetector(
        child: ListView(
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          children: [
            for (var media in widget.medias)
              Center(
                child: Container(
                  width: width,
                  child: media.type == TypeMedia.Image
                      ? Image.network(
                          media.url,
                          fit: BoxFit.fitWidth,
                        )
                      : VideoWidget(url: media.url),
                ),
              ),
          ],
        ),
        onHorizontalDragUpdate: (details) {
          scrollController.jumpTo(scrollController.offset - details.delta.dx);
        },
        onHorizontalDragEnd: (details) {
          if (scrollController.offset <= 0) return;
          if (details.primaryVelocity! < -500) {
            if (index == widget.medias.length - 1)
              return;
            else
              index += 1;
          } else if (details.primaryVelocity! > 500) index -= 1;
          setState(() {});
          scrollController.animateTo(width * index,
              duration: Duration(milliseconds: 500), curve: Curves.easeOut);
        },
      ),
    );
  }
}

class VideoWidget extends StatefulWidget {
  final String url;
  VideoWidget({required this.url});
  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
      });
    _controller!.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GestureDetector(
        onTap: () {
          setState(() {
            _controller!.value.isPlaying
                ? _controller!.pause()
                : _controller!.play();
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            _controller!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  )
                : CircularProgressIndicator(),
            if (!_controller!.value.isPlaying &&
                _controller!.value.isInitialized)
              Icon(
                Icons.play_arrow,
                size: MediaQuery.of(context).size.width * 0.5,
                color: Color(0xDDFFFFFF),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }
}
