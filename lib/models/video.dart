import 'package:flutter/foundation.dart';

class Video {
  String url;
  String description;
  String title;
  int plays;
  int rating;
  String thumbnail;
  String author;

  Video({
    @required this.url,
    this.thumbnail,
    @required this.title,
    this.author,
    this.description,
    this.plays,
    this.rating,
  });
}
