import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) validator;
  final bool isPasswordField;

  AuthTextField(
      {required this.controller,
      required this.validator,
      this.isPasswordField = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPasswordField,
      controller: controller,
      validator: (val) => validator(val!),
      decoration: InputDecoration(
        hintTextDirection: TextDirection.ltr,
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xffB4B4B4))),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xffB4B4B4))),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xffB4B4B4))),
      ),
    );
  }
}
