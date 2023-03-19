import 'package:flutter/material.dart';
import 'package:smartrr/utils/colors.dart';

class SmartFormDropDown extends StatelessWidget {
  final Function(dynamic) onChanged;
  final String hintText;
  final List<DropdownMenuItem> items;
  final dynamic value;
  const SmartFormDropDown({
    super.key,
    required this.items,
    required this.hintText,
    required this.onChanged,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: DropdownButtonFormField(
        items: items,
        hint: Text(hintText),
        value: value,
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: materialWhite,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        isExpanded: true,
      ),
    );
  }
}
