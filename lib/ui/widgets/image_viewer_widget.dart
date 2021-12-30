import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:app/model/quests_models/create_quest_model/media_model.dart';
import 'package:flutter/material.dart';

class ImageViewerWidget extends StatelessWidget {
  ImageViewerWidget(this.medias, this.textColor);

  final List<Media> medias;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    List<Media> documents = [];
    List<Media> media = [];
    medias.forEach((element) {
      if (element.type == TypeMedia.Doc || element.type == TypeMedia.Pdf)
        documents.add(element);
      else
        media.add(element);
    });
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                flex: 3,
                child: getImageCell(0, context),
              ),
              if (media.length > 1) ...[
                const SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (media.length >= 2) ...[
                        getImageCell(1, context),
                        const SizedBox(height: 10),
                      ],
                      if (media.length >= 3) ...[
                        getImageCell(2, context),
                        const SizedBox(height: 10),
                      ],
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ScrollingImages(media),
                            ),
                          );
                        },
                        child: Icon(Icons.more_horiz),
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(
                            Size(double.maxFinite, 60),
                          ),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
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
          for (int i = 0; i < documents.length; i++)
            getDocumentCell(i, context),
        ],
      ),
    );
  }

  getImageCell(int index, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (medias[index].type == TypeMedia.Image ||
            medias[index].type == TypeMedia.Video) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ScrollingImages(
                medias,
                index: index,
              ),
            ),
          );
        } else {}
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: medias[index].type == TypeMedia.Image
            ? Image.network(
                medias[index].url,
                fit: BoxFit.cover,
                height: index == 0 ? 200 : 60,
                width: double.maxFinite,
              )
            : Container(
                color: Colors.black,
                height: index == 0 ? 200 : 60,
                width: double.maxFinite,
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/play.svg',
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: MediaQuery.of(context).size.height * 0.1,
                  color: Color(0xFFE9EDF2),
                ),
              ),
      ),
    );
  }

  getDocumentCell(int index, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String dir = "";
        if (Platform.isAndroid) {
          dir = (await getExternalStorageDirectory())!.path;
        } else if (Platform.isIOS) {
          dir = (await getApplicationDocumentsDirectory()).path;
        }
        print("dir: $dir");
        if (medias[index].type == TypeMedia.Pdf)
          final f = downloadFile(medias[index].url,
              medias[index].url.split("/").reversed.first + ".pdf", dir);
        if (medias[index].type == TypeMedia.Doc)
          final f = downloadFile(medias[index].url,
              medias[index].url.split("/").reversed.first + ".doc", dir);
      },
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              SvgPicture.asset(
                medias[index].type == TypeMedia.Pdf
                    ? "assets/pdf.svg"
                    : "assets/doc.svg",
                  width: 30,
                  height: 30,
              ),
              const SizedBox(
                width: 14,
              ),
              Flexible(
                child: Text(
                  "${medias[index].url.split("/").reversed.first}",
                  style: TextStyle(color: textColor),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  Future<String> downloadFile(String url, String fileName, String dir) async {
    HttpClient httpClient = new HttpClient();
    File file;
    String filePath = '';

    try {
      print("myURL: $url");
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        filePath = '$dir/$fileName';
        file = File(filePath);
        await file.writeAsBytes(bytes);
      } else
        filePath = 'Error code: ' + response.statusCode.toString();
    } catch (ex) {
      filePath = 'Can not fetch url';
    }
    print("FILE PATH: $filePath");

    return filePath;
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
                : CircularProgressIndicator.adaptive(),
            if (!_controller!.value.isPlaying &&
                _controller!.value.isInitialized)
              SvgPicture.asset(
                'assets/play.svg',
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.height * 0.1,
                color: Color(0xFFE9EDF2),
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
