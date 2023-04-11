import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartrr/components/widgets/smart_input.dart';
import 'package:smartrr/services/period_tracker_service.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:smartrr/components/widgets/date_input.dart';
import 'package:intl/intl.dart';

class CycleSettings extends StatefulWidget {
  final bool isOnboarding;
  const CycleSettings({super.key, this.isOnboarding = false});

  @override
  State<CycleSettings> createState() => _CycleSettingsState();
}

class _CycleSettingsState extends State<CycleSettings> {
  final _formKey = new GlobalKey<FormState>();
  final User _currenctUser = FirebaseAuth.instance.currentUser!;

  late DateTime? lastPeriod;

  late TextEditingController _cycleLengthController;
  late TextEditingController _periodLengthController;
  late TextEditingController _lutealPhaseLengthController;
  late TextEditingController _lastPeriodController;

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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.only(left: 30, top: 30, right: 30),
          children: [
            Text(
              "Please answer the following questions:",
              style: TextStyle().copyWith(fontSize: 18),
            ),
            Divider(height: 38),
            SmartInput(
              controller: _lastPeriodController,
              label: "When did your last period start?",
              widget: DateInputField(
                controller: _lastPeriodController,
                onDateSelected: _onDateSelected,
              ),
            ),
            SmartInput(
              controller: _cycleLengthController,
              label: "What is your cycle length?",
              keyboardType: TextInputType.number,
              isRequired: true,
            ),
            SmartInput(
              controller: _periodLengthController,
              label: "What is your period length?",
              keyboardType: TextInputType.number,
            ),
            SmartInput(
              controller: _lutealPhaseLengthController,
              label: "What is your luteal phase length?",
              keyboardType: TextInputType.number,
            ),
            TextButton(onPressed: _onSave, child: Text("Save"))
          ],
        ),
      ),
    );
  }

  _onDateSelected(DateTime value) {
    lastPeriod = value;
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      PeriodTrackerService.setLastPeriod(lastPeriod!.toLocal());
      PeriodTrackerService.setCycleLength(
          int.parse(_cycleLengthController.text));
      PeriodTrackerService.setPeriodLength(
          int.parse(_periodLengthController.text));
      PeriodTrackerService.setLutealPhaseLength(
          int.parse(_lutealPhaseLengthController.text));

      PeriodTrackerService(uid: _currenctUser.uid).updateDocument();

      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, "/periodTracker");
    }
  }

  @override
  void initState() {
    lastPeriod = PeriodTrackerService.getLastPeriod;
    _periodLengthController = new TextEditingController(text: "5");
    _cycleLengthController = new TextEditingController(text: "28");
    _lutealPhaseLengthController = new TextEditingController(text: "14");
    _lastPeriodController = new TextEditingController(
        text: lastPeriod != null
            ? DateFormat('yyyy-MM-dd').format(lastPeriod!)
            : null);
    super.initState();
  }
}
