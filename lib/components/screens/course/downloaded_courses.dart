import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:smartrr/components/screens/course/course_tile.dart';
import 'package:smartrr/models/course.dart';

class DownloadedCourses extends StatefulWidget {
  const DownloadedCourses({super.key});

  @override
  State<DownloadedCourses> createState() => _DownloadedCoursesState();
}

class _DownloadedCoursesState extends State<DownloadedCourses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Downloaded Courses")),
      body: StreamBuilder<List<Course>>(
        stream: loadCourses().asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text("No downloads"),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) =>
                    CourseTile(course: snapshot.data![index]));
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<List<Course>> loadCourses() async {
    final query = "SELECT * FROM task WHERE status=3";
    return FlutterDownloader.loadTasksWithRawQuery(query: query)
        .then((tasks) => tasks!
            .map((task) => Course(
                  author: "",
                  title: task.filename!,
                  description: "",
                  files: [
                    CourseFile(
                      key: task.filename!,
                      url: task.url,
                      name: task.filename!,
                    )
                  ],
                  downloads: 0,
                ))
            .toList());
  }
}
