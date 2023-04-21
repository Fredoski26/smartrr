import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:smartrr/components/screens/course/course_tile.dart';
import 'package:smartrr/models/course.dart';
import 'package:smartrr/services/course_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class MyDownload {
  final String courseId;
  final String taskId;
  final DownloadTaskStatus status;
  final String url;

  MyDownload({
    required this.courseId,
    required this.taskId,
    required this.url,
    this.status = DownloadTaskStatus.undefined,
  });
}

class Courses extends StatefulWidget {
  const Courses({super.key});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  User _currentUser = FirebaseAuth.instance.currentUser!;
  Map<String, Course> downloads = {};

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
              itemBuilder: (context, index) => CourseTile(
                course: courses[index],
                startDownload: startDownload,
                pauseDownload: pauseDownload,
                resumeDownload: resumeDownload,
                cancelDownload: cancelDownload,
                downloadStatus: getCourseDownloadStatus(courses[index]),
              ),
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

  DownloadTaskStatus getCourseDownloadStatus(Course course) {
    final elements = downloads.entries
        .toList()
        .where((element) => element.value.id == course.id);
    if (elements.isNotEmpty) {
      final downloadTask = downloads[elements.first.key];
      if (downloadTask != null) {
        return downloadTask.downloadStatus;
      }
    }

    return course.downloadStatus;
  }

  requestPermissions() async {
    final storagePermission = await Permission.storage.status;

    if (storagePermission.isDenied) {
      await Permission.storage.request();
    }
  }

  updateDownloads(String taskId, Course course) {
    downloads[taskId] = course;
    print(downloads);
  }

  Future startDownload(Course course) async {
    Directory _path = await getApplicationDocumentsDirectory();
    String _localPath = _path.path + Platform.pathSeparator + course.file.name;

    final savedDir = Directory(_localPath);

    await savedDir.create(recursive: true);

    final id = await FlutterDownloader.enqueue(
      url: course.file.url,
      fileName: course.file.name,
      headers: {},
      savedDir: _localPath,
      showNotification: true,
      openFileFromNotification: true,
    );

    updateDownloads(id!, course);
  }

  void pauseDownload(String courseId) async {
    downloads.forEach((key, value) async {
      if (value.id == courseId) {
        await FlutterDownloader.pause(taskId: key);
      }
    });
  }

  void cancelDownload(String courseId) {
    downloads.forEach((key, value) async {
      if (value.id == courseId) {
        await FlutterDownloader.cancel(taskId: key);
      }
    });
  }

  void resumeDownload(String courseId) async {
    downloads.forEach((key, value) async {
      if (value.id == courseId) {
        final String? newTaskId = await FlutterDownloader.resume(taskId: key);

        downloads.remove(key);
        updateDownloads(newTaskId!, value);
      }
    });
  }

  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    requestPermissions();

    IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    _port.listen((dynamic data) {
      String id = data[0];
      int status = data[1];
      int progress = data[2];

      Course? course = downloads[id];
      if (course != null) {
        updateDownloads(
            id,
            Course(
              id: course.id,
              title: course.title,
              author: course.author,
              description: course.description,
              file: course.file,
              downloadStatus: DownloadTaskStatus(status),
              downloads: 0,
            ));
        setState(() {});

        if (DownloadTaskStatus(status) == DownloadTaskStatus.complete) {
          CourseService.captureDownload(_currentUser.uid, course.id);
        }
      }

      if (DownloadTaskStatus(status) == DownloadTaskStatus.failed) {
        downloads.remove(id);
      }
    });
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }
}
