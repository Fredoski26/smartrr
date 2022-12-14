import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartrr/utils/colors.dart';
import 'text_box.dart';

smartTextField({
  required String title,
  required TextEditingController controller,
  Function? onTap,
  bool readOnly = false,
  bool isPhone = false,
  bool required = true,
  double bottomPadding = 20,
  bool obscure = false,
  TextInputType textInputType = TextInputType.text,
  bool isForm = false,
  Widget? prefix,
  Icon? suffixIcon,
  Function? validator,
  List<TextInputFormatter>? inputFormatters,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      isPhone
          ? CustomPhoneTextBox(
              required: required,
              controller: controller,
              onTap: onTap!,
              readOnly: readOnly,
              obscureText: obscure,
              keyboardType: textInputType,
              isForm: isForm,
              prefix: prefix!,
              placeholderColor: lightGrey,
              placeholderText: title,
            )
          : CustomTextBox(
              required: required,
              controller: controller,
              onTap: onTap!,
              readOnly: readOnly,
              obscureText: obscure,
              keyboardType: textInputType,
              isForm: isForm,
              placeholderColor: lightGrey,
              placeholderText: title,
              suffixIcon: suffixIcon!,
              validator: validator!,
              inputFormatters: inputFormatters!,
            ),
      SizedBox(
        height: bottomPadding,
      ),
    ],
  );
}
