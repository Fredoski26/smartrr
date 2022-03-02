import 'package:flutter/material.dart';

class CustomTextBox extends StatelessWidget {
  final String placeholderText;
  final Color borderColor;
  final Color textColor;
  final bool required;
  final bool same;
  final String password;
  final Color placeholderColor;
  final String errorText;
  final Color textboxBackgroundColor;
  final TextEditingController controller;
  final bool obscureText;
  final bool readOnly;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final Function onTap;
  final bool isForm;
  final Icon suffixIcon;

  CustomTextBox(
      {this.focusNode,
      this.placeholderText,
      this.borderColor = const Color(0xFFA59B9B),
      this.textColor = const Color(0xFFA59B9B),
      this.placeholderColor = Colors.white,
      this.textboxBackgroundColor = Colors.white,
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
      this.suffixIcon = null});

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
              validator: (value) {
                if (value.isEmpty && required) {
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
                  hintStyle: TextStyle(color: placeholderColor)),
            )
          : TextField(
              onTap: onTap,
              focusNode: focusNode,
              keyboardType: keyboardType,
              obscureText: obscureText,
              readOnly: readOnly,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
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
                  hintStyle: TextStyle(color: placeholderColor)),
            ),
    );
  }
}

class CustomPhoneTextBox extends StatelessWidget {
  final String placeholderText;
  final Color borderColor;
  final Color textColor;
  final bool required;
  final bool same;
  final String password;
  final Color placeholderColor;
  final String errorText;
  final Color textboxBackgroundColor;
  final TextEditingController controller;
  final bool obscureText;
  final bool readOnly;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final Function onTap;
  final bool isForm;
  final Widget prefix;
  final String counterText;

  CustomPhoneTextBox(
      {this.focusNode,
      this.placeholderText,
      this.prefix,
      this.borderColor = const Color(0xFFA59B9B),
      this.textColor = const Color(0xFFA59B9B),
      this.placeholderColor = const Color(0xFFA59B9B),
      this.textboxBackgroundColor = Colors.white,
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
              maxLength: 10,
              validator: (value) {
                if (value.isEmpty && required) {
                  return errorText;
                }
                return null;
              },
              style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
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
              maxLength: 10,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
              controller: controller,
              decoration: InputDecoration(
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
                      color: placeholderColor, fontWeight: FontWeight.w700)),
            ),
    );
  }
}
