import 'dart:math';

import 'package:flutter/foundation.dart';
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import 'package:timezone/timezone.dart' as tz;

abstract class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future initialize() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    await flutterLocalNotificationsPlugin.show(
      Random().nextInt(2 ^ 32),
      "Initialization successful",
      "Notifications plugin successfully initialized",
      NotificationDetails(
        android: AndroidNotificationDetails(
          "GENERAL",
          "General",
          "",
          icon: "@mipmap/ic_launcher",
          priority: Priority.max,
        ),
      ),
    );
  }

  Future onSelectNotification(notificationResponse) async {
    print(notificationResponse);
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  static void scheduleNotification({
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    NotificationDetails notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
        "GENERAL",
        "General",
        "",
        icon: "@mipmap/ic_launcher",
        priority: Priority.max,
      ),
    ),
  }) {
    flutterLocalNotificationsPlugin.zonedSchedule(
      DateTime.now().millisecondsSinceEpoch,
      title,
      body,
      scheduledDate,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
}
