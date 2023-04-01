import 'dart:convert';

import 'package:smartrr/env/env.dart';
import 'package:http/http.dart' as http;
import 'package:smartrr/models/course.dart';

abstract class CourseService {
  static final String _apiBaseUrl = Env.apiBaseUrl;

  static Future<List<Course>> getAllCourses() async {
    final res = await http.get(Uri.parse("$_apiBaseUrl/courses"));
    final List jsonData = jsonDecode(res.body)["courses"];
    List<Course> courses = jsonData.map((course) {
      final files = (course["files"] as List)
          .map(
            (file) => CourseFile(
              key: file["key"],
              name: file["name"],
              url: file["url"],
            ),
          )
          .toList();

      return Course(
        title: course["title"],
        description: course["description"],
        author: course["author"],
        downloads: course["downloads"].length,
        files: files,
      );
    }).toList();

    return courses;
  }
}
