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
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      isPhone ? CustomPhoneTextBox(
        required: required,
        controller: controller,
        onTap: onTap,
        readOnly: readOnly,
        obscureText: obscure,
        keyboardType: textInputType,
        isForm: isForm,
        prefix: prefix,
      ) : CustomTextBox(
        required: required,
        controller: controller,
        onTap: onTap,
        readOnly: readOnly,
        obscureText: obscure,
        keyboardType: textInputType,
        isForm: isForm,
      ),
      SizedBox(
        height: bottomPadding,
      ),
    ],
  );
}
