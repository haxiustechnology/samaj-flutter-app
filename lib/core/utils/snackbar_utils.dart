import 'package:flutter/material.dart';

class SnackbarUtils {
  static void show(BuildContext context, String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? Colors.black87,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}