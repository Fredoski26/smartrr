import 'package:smartrr/models/video.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class VideoService {
  static String _videoAPiBaseUrl =
      "https://mini-dashboard-api.onrender.com/videos";
  //"https://gist.githubusercontent.com/poudyalanil/ca84582cbeb4fc123a13290a586da925/raw/14a27bd0bcd0cd323b35ad79cf3b493dddf6216b/videos.json";

  static Future<List<Video>> getAllVideos() async {
    final res = await http.get(Uri.parse(_videoAPiBaseUrl));
    final List jsonData = jsonDecode(res.body)["videos"];

    return jsonData
        .map((video) => Video(
              title: video["title"],
              author: video["author"] ?? "Smart RR",
              url: video["video"]["url"],
              thumbnail: video["thumbnail"]["url"],
              description: video["description"],
              plays: video["views"],
              rating: 5,
            ))
        .toList();
  }
}
