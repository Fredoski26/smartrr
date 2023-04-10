import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:smartrr/components/screens/period_tracker/cycle_settings.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:smartrr/utils/utils.dart';

class PeriodTrackerOnboarding extends StatefulWidget {
  const PeriodTrackerOnboarding({super.key});

  @override
  State<PeriodTrackerOnboarding> createState() =>
      _PeriodTrackerOnboardingState();
}

class _PeriodTrackerOnboardingState extends State<PeriodTrackerOnboarding> {
  int _stepIndex = 0;
  DateTime now = DateTime.now();
  int? birthYear;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) =>
            ScaleTransition(child: child, scale: animation),
        child: IndexedStack(
          key: ValueKey<int>(_stepIndex),
          index: _stepIndex,
          children: [_welcomePage(), _selectDOB()],
        ));
  }

  Widget _welcomePage() {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: SvgPicture.asset(
                    "assets/images/menstrual-calendar-pana.svg",
                    allowDrawingOutsideViewBox: true,
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
      ),
    );
  }

  Widget _selectDOB() {
    final List<int> years = List.generate(
      100,
      (index) => (now.year - (index + 16)),
      growable: true,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Period Tracker",
          style: TextStyle().copyWith(color: materialWhite),
        ),
        backgroundColor: primaryColor,
        iconTheme: IconThemeData().copyWith(color: materialWhite),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "What year were you born?",
            style: TextStyle().copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              height: 2,
            ),
          ),
          Container(
            width: 235,
            child: Text(
              "Cycle predictions will be more accurate if period tracker knows your age.",
              textAlign: TextAlign.center,
              style: TextStyle().copyWith(fontSize: 12),
            ),
          ),
          Container(
            height: 500,
            margin: EdgeInsets.only(top: 50, bottom: 50),
            child: CupertinoPicker(
              squeeze: .8,
              diameterRatio: 3,
              children: years
                  .map((year) => Center(child: Text(year.toString())))
                  .toList(),
              itemExtent: 50,
              onSelectedItemChanged: ((index) => {birthYear = years[index]}),
              looping: true,
            ),
          ),
          TextButton(onPressed: _onContinue, child: Text("Continue"))
        ],
      ),
    );
  }

  _onContinue() {
    if (birthYear != null) {
      Hive.box("period_tracker").put("birthYear", birthYear);
      return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CycleSettings(),
        ),
      );
    }
    showToast(msg: "Select birth year");
  }
}
