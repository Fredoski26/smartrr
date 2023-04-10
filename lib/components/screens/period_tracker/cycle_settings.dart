import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smartrr/components/screens/period_tracker/period_tracker.dart';
import 'package:smartrr/components/widgets/smart_input.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:smartrr/components/widgets/date_input.dart';

class CycleSettings extends StatefulWidget {
  const CycleSettings({super.key});

  @override
  State<CycleSettings> createState() => _CycleSettingsState();
}

class _CycleSettingsState extends State<CycleSettings> {
  final _periodTrackerBox = Hive.box("period_tracker");

  late DateTime lastPeriod;

  late TextEditingController cycleLengthController;
  late TextEditingController periodLengthController;
  late TextEditingController lutealPhaseLengthController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Period Tracker",
          style: TextStyle().copyWith(color: materialWhite),
        ),
        backgroundColor: primaryColor,
        iconTheme: IconThemeData().copyWith(color: materialWhite),
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 30, top: 30, right: 30),
        children: [
          Text(
            "Please answer the following questions:",
            style: TextStyle().copyWith(fontSize: 18),
          ),
          Divider(height: 38),
          SmartInput(
            controller: new TextEditingController(),
            label: "When did your last period start?",
            widget: DateInputField(
              onDateSelected: _onDateSelected,
              initialValue: lastPeriod,
            ),
          ),
          SmartInput(
            controller: cycleLengthController,
            label: "What is your cycle length?",
            keyboardType: TextInputType.number,
          ),
          SmartInput(
            controller: periodLengthController,
            label: "What is your period length?",
            keyboardType: TextInputType.number,
          ),
          SmartInput(
            controller: lutealPhaseLengthController,
            label: "What is your luteal phase length?",
            keyboardType: TextInputType.number,
          ),
          TextButton(onPressed: _onSave, child: Text("Save"))
        ],
      ),
    );
  }

  _onDateSelected(DateTime value) {
    lastPeriod = value;
  }

  void _onSave() {
    _periodTrackerBox.putAll({
      "lastPeriod": lastPeriod.toLocal(),
      "cycleLength": cycleLengthController.text,
      "periodLength": periodLengthController.text,
      "lutealPhaseLength": lutealPhaseLengthController.text
    });

    Navigator.popUntil(context, ModalRoute.withName("/periodTracker"));

    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => PeriodTracker()),
    // );
  }

  @override
  void initState() {
    lastPeriod = _periodTrackerBox.get("lastPeriod");
    periodLengthController = new TextEditingController(text: "5");
    cycleLengthController = new TextEditingController(text: "28");
    lutealPhaseLengthController = new TextEditingController(text: "14");
    super.initState();
  }
}
