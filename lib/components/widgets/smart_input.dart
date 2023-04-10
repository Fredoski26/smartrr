import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartrr/utils/colors.dart';

class SmartInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Widget? widget;
  final String errorText;
  final bool isRequired;
  final String? Function(dynamic)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final Function(String)? onSubmitted;

  const SmartInput({
    super.key,
    required this.controller,
    required this.label,
    this.widget,
    this.validator,
    this.isRequired = false,
    this.errorText = "Field is required",
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters = const [],
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 6),
        widget != null
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.5),
                decoration: BoxDecoration(
                  color: inputBackground,
                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                ),
                child: widget,
              )
            : TextFormField(
                controller: controller,
                obscureText: obscureText,
                keyboardType: keyboardType,
                validator: validator ??
                    (value) {
                      if (value!.isEmpty && isRequired) {
                        return errorText;
                      }
                      return null;
                    },
                style: TextStyle().copyWith(color: darkGrey),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: inputBackground,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                inputFormatters: inputFormatters,
                onFieldSubmitted: onSubmitted,
              ),
        SizedBox(height: 13),
      ],
    );
  }
}
