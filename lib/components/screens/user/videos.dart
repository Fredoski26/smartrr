import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smartrr/components/widgets/video_player.dart';
import 'package:smartrr/models/video.dart';
import 'package:smartrr/services/video_service.dart';

class Videos extends StatefulWidget {
  const Videos({Key key}) : super(key: key);

  @override
  State<Videos> createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  @override
  Widget build(BuildContext context) {
    Widget _errorHandler(Object error) {
      switch (error.runtimeType.toString()) {
        case "_ClientSocketException":
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Network Error",
                    style: TextStyle().copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Text(
                    "Please check that you have an active internet connection",
                    textAlign: TextAlign.center,
                  )),
                ],
              ),
            ],
          );
        default:
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Something is not right :(",
                style: TextStyle()
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Text(
                    "We encountered an error while fetching your videos",
                    textAlign: TextAlign.center,
                  )),
                ],
              ),
            ],
          );
      }
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final colCount = screenWidth ~/ 200;

    GridView _videos(List<Video> videos) {
      return GridView.count(
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        crossAxisCount: colCount,
        children: videos
            .map(
              (video) => GestureDetector(
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
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            ),
                            child: Image.network(
                              video.thumbnail,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                Icons.broken_image,
                                size: 30,
                                color: Colors.grey,
                              ),
                              width: screenWidth / colCount,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
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
              ),
            )
            .toList(),
      );
    }

    return StreamBuilder(
      stream: VideoService.getAllVideos().asStream(),
      builder: (context, AsyncSnapshot<List<Video>> snapshot) =>
          snapshot.hasError
              ? _errorHandler(snapshot.error)
              : Container(
                  child: snapshot.hasData
                      ? Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: _videos(snapshot.data),
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
    );
  }
}
