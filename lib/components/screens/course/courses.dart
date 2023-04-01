import 'package:flutter/material.dart';
import 'package:smartrr/components/screens/course/course_tile.dart';
import 'package:smartrr/models/course.dart';
import 'package:smartrr/services/course_service.dart';
import 'package:permission_handler/permission_handler.dart';

class Courses extends StatefulWidget {
  const Courses({super.key});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Course>>(
        stream: CourseService.getAllCourses().asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final courses = snapshot.data!;
            if (courses.length < 1) {
              return Center(
                child: Text("No courses availble"),
              );
            }
            return ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) =>
                  CourseTile(course: courses[index]),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  requestPermissions() async {
    final storagePermission = await Permission.storage.status;

    if (storagePermission.isDenied) {
      await Permission.storage.request();
    }
  }

  @override
  void initState() {
    requestPermissions();
    super.initState();
  }
}
