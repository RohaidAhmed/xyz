import 'package:booster/booster.dart';
import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 150,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.hourglass_empty,
            color: Colors.grey[400],
            size: 65,
          ),
          Booster.verticalSpace(10),
          Center(
            child: Booster.dynamicFontSize(
              label: "Data not Available!!!",
              color: Colors.grey[400],
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
