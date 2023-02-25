class FertilityCalculator {
  int cycleLength;
  DateTime lastPeriod;
  int lutealPhaseLength;

  FertilityCalculator({
    required this.cycleLength,
    required this.lastPeriod,
    this.lutealPhaseLength = 14,
  });

  DateTime get nextPeriod {
    return lastPeriod.add(Duration(days: cycleLength));
  }

  DateTime get ovulation {
    return lastPeriod.add(Duration(days: cycleLength - lutealPhaseLength));
  }

  List<DateTime> get fertileWindow {
    int fertileWindowStart = cycleLength - 18;
    int fertileWindowEnd = cycleLength - 11;

    DateTime fertileWindowFirstDay =
        lastPeriod.add(Duration(days: fertileWindowStart));
    DateTime fertileWindowEndDay =
        lastPeriod.add(Duration(days: fertileWindowEnd));
    int differenceInDays =
        fertileWindowEndDay.difference(fertileWindowFirstDay).inDays;

    List<DateTime> fertileWindow = [];
    while (differenceInDays > 0) {
      fertileWindow.add(lastPeriod
          .add(Duration(days: fertileWindowEnd - differenceInDays, hours: 1))
          .toUtc());
      differenceInDays--;
    }

    return fertileWindow;
  }
}
