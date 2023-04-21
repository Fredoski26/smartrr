import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:timezone/timezone.dart';

part 'smart_notification.g.dart';

@HiveType(typeId: 6)
class SmartNotification {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String body;
  @HiveField(2)
  NotificationDetails notificationDetails;

  SmartNotification({
    required this.title,
    required this.body,
    this.notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
        "GENERAL",
        "General",
        icon: "@mipmap/ic_launcher",
        priority: Priority.max,
        color: primaryColor,
        ticker: "ticker",
        importance: Importance.max,
      ),
    ),
  });
}

@HiveType(typeId: 7)
class SmartNotificationSchedule {
  @HiveField(0)
  final SmartNotification notification;
  @HiveField(1)
  final DateTime scheduledDate;
  @HiveField(2)
  final bool hasShown;

  SmartNotificationSchedule({
    required this.notification,
    required this.scheduledDate,
    this.hasShown = false,
  });
}
