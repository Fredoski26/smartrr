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
              "Something is not right :( ${error.runtimeType}",
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: VideoService.getAllVideos().asStream(),
      builder: (context, AsyncSnapshot<List<Video>> snapshot) => snapshot
              .hasError
          ? _errorHandler(snapshot.error)
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              child: snapshot.hasData
                  ? SingleChildScrollView(
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        spacing: 5.0,
                        runSpacing: 5.0,
                        children: snapshot.data
                            .map((video) => GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    PageTransition(
                                      child: MyVideoPlayer(video: video),
                                      type: PageTransitionType.scale,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                  child: Container(
                                    width: 190,
                                    height: 200,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Column(
                                        children: [
                                          Stack(
                                            alignment:
                                                AlignmentDirectional.center,
                                            children: [
                                              SizedBox(
                                                height: 120,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15.0),
                                                    topRight:
                                                        Radius.circular(15.0),
                                                  ),
                                                  child: Image.network(
                                                    video.thumbnail,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        Icon(
                                                      Icons.broken_image,
                                                      size: 30,
                                                      color: Colors.grey,
                                                    ),
                                                    fit: BoxFit.fill,
                                                    width: 190,
                                                    height: 200,
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
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
                                            padding: const EdgeInsets.all(4.0),
                                            child: Center(
                                                child: Text(video.title)),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
    );
  }
}
