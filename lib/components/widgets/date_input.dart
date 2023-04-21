import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInputField extends StatefulWidget {
  final Function? onDateSelected;
  final TextEditingController controller;

  const DateInputField({
    this.onDateSelected,
    required this.controller,
  });
  @override
  _DateInputFieldState createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputField> {
  // Declare a variable to hold the selected date
  DateTime? _selectedDate;

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        widget.controller.text = DateFormat('dd-MM-yyyy').format(pickedDate);
        _selectedDate = pickedDate;
        widget.onDateSelected != null
            ? widget.onDateSelected!(pickedDate)
            : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextFormField(
          controller: widget.controller,
          validator: (value) =>
              value == null || value.isEmpty ? "Field is required" : null,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}
