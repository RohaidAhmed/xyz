import 'package:flutter/material.dart';
import 'package:patient_module/Configurations/app_config.dart';

// ignore: must_be_immutable
class DetailTextField extends StatelessWidget {
  final TextEditingController data;
  final String label;
  int maxLines = 1;
  TextDirection textDirection;
  Function(String) validator;
  bool enabled;
  TextInputType keyBoardType;

  DetailTextField(
      {required this.data,
      required this.label,
      this.maxLines = 1,
      this.keyBoardType = TextInputType.text,
      this.textDirection = TextDirection.ltr,
      required this.validator,
      this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: TextFormField(
          keyboardType: keyBoardType,
          controller: data,
          validator: (val) => validator(val!),
          textDirection: textDirection,
          cursorColor: Colors.black,
          enabled: enabled,
          maxLines: maxLines,
          style: TextStyle(color: Colors.black),
          decoration: textFieldDecoration(label, context)),
    );
  }

  textFieldDecoration(String label, BuildContext context) {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
        borderSide: BorderSide(color: AppConfigurations.color));
    return InputDecoration(
        disabledBorder: outlineInputBorder,
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        border: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder);
  }
}
