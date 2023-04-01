class Course {
  final String title;
  final String author;
  final String description;
  final int downloads;
  final List<CourseFile> files;

  Course({
    required this.title,
    required this.author,
    required this.description,
    required this.downloads,
    required this.files,
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
