import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import 'package:smartrr/utils/colors.dart';
import 'package:timezone/timezone.dart' as tz;

abstract class LocalNotificationService {
  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future initialize() async {
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();

    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    await _flutterLocalNotificationsPlugin.show(
      Random().nextInt(2 ^ 32),
      "Initialization successul",
      "Flutter local notifications initialization successul",
      _defaultNotificationDetails,
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
    NotificationDetails? notificationDetails,
  }) {
    final double dt = DateTime.now().millisecondsSinceEpoch / 1000;
    final int id = dt.toInt();

    _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails ?? _defaultNotificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  static final NotificationDetails _defaultNotificationDetails =
      NotificationDetails(
    android: AndroidNotificationDetails(
      "GENERAL",
      "General",
      icon: "@mipmap/ic_launcher",
      priority: Priority.max,
      color: primaryColor,
      ticker: "ticker",
      importance: Importance.max,
    ),
  );
}
