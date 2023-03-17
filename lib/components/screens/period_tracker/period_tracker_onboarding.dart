import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:smartrr/components/screens/period_tracker/period_tracker.dart';

class PeriodTrackerOnboarding extends StatefulWidget {
  const PeriodTrackerOnboarding({super.key});

  @override
  State<PeriodTrackerOnboarding> createState() =>
      _PeriodTrackerOnboardingState();
}

class _PeriodTrackerOnboardingState extends State<PeriodTrackerOnboarding> {
  int _stepIndex = 0;
  DateTime now = DateTime.now();
  DateTime? _lastPeriod = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) =>
              ScaleTransition(child: child, scale: animation),
          child: SafeArea(
            child: IndexedStack(
              key: ValueKey<int>(_stepIndex),
              index: _stepIndex,
              children: [_welcomePage(), _selectLastPeriod()],
            ),
          )),
    );
  }

  Widget _welcomePage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: SvgPicture.asset(
                  "assets/images/menstrual-calendar-pana.svg",
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Text(
                "Hello!",
                style: TextStyle()
                    .copyWith(fontSize: 40, fontWeight: FontWeight.w900),
              ),
              Text(
                "Welcome to SmartRR Period Tracker",
                style: TextStyle().copyWith(fontSize: 20),
              ),
              Text("Easily keep track of your period with no surprises")
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _stepIndex++;
                  });
                },
                icon: Icon(Icons.arrow_forward),
                label: Text(
                  "Get Started",
                )),
          ],
        )
      ],
    );
  }

  Widget _selectDOB() {
    return Column(
      children: [
        Text(
          "What year were you born?",
          style: TextStyle().copyWith(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          height: 500,
          child: CupertinoPicker(
            squeeze: .8,
            diameterRatio: 3,
            children: List.generate(
              100,
              (index) =>
                  Center(child: Text((now.year - (index + 16)).toString())),
              growable: true,
            ),
            itemExtent: 50,
            onSelectedItemChanged: ((value) => {print(value)}),
          ),
        ),
        ElevatedButton(
            onPressed: () {
              setState(() {
                _stepIndex++;
              });
            },
            child: Text("Continue"))
      ],
    );
  }

  Widget _selectLastPeriod() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "When did your last period start?",
          style: TextStyle().copyWith(fontSize: 20),
        ),
        CalendarDatePicker(
          initialDate: now,
          firstDate: DateTime(now.year - 100),
          lastDate: now,
          onDateChanged: (value) {
            setState(() {
              _lastPeriod = value;
            });
          },
        ),
        ElevatedButton(
          onPressed: _lastPeriod == null
              ? null
              : () async {
                  Hive.box("period_tracker")
                      .put("lastPeriod", _lastPeriod?.toLocal());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PeriodTracker(),
                    ),
                  );
                },
          child: Text(
            "Continue",
          ),
        )
      ],
    );
  }
}
