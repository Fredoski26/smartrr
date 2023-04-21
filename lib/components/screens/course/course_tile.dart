import 'package:flutter/material.dart';
import 'package:smartrr/models/course.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class CourseTile extends StatefulWidget {
  final Course course;
  final Function(Course) startDownload;
  final Function(String) pauseDownload;
  final Function(String) resumeDownload;
  final Function(String) cancelDownload;
  final DownloadTaskStatus downloadStatus;

  const CourseTile({
    super.key,
    required this.course,
    required this.startDownload,
    required this.pauseDownload,
    required this.resumeDownload,
    required this.cancelDownload,
    this.downloadStatus = DownloadTaskStatus.undefined,
  });

  @override
  State<CourseTile> createState() => _CourseTileState();
}

class _CourseTileState extends State<CourseTile> {
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
      onTap: widget.downloadStatus == DownloadTaskStatus.complete
          ? () async {
              await openFile(widget.course.file.url);
            }
          : null,
      trailing: widget.downloadStatus == DownloadTaskStatus.complete
          ? Icon(Icons.file_download_done)
          : widget.downloadStatus == DownloadTaskStatus.undefined ||
                  widget.downloadStatus == DownloadTaskStatus.failed
              ? IconButton(
                  icon: Icon(Icons.file_download),
                  tooltip: "Download",
                  onPressed: () async {
                    await widget.startDownload(widget.course);
                  },
                )
              : widget.downloadStatus == DownloadTaskStatus.paused
                  ? IconButton(
                      icon: Icon(Icons.play_circle_outline),
                      tooltip: "Play",
                      onPressed: () => widget.resumeDownload(widget.course.id),
                    )
                  : IconButton(
                      icon: Icon(Icons.pause_circle_outline),
                      tooltip: "Pause",
                      onPressed: () => widget.pauseDownload(widget.course.id),
                    ),
    );
  }

  Future openFile(String url) async {
    final downloadTask = await FlutterDownloader.loadTasksWithRawQuery(
        query: "SELECT * FROM task WHERE status=3 AND url='$url'");

    if (downloadTask != null && downloadTask.isNotEmpty) {
      await FlutterDownloader.open(taskId: downloadTask.first.taskId);
    }
  }
}
