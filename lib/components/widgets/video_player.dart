import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:smartrr/models/video.dart';
import 'package:smartrr/utils/colors.dart';

class MyVideoPlayer extends StatefulWidget {
  final Video video;
  const MyVideoPlayer({Key key, @required this.video});

  @override
  State<MyVideoPlayer> createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  BetterPlayerController _betterPlayerController;
  BetterPlayerDataSource _betterPlayerDataSource;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: BetterPlayer(
          controller: _betterPlayerController,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network, widget.video.url,
        cacheConfiguration: BetterPlayerCacheConfiguration(
          useCache: true,
          preCacheSize: 10 * 1024 * 1024,
          maxCacheSize: 10 * 1024 * 1024,
          maxCacheFileSize: 10 * 1024 * 1024,
        ),
        notificationConfiguration: BetterPlayerNotificationConfiguration(
          showNotification: true,
          title: widget.video.title,
          author: widget.video.author,
          imageUrl: widget.video.thumbnail,
          activityName: "MainActivity",
        ));

    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: true,
        looping: true,
        allowedScreenSleep: false,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          controlBarColor: Colors.transparent,
          progressBarPlayedColor: primaryColor,
          progressBarBufferedColor: Colors.yellow,
          loadingColor: primaryColor,
        ),
      ),
      betterPlayerDataSource: _betterPlayerDataSource,
    );

    _betterPlayerController.preCache(_betterPlayerDataSource);
  }

  @override
  void dispose() {
    super.dispose();
    _betterPlayerController.stopPreCache(_betterPlayerDataSource);
  }
}
