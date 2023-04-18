class FertilityCalculator {
  int cycleLength;
  DateTime lastPeriod;
  int lutealPhaseLength;
  DateTime lastCalendarDay;

  FertilityCalculator({
    required this.cycleLength,
    required this.lastPeriod,
    required this.lastCalendarDay,
    required this.lutealPhaseLength,
  });

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
    }
    return menstrualCycle;
  }
}
