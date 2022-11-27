import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smartrr/components/widgets/video_player.dart';
import 'package:smartrr/models/video.dart';
import 'package:smartrr/services/video_service.dart';
import 'package:video_player/video_player.dart';

class Videos extends StatefulWidget {
  const Videos({Key key}) : super(key: key);

  @override
  State<Videos> createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: VideoService.getAllVideos().asStream(),
      builder: (context, AsyncSnapshot<List<Video>> snapshot) => snapshot
              .hasError
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Something is not right",
                  style: TextStyle()
                      .copyWith(fontWeight: FontWeight.w500, fontSize: 18),
                ),
                Text("We encountered an error fetching your videos :("),
              ],
            )
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
                                            BorderRadius.circular(9.0),
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
                                                        Radius.circular(9.0),
                                                    topRight:
                                                        Radius.circular(9.0),
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
                                                        color: Colors.white),
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
