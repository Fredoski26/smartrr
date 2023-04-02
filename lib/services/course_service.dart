import 'dart:convert';

import 'package:smartrr/env/env.dart';
import 'package:http/http.dart' as http;
import 'package:smartrr/models/course.dart';
import 'package:smartrr/services/auth_service.dart';

abstract class CourseService {
  static final String _apiBaseUrl = Env.apiBaseUrl;

  static Future<bool> captureDownload(String uid) async {
    final token = AuthService.generateApiToken();

    print("UID: $uid TOKEN: $token");

    final res = await http.put(Uri.parse("$_apiBaseUrl/courses"), headers: {
      "Content-Type": "multipart/form-data",
      "Authorization": "Bearer $token"
    }, body: {
      "userId": uid
    });

    print("RESPONSE: $res");
    if (res.statusCode == 200) return true;
    return false;
  }

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
