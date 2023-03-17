import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:timezone/data/latest.dart' as tz;
import "package:timezone/timezone.dart";

abstract class LocalNotificationService {
  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final _notificationsBox = Hive.box("notifications");

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

    tz.initializeTimeZones();
    print(_notificationsBox.keys);
  }

  Future onSelectNotification(notificationResponse) async {
    print(notificationResponse);
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  static Future<bool> scheduleNotification({
    required String title,
    required String body,
    required TZDateTime scheduledDate,
    NotificationDetails? notificationDetails,
  }) async {
    try {
      final double dt = DateTime.now().millisecondsSinceEpoch / 1000;
      final int id = dt.toInt();

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        notificationDetails ?? _defaultNotificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
      );

      _notificationsBox.put(scheduledDate.toIso8601String(), {id: id});

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static bool hasBeenScheduled(DateTime datetime) {
    return _notificationsBox.containsKey(datetime.toIso8601String());
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
