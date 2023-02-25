import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:smartrr/components/screens/period_tracker/period_tracker.dart';
import 'package:smartrr/components/screens/period_tracker/period_tracker_onboarding.dart';

class PeriodTrackerWrapper extends StatelessWidget {
  const PeriodTrackerWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    dynamic lastPeriod = Hive.box("period_tracker").get("lastPeriod");

    if (lastPeriod == null) {
      return PeriodTrackerOnboarding();
    }
    return PeriodTracker();
  }
}
