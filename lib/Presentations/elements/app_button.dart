import 'package:booster/booster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_module/Configurations/app_config.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  AppButton({required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        width: Booster.screenWidth(context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppConfigurations.color,
        ),
        child: Booster.paddedWidget(
            top: 17,
            bottom: 15,
            child: Booster.dynamicFontSize(
                label: text,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
    );
  }
}
