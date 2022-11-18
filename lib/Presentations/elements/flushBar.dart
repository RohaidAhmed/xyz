import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

getFlushBar(BuildContext context,
    {required String title, required IconData icon, required Color color}) {
  return Flushbar(
    message: title,
    icon: Icon(
      icon,
      size: 28.0,
      color: color,
    ),
    margin: EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    duration: Duration(seconds: 3),
  )..show(context);
}
