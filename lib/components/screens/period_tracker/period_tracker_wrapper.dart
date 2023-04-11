import 'package:flutter/src/widgets/framework.dart';
import 'package:smartrr/components/screens/period_tracker/period_tracker.dart';
import 'package:smartrr/components/screens/period_tracker/period_tracker_onboarding.dart';
import 'package:smartrr/services/period_tracker_service.dart';

class PeriodTrackerWrapper extends StatefulWidget {
  const PeriodTrackerWrapper({super.key});

  @override
  State<PeriodTrackerWrapper> createState() => _PeriodTrackerWrapperState();
}

class _PeriodTrackerWrapperState extends State<PeriodTrackerWrapper> {
  dynamic lastPeriod = PeriodTrackerService.getLastPeriod;

  @override
  Widget build(BuildContext context) {
    if (lastPeriod == null) {
      return PeriodTrackerOnboarding();
    }
    return PeriodTracker();
  }
}
