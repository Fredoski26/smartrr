import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smartrr/models/smart_notification.dart';
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationService {
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
  }

  Future onSelectNotification(notificationResponse) async {
    print(notificationResponse);
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  static Future scheduleNotification({
    required SmartNotificationSchedule notificationSchedule,
  }) async {
    print("SCHEDULE DATE: ${notificationSchedule.scheduledDate}");
    await _notificationsBox.put(
      notificationSchedule.scheduledDate.millisecondsSinceEpoch,
      notificationSchedule,
    );
  }

  static Future<void> showNotification({
    required SmartNotification notification,
  }) async {
    final double dt = DateTime.now().millisecondsSinceEpoch / 1000;
    final int id = dt.toInt();
    _flutterLocalNotificationsPlugin.show(
      id,
      notification.title,
      notification.body,
      notification.notificationDetails,
    );
  }

  static bool hasBeenScheduled(int datetime) {
    return _notificationsBox.containsKey(datetime);
  }

  static Future cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    await _notificationsBox.clear();
  }

  static getNotification(int date) => _notificationsBox.get(date);

  static List get getAllNotificationDates => _notificationsBox.keys.toList();
}
