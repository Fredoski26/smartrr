import 'package:flutter/material.dart';
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
              itemBuilder: (context, index) {
                final course = snapshot.data![index];
                return ListTile(
                  leading: Icon(Icons.file_copy),
                  title: Text(course.title),
                  subtitle: Text(course.description),
                  onTap: () async {
                    await FlutterDownloader.open(taskId: course.id);
                  },
                );
              },
            );
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
    final courses = FlutterDownloader.loadTasksWithRawQuery(query: query).then(
      (tasks) => tasks!
          .map(
            (task) => Course(
              id: task.taskId,
              author: "",
              title: task.filename!,
              description: "",
              file: CourseFile(
                key: task.filename!,
                url: task.url,
                name: task.filename!,
              ),
              downloads: 0,
              downloadStatus: task.status,
            ),
          )
          .toList(),
    );

    return courses;
  }
}
