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

  List<List<DateTime>> get nextPeriod {
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
      List<DateTime> period = [lastPeriodDay.add(Duration(days: cycleLength))];
      // flow for the next four consecutive days
      for (int i = 1; i <= 4; i++) {
        period.add(period.first.add(Duration(days: i)));
      }

      menstrualCycle.add(period);
      // update last period to the last day of the current cycle
      lastPeriodDay = period.first.add(Duration(days: 1));
      nextCycleFirstPeriod = lastPeriodDay.add(Duration(days: cycleLength));
    }
    // =================================================

    return menstrualCycle;
  }

  DateTime get ovulation {
    return lastPeriod.add(Duration(days: cycleLength - lutealPhaseLength));
  }

  List<List<DateTime>> get fertileWindow {
    int fertileWindowStart = cycleLength - 18;
    int fertileWindowEnd = cycleLength - 11;

    List<List<DateTime>> menstrualCycle = [];
    DateTime nextCycleFirstPeriod = lastPeriod.add(Duration(days: cycleLength));

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
            .add(Duration(days: fertileWindowEnd - differenceInDays, hours: 1))
            .toUtc());
        differenceInDays--;
      }
      menstrualCycle.add(fertileWindow);
      nextCycleFirstPeriod =
          nextCycleFirstPeriod.add(Duration(days: cycleLength));
    }

    return menstrualCycle;
  }
}
