import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MyVideoPlayer extends StatefulWidget {
  final String source;
  const MyVideoPlayer({Key key, @required this.source});

  @override
  State<MyVideoPlayer> createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  VideoPlayerController _videoPlayerController;

  @override
  Widget build(BuildContext context) {
    final _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
    );

    final playerWidget = Chewie(controller: _chewieController);

    return Scaffold(
      body: Container(
        child: _videoPlayerController.value.isInitialized
            ? playerWidget
            : Center(
                child: CircularProgressIndicator(),
              ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.source)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }
}
