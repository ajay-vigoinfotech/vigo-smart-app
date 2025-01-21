import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastHelper {
  static void showToast({
    required BuildContext context,
    required String message,
    Toast toastLength = Toast.LENGTH_SHORT,
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
    double fontSize = 16.0,
  }) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: isKeyboardOpen ? ToastGravity.CENTER : ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }
}

