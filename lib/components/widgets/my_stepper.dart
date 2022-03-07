import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:smartrr/utils/colors.dart';

class MyStepper extends StatelessWidget {
  final int activeIndex;
  MyStepper({this.activeIndex = 0});
  @override
  Widget build(BuildContext context) {
    return NumberStepper(
      enableNextPreviousButtons: false,
      enableStepTapping: false,
      stepColor: lightGrey,
      activeStepColor: primaryColor,
      activeStepBorderColor: primaryColor,
      scrollingDisabled: false,
      lineColor: lightGrey,
      stepRadius: 16,
      activeStep: activeIndex,
      numberStyle: TextStyle(color: Colors.white),
      numbers: [1, 2, 3, 4, 5, 6],
    );
  }
}
