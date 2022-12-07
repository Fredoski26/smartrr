import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smartrr/components/widgets/video_player.dart';
import 'package:smartrr/models/video.dart';

class VideoListItem extends StatelessWidget {
  final Video video;
  const VideoListItem({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final colCount = screenWidth ~/ 200;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        PageTransition(
          child: MyVideoPlayer(video: video),
          type: PageTransitionType.scale,
          alignment: Alignment.center,
        ),
      ),
      child: Card(
        margin: EdgeInsets.zero,
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Image.network(
                  video.thumbnail,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.broken_image,
                    size: 30,
                    color: Colors.grey,
                  ),
                  width: screenWidth / colCount,
                  height: 120,
                  fit: BoxFit.cover,
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      size: 40.0,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  video.title,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
