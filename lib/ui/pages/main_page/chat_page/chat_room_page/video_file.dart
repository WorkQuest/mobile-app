import 'package:app/ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:video_player/video_player.dart';

class VideoFile extends StatefulWidget {
  static const String routeName = "/videoFile";

  const VideoFile(this.store);

  final ChatRoomStore store;

  @override
  _VideoFileState createState() => _VideoFileState();
}

class _VideoFileState extends State<VideoFile> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  Chewie? playerWidget;

  @override
  void initState() {
    videoPlayerController =
        VideoPlayerController.network(widget.store.urlVideo);
    videoPlayerController!.initialize();
    chewieController = ChewieController(
      fullScreenByDefault: true,
      videoPlayerController: videoPlayerController!,
      autoInitialize: true,
      autoPlay: false,
      looping: false,
      aspectRatio: 16 / 9,
    );

    playerWidget = Chewie(
      controller: chewieController!,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? pathVideo;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_sharp,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: 350.0,
        padding: const EdgeInsets.all(12.0),
        color: Colors.lightBlue[50],
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: chewieController != null &&
                        chewieController!
                            .videoPlayerController.value.isInitialized &&
                        chewieController!.isPlaying
                    ? Chewie(
                        controller: chewieController!,
                      )
                    : chewieController != null
                        ? Align(
                            alignment: Alignment.center,
                            child: ClipOval(
                              child: Material(
                                color: Colors.white, // Button color
                                child: InkWell(
                                  splashColor: Colors.white, // Splash color
                                  onTap: () {
                                    chewieController!.play();
                                    setState(() {});
                                  },
                                  child: SizedBox(
                                      width: 56,
                                      height: 56,
                                      child: Icon(Icons.play_arrow)),
                                ),
                              ),
                            ),
                          )
                        : Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          ),
              ),
            ),
          ],
        ),
      ),

      // chewieController!.videoPlayerController.value.isInitialized &&
      //         chewieController!.isPlaying
      //     ? Chewie(
      //         controller: chewieController!,
      //       )
      //     : chewieController != null
      //         ? Align(
      //             alignment: Alignment.center,
      //             child: ClipOval(
      //               child: Material(
      //                 color: Colors.white, // Button color
      //                 child: InkWell(
      //                   splashColor: Colors.white, // Splash color
      //                   onTap: () {
      //                     chewieController!.play();
      //                     setState(() {});
      //                   },
      //                   child: SizedBox(
      //                     width: 56,
      //                     height: 56,
      //                     child: Icon(
      //                       Icons.play_arrow,
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           )
      //         : Align(
      //             alignment: Alignment.center,
      //             child: CircularProgressIndicator(),
      //           ),
    );
  }
}
