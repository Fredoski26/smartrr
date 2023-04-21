import 'dart:convert';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:smartrr/env/env.dart';
import 'package:http/http.dart' as http;
import 'package:smartrr/models/course.dart';
import 'package:smartrr/services/auth_service.dart';

abstract class CourseService {
  static final String _apiBaseUrl = Env.apiBaseUrl;

  static Future<bool> captureDownload(String uid, String courseId) async {
    final token = AuthService.generateApiToken();

    final res = await http.put(
      Uri.parse("$_apiBaseUrl/courses/$courseId"),
      headers: {
        "Content-Type": "multipart/form-data",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({"userId": uid}),
    );

    print("RESPONSE: $res");
    if (res.statusCode == 200) return true;
    return false;
  }

  static Future<List<Course>> getAllCourses() async {
    final res = await http.get(Uri.parse("$_apiBaseUrl/courses"));
    final List jsonData = jsonDecode(res.body)["courses"];

    final List<Course> courses = [];

    for (int i = 0; i < jsonData.length; i++) {
      final files = (jsonData[i]["files"] as List)
          .map(
            (file) => CourseFile(
              key: file["key"],
              name: file["name"],
              url: file["url"],
            ),
          )
          .toList();

      final downloadTask = await FlutterDownloader.loadTasksWithRawQuery(
          query: "SELECT * FROM task WHERE status=3 AND url='${files[0].url}'");

      final bool downloadTaskExists =
          downloadTask != null && downloadTask.isNotEmpty;

      courses.add(
        Course(
          id: jsonData[i]["_id"],
          title: jsonData[i]["title"],
          description: jsonData[i]["description"],
          author: jsonData[i]["author"],
          downloads: jsonData[i]["downloads"].length,
          file: files[0],
          downloadStatus: downloadTaskExists
              ? downloadTask.first.status
              : DownloadTaskStatus.undefined,
        ),
      );
    }

    return courses;
  }
}
