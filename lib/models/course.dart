import 'package:flutter_downloader/flutter_downloader.dart';

class Course {
  final String id;
  final String title;
  final String author;
  final String description;
  final int downloads;
  final CourseFile file;
  final DownloadTaskStatus downloadStatus;

  Course({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.downloads,
    required this.file,
    required this.downloadStatus,
  });
}

class CourseFile {
  final String key;
  final String name;
  final String url;

  CourseFile({
    required this.key,
    required this.name,
    required this.url,
  });
}
