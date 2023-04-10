import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInputField extends StatefulWidget {
  final dynamic? initialValue;
  final Function? onDateSelected;

  const DateInputField({this.onDateSelected, this.initialValue});
  @override
  _DateInputFieldState createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputField> {
  // Declare a variable to hold the selected date
  DateTime? _selectedDate;

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        widget.onDateSelected != null ? widget.onDateSelected!(picked) : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: widget.initialValue != null
                ? DateFormat('dd-MM-yyyy').format(widget.initialValue)
                : _selectedDate != null
                    ? DateFormat('dd-MM-yyyy').format(_selectedDate!)
                    : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          initialValue: widget.initialValue != null
              ? DateFormat('yyyy-MM-dd').format(widget.initialValue)
              : _selectedDate != null
                  ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                  : null,
        ),
      ),
    );
  }
}
