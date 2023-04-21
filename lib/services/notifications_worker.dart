import 'package:flutter/material.dart';
import 'package:smartrr/env/env.dart';
import 'package:smartrr/models/smart_notification.dart';
import 'package:smartrr/services/local_notification_service.dart';
import 'package:smartrr/services/period_tracker_service.dart';
import 'package:smartrr/utils/fertilityCalculator.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workmanager/workmanager.dart';

class NotificationsWorker {
  @pragma(
      'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      try {
        print("Native called background task: $task");

        _handlePeriodNotification();
        _handleFertileWindowNotification();
        _handleOvulationNotification();
      } catch (e) {
        debugPrint(e.toString());
        throw Exception(e);
      }

      return Future.value(true);
    });
  }

  static void _handlePeriodNotification() {
    final DateTime today = DateTime.now();

    final mestrualCycle = FertilityCalculator(
      lastCalendarDay: DateTime(DateTime.now().year + 1),
      cycleLength: PeriodTrackerService.getCycleLength!,
      lastPeriod: PeriodTrackerService.getLastPeriod!,
      lutealPhaseLength: PeriodTrackerService.getLutealPhaseLength!,
    ).menstrualCycle;

    mestrualCycle.forEach((cycle) {
      if (isSameDay(today, cycle.first)) {
        LocalNotificationService.showNotification(
            notification: SmartNotification(
          title: "Prediction: It's that time of the month",
          body:
              "Your period might start today, ensure you have your pads with you",
        ));
      } else if (isSameDay(today, cycle.last)) {
        LocalNotificationService.showNotification(
            notification: SmartNotification(
          title: "Prediction: Last day of period",
          body: "Today is the last day of your period",
        ));
      }
    });
  }

  static void _handleOvulationNotification() {
    final DateTime today = DateTime.now();

    final ovulationDays = FertilityCalculator(
      lastCalendarDay: DateTime(DateTime.now().year + 1),
      cycleLength: PeriodTrackerService.getCycleLength!,
      lastPeriod: PeriodTrackerService.getLastPeriod!,
      lutealPhaseLength: PeriodTrackerService.getLutealPhaseLength!,
    ).ovulation;

    ovulationDays.forEach((day) {
      if (isSameDay(today, day)) {
        LocalNotificationService.showNotification(
            notification: SmartNotification(
          title: "Prediction: Ovulation Day",
          body: "Today is your most fertile day of the month",
        ));
      }
    });
  }

  static void _handleFertileWindowNotification() {
    final DateTime today = DateTime.now();

    final fertileWindows = FertilityCalculator(
      lastCalendarDay: DateTime(DateTime.now().year + 1),
      cycleLength: PeriodTrackerService.getCycleLength!,
      lastPeriod: PeriodTrackerService.getLastPeriod!,
      lutealPhaseLength: PeriodTrackerService.getLutealPhaseLength!,
    ).fertileWindow;

    fertileWindows.forEach((fertileWindow) {
      if (isSameDay(today, fertileWindow.first)) {
        LocalNotificationService.showNotification(
            notification: SmartNotification(
          title: "Fertile window starts today",
          body: "Your most fertile week is about to start",
        ));
      } else if (isSameDay(today, fertileWindow.last)) {
        LocalNotificationService.showNotification(
            notification: SmartNotification(
          title: "Prediction: Fertile window ends today",
          body: "Your most fertile week ends today",
        ));
      }
    });
  }

  Future initialize() async {
    Workmanager().initialize(callbackDispatcher, isInDebugMode: Env.debugMode);
    print("TASK MANAGER INITIALIZED");

    Workmanager().registerPeriodicTask(
      DateTime.now().millisecondsSinceEpoch.toString(),
      "CHECK_NOTIFICATION_TASK",
      existingWorkPolicy: ExistingWorkPolicy.replace,
      // frequency: Duration(hours: 24),
    );
  }
}
