import 'package:flutter/material.dart';

class CustomSnackbar {
  static SnackBar customSnackbar(var content, var color) {
    return SnackBar(
      duration: Duration(milliseconds: 600),
      content: Text(
        '$content',
        style: TextStyle(
          fontSize: 17.0,
          fontFamily: "Georgia",
          color: Colors.white,
        ),
      ),
      backgroundColor: color,
    );
  }
}
