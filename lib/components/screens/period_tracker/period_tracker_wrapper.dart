import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:smartrr/components/screens/period_tracker/period_tracker.dart';
import 'package:smartrr/components/screens/period_tracker/period_tracker_onboarding.dart';

class PeriodTrackerWrapper extends StatefulWidget {
  const PeriodTrackerWrapper({super.key});

  @override
  State<PeriodTrackerWrapper> createState() => _PeriodTrackerWrapperState();
}

class _PeriodTrackerWrapperState extends State<PeriodTrackerWrapper> {
  dynamic lastPeriod = Hive.box("period_tracker").get("lastPeriod");

  @override
  Widget build(BuildContext context) {
    if (lastPeriod == null) {
      return PeriodTrackerOnboarding();
    }
    return PeriodTracker();
  }
}
