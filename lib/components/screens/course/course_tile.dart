import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smartrr/models/course.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class CourseTile extends StatefulWidget {
  final Course course;
  const CourseTile({super.key, required this.course});

  @override
  State<CourseTile> createState() => _CourseTileState();

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) {
    final SendPort sendPort =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;

    sendPort.send([id, status.value, progress]);
  }
}

class _CourseTileState extends State<CourseTile> {
  late String _taskId;

  late DownloadTaskStatus _status = DownloadTaskStatus.undefined;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.course.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        widget.course.description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: Icon(Icons.file_copy),
      onTap: _status == DownloadTaskStatus.complete
          ? () async {
              await FlutterDownloader.open(taskId: _taskId);
            }
          : null,
      trailing: _status == DownloadTaskStatus.complete ||
              _status == DownloadTaskStatus.failed
          ? IconButton(
              icon: Icon(Icons.file_download_done),
              tooltip: "Open",
              onPressed: () async {
                await FlutterDownloader.open(taskId: _taskId);
              })
          : _status == DownloadTaskStatus.undefined
              ? IconButton(
                  icon: Icon(Icons.file_download),
                  tooltip: "Download",
                  onPressed: () async {
                    await startDownload(
                      widget.course.files[0].url,
                      widget.course.files[0].key.split("/")[1],
                    );
                  },
                )
              : _status == DownloadTaskStatus.paused
                  ? IconButton(
                      icon: Icon(Icons.play_circle_outline),
                      tooltip: "Play",
                      onPressed: () => resumeDownload(_taskId),
                    )
                  : IconButton(
                      icon: Icon(Icons.pause_circle_outline),
                      tooltip: "Pause",
                      onPressed: () => pauseDownload(_taskId),
                    ),
    );
  }

  Future<String> startDownload(String url, String fileName) async {
    Directory _path = await getApplicationDocumentsDirectory();
    String _localPath = _path.path + Platform.pathSeparator + fileName;

    final savedDir = Directory(_localPath);

    await savedDir.create(recursive: true);

    final taskId = await FlutterDownloader.enqueue(
      url: url,
      fileName: fileName,
      headers: {},
      savedDir: _localPath,
      saveInPublicStorage: true,
      showNotification: true,
      openFileFromNotification: true,
    );

    _taskId = taskId!;

    return taskId;
  }

  void pauseDownload(String taskId) {
    FlutterDownloader.pause(taskId: taskId);
  }

  void cancelDownload(String taskId) {
    FlutterDownloader.cancel(taskId: taskId);
  }

  void resumeDownload(String taskId) async {
    final String? newTaskId = await FlutterDownloader.resume(taskId: taskId);
    _taskId = newTaskId!;
  }

  void loadTasks() {
    FlutterDownloader.loadTasks().then((tasks) {
      final task = tasks
          ?.where((element) => element.url == widget.course.files[0].url)
          .first;
      if (task != null) {
        _status = task.status;
        _taskId = task.taskId;
      }
      setState(() {});
    });
  }

  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    loadTasks();

    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (isSuccess) {
      _port.listen((dynamic data) {
        String id = data[0];
        int status = data[1];
        int progress = data[2];

        _status = DownloadTaskStatus(status);

        if (_status == DownloadTaskStatus.failed) {
          FlutterDownloader.remove(taskId: id);
        }
        setState(() {});
      });

      FlutterDownloader.registerCallback(CourseTile.downloadCallback);
    } else {
      print("ISOLATE CREATION FAILED");
    }
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }
}
