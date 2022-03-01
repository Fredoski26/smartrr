import 'package:flutter/material.dart';
import 'text_box.dart';

smartTextField({
  @required String title,
  @required TextEditingController controller,
  Function onTap,
  bool readOnly = false,
  bool isPhone = false,
  bool required = true,
  double bottomPadding = 20,
  bool obscure = false,
  TextInputType textInputType = TextInputType.text,
  bool isForm = false,
  Widget prefix,
  Widget suffixIcon,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      isPhone
          ? CustomPhoneTextBox(
              required: required,
              controller: controller,
              onTap: onTap,
              readOnly: readOnly,
              obscureText: obscure,
              keyboardType: textInputType,
              isForm: isForm,
              prefix: prefix,
              placeholderColor: Color(0xA59B9BFF),
              placeholderText: title,
            )
          : CustomTextBox(
              required: required,
              controller: controller,
              onTap: onTap,
              readOnly: readOnly,
              obscureText: obscure,
              keyboardType: textInputType,
              isForm: isForm,
              placeholderColor: Color(0xA59B9BFF),
              placeholderText: title,
              suffixIcon: suffixIcon,
            ),
      SizedBox(
        height: bottomPadding,
      ),
    ],
  );
}
