import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyUI extends StatelessWidget {
  final String text;

  EmptyUI(this.text);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Icon(
            CupertinoIcons.doc,
            color: Colors.grey,
            size: 100,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Text(
            text,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
