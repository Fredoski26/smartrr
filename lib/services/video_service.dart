import 'package:smartrr/models/video.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class VideoService {
  static String _videoAPiBaseUrl =
      "https://gist.githubusercontent.com/poudyalanil/ca84582cbeb4fc123a13290a586da925/raw/14a27bd0bcd0cd323b35ad79cf3b493dddf6216b/videos.json";

  static Future<List<Video>> getAllVideos() async {
    final res = await http.get(Uri.parse(_videoAPiBaseUrl));
    final List jsonData = jsonDecode(res.body);

    return jsonData
        .map((video) => Video(
              title: video["title"],
              url: video["videoUrl"],
              thumbnail: video["thumbnailUrl"],
              description: video["description"],
              plays: int.parse(
                  video["views"].toString().replaceAll(RegExp(r','), "")),
              rating: 5,
            ))
        .toList();
  }
}
