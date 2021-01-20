import 'package:flutter/material.dart';

class MySnackBar {
  static void show(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Container(
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
