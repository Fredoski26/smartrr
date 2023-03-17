import 'package:smartrr/services/local_notification_service.dart';
import "package:timezone/timezone.dart" as tz;

class FertilityCalculator {
  int cycleLength;
  DateTime lastPeriod;
  int lutealPhaseLength;
  DateTime lastCalendarDay;

  FertilityCalculator({
    required this.cycleLength,
    required this.lastPeriod,
    required this.lastCalendarDay,
    this.lutealPhaseLength = 14,
  });

  final location = tz.getLocation("Africa/Lagos");

  List<List<DateTime>> get menstrualCycle {
    List<List<DateTime>> menstrualCycle = [];
    DateTime lastPeriodDay = lastPeriod;

    // Record period from when user first joined
    List<DateTime> firstCyclePeriod = [lastPeriodDay];
    // flow for the next four consecutive days
    for (int i = 1; i <= 4; i++) {
      firstCyclePeriod.add(firstCyclePeriod.first.add(Duration(days: i)));
    }

    menstrualCycle.add(firstCyclePeriod);
    // =====================================

    // Record the rest of the cycles
    DateTime nextCycleFirstPeriod =
        lastPeriodDay.add(Duration(days: cycleLength));
// repeat till the calendar is exhausted
    while (lastCalendarDay.isAfter(nextCycleFirstPeriod)) {
      // store first day of flow in a new cycle
      List<DateTime> period = [nextCycleFirstPeriod];
      // flow for the next four consecutive days
      for (int i = 1; i <= 4; i++) {
        period.add(period.first.add(Duration(days: i)));
      }

      menstrualCycle.add(period);
      // update last period to the last day of the current cycle
      lastPeriodDay = period.first;
      nextCycleFirstPeriod = lastPeriodDay.add(Duration(days: cycleLength));

      // schedule notification for first day of period
      // if (!LocalNotificationService.hasBeenScheduled(period.first)) {
      //   LocalNotificationService.scheduleNotification(
      //     title: "Prediction: It's that time of the month",
      //     body:
      //         "Your period might start today, ensure you have your pads with you",
      //     scheduledDate: tz.TZDateTime(
      //       location,
      //       period.first.year,
      //       period.first.month,
      //       period.first.day,
      //       period.first.hour,
      //       period.first.minute,
      //     ),
      //   );
      // }
      // // schedule notification for last day of period
      // if (!LocalNotificationService.hasBeenScheduled(period.last)) {
      //   LocalNotificationService.scheduleNotification(
      //     title: "Prediction: Last day of period",
      //     body: "Today is the last day of your period",
      //     scheduledDate: tz.TZDateTime(
      //       location,
      //       period.last.year,
      //       period.last.month,
      //       period.last.day,
      //       period.last.hour,
      //       period.last.minute,
      //     ),
      //   );
      // }
    }
    // =================================================
    return menstrualCycle;
  }

  List<DateTime> get ovulation {
    List<DateTime> ovulationByCycle = [];

    DateTime nextCycleOvulation =
        lastPeriod.add(Duration(days: cycleLength - lutealPhaseLength));

    while (lastCalendarDay.isAfter(nextCycleOvulation)) {
      ovulationByCycle.add(nextCycleOvulation);

      // schedule notification for ovulation day
      // if (!LocalNotificationService.hasBeenScheduled(nextCycleOvulation)) {
      //   LocalNotificationService.scheduleNotification(
      //     title: "Prediction: Ovulation Day",
      //     body: "Today is your most fertile day of the month",
      //     scheduledDate: tz.TZDateTime(
      //       location,
      //       nextCycleOvulation.year,
      //       nextCycleOvulation.month,
      //       nextCycleOvulation.day,
      //       nextCycleOvulation.hour,
      //       nextCycleOvulation.minute,
      //     ),
      //   );
      // }

      lastPeriod = lastPeriod.add(Duration(days: cycleLength));
      nextCycleOvulation =
          lastPeriod.add(Duration(days: cycleLength - lutealPhaseLength));
    }

    return ovulationByCycle;
  }

  List<List<DateTime>> get fertileWindow {
    int fertileWindowStart = cycleLength - 19;
    int fertileWindowEnd = cycleLength - 12;

    List<List<DateTime>> menstrualCycle = [];
    DateTime nextCycleFirstPeriod = lastPeriod.add(Duration(days: cycleLength));

// record first fertile window
    DateTime fertileWindowFirstDay =
        lastPeriod.add(Duration(days: fertileWindowStart));
    DateTime fertileWindowEndDay =
        lastPeriod.add(Duration(days: fertileWindowEnd));
    int differenceInDays =
        fertileWindowEndDay.difference(fertileWindowFirstDay).inDays;

    List<DateTime> fertileWindow = [];
    while (differenceInDays > 0) {
      fertileWindow.add(
          lastPeriod.add(Duration(days: fertileWindowEnd - differenceInDays)));
      differenceInDays--;
    }
    menstrualCycle.add(fertileWindow);

    // =============================================
    // record  fertile period for following months
    while (lastCalendarDay.isAfter(nextCycleFirstPeriod)) {
      DateTime fertileWindowFirstDay =
          nextCycleFirstPeriod.add(Duration(days: fertileWindowStart));
      DateTime fertileWindowEndDay =
          nextCycleFirstPeriod.add(Duration(days: fertileWindowEnd));
      int differenceInDays =
          fertileWindowEndDay.difference(fertileWindowFirstDay).inDays;

      List<DateTime> fertileWindow = [];
      while (differenceInDays > 0) {
        fertileWindow.add(nextCycleFirstPeriod
            .add(Duration(days: fertileWindowEnd - differenceInDays)));
        differenceInDays--;
      }
      menstrualCycle.add(fertileWindow);
      nextCycleFirstPeriod =
          nextCycleFirstPeriod.add(Duration(days: cycleLength));

      // schedule notification for the first fertile window day of the cycle
      // if (!LocalNotificationService.hasBeenScheduled(fertileWindowFirstDay)) {
      //   LocalNotificationService.scheduleNotification(
      //     title: "Fertile window starts today",
      //     body: "Your most fertile week is about to start",
      //     scheduledDate: tz.TZDateTime(
      //       location,
      //       fertileWindowFirstDay.year,
      //       fertileWindowFirstDay.month,
      //       fertileWindowFirstDay.day,
      //       fertileWindowFirstDay.hour,
      //       fertileWindowFirstDay.minute,
      //     ),
      //   );
      // }
      // // schedule notification for the last fertile window day of the cycle
      // if (!LocalNotificationService.hasBeenScheduled(fertileWindowEndDay)) {
      //   LocalNotificationService.scheduleNotification(
      //     title: "Prediction: Fertile window starts today",
      //     body: "Your most fertile week ends today",
      //     scheduledDate: tz.TZDateTime(
      //       location,
      //       fertileWindowEndDay.year,
      //       fertileWindowEndDay.month,
      //       fertileWindowEndDay.day,
      //       fertileWindowEndDay.hour,
      //       fertileWindowEndDay.minute,
      //     ),
      //   );
      // }
    }
    return menstrualCycle;
  }
}
