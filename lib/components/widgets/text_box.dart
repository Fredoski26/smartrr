import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextBox extends StatelessWidget {
  final String? placeholderText;
  final Color borderColor;
  final Color? textColor;
  final bool required;
  final bool same;
  final String? password;
  final Color placeholderColor;
  final String errorText;
  final Color textboxBackgroundColor;
  final TextEditingController? controller;
  final bool obscureText;
  final bool readOnly;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final dynamic onTap;
  final bool isForm;
  final Icon? suffixIcon;
  final dynamic validator;
  final List<TextInputFormatter>? inputFormatters;

  CustomTextBox(
      {this.focusNode,
      this.placeholderText,
      this.borderColor = const Color(0xFFA59B9B),
      this.textColor,
      this.placeholderColor = Colors.white,
      this.textboxBackgroundColor = Colors.transparent,
      this.controller,
      this.errorText = 'Field cannot be left empty',
      this.required = false,
      this.same = false,
      this.password,
      this.obscureText = false,
      this.readOnly = false,
      this.keyboardType = TextInputType.text,
      this.onTap,
      this.isForm = false,
      this.suffixIcon,
      this.validator,
      this.inputFormatters});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: textboxBackgroundColor,
      ),
      child: isForm
          ? TextFormField(
              inputFormatters: inputFormatters,
              onTap: onTap,
              focusNode: focusNode,
              keyboardType: keyboardType,
              obscureText: obscureText,
              readOnly: readOnly,
              validator: validator ??
                  (value) {
                    if (value!.isEmpty && required) {
                      return errorText;
                    }
                    return null;
                  },
              style: TextStyle(color: textColor),
              controller: controller,
              decoration: InputDecoration(
                  fillColor: Colors.green,
                  contentPadding:
                      new EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(33))),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(33))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(33))),
                  hintText: placeholderText,
                  hintStyle: TextStyle().copyWith(color: placeholderColor)),
            )
          : TextField(
              onTap: onTap,
              focusNode: focusNode,
              keyboardType: keyboardType,
              obscureText: obscureText,
              readOnly: readOnly,
              style: TextStyle().copyWith(color: textColor),
              controller: controller,
              decoration: InputDecoration(
                  suffixIcon: suffixIcon,
                  fillColor: Colors.green,
                  contentPadding:
                      new EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(33))),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(33))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(33))),
                  hintText: placeholderText,
                  hintStyle: TextStyle().copyWith(color: placeholderColor)),
            ),
    );
  }
}

class CustomPhoneTextBox extends StatelessWidget {
  final String? placeholderText;
  final Color borderColor;
  final Color textColor;
  final bool required;
  final bool same;
  final String? password;
  final Color? placeholderColor;
  final String errorText;
  final Color textboxBackgroundColor;
  final TextEditingController? controller;
  final bool obscureText;
  final bool readOnly;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final dynamic onTap;
  final bool isForm;
  final Widget? prefix;
  final String counterText;

  CustomPhoneTextBox(
      {this.focusNode,
      this.placeholderText,
      this.prefix,
      this.borderColor = const Color(0xFFA59B9B),
      this.textColor = Colors.white,
      this.placeholderColor = const Color(0xFFA59B9B),
      this.textboxBackgroundColor = Colors.transparent,
      this.controller,
      this.errorText = 'Field cannot be left empty',
      this.required = false,
      this.same = false,
      this.password,
      this.obscureText = false,
      this.readOnly = false,
      this.keyboardType = TextInputType.text,
      this.onTap,
      this.isForm = false,
      this.counterText = ""});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: textboxBackgroundColor,
      ),
      child: isForm
          ? TextFormField(
              onTap: onTap,
              focusNode: focusNode,
              keyboardType: keyboardType,
              obscureText: obscureText,
              readOnly: readOnly,
              maxLength: 14,
              validator: (value) {
                if (value!.isEmpty && required) {
                  return errorText;
                }
                return null;
              },
              style: TextStyle(color: textColor),
              controller: controller,
              decoration: InputDecoration(
                counterText: counterText,
                prefixIcon: prefix,
                fillColor: Colors.green,
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(33))),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(33))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(33))),
                hintText: placeholderText,
                hintStyle: TextStyle(
                  color: placeholderColor,
                ),
              ),
            )
          : TextField(
              onTap: onTap,
              focusNode: focusNode,
              keyboardType: keyboardType,
              obscureText: obscureText,
              readOnly: readOnly,
              maxLength: 14,
              style: TextStyle(color: textColor),
              controller: controller,
              decoration: InputDecoration(
                  counterText: counterText,
                  prefixIcon: prefix,
                  fillColor: Colors.green,
                  contentPadding:
                      new EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(33))),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(33))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(33))),
                  hintText: placeholderText,
                  hintStyle: TextStyle(color: placeholderColor)),
            ),
    );
  }
}
