import 'package:flutter/material.dart';

class Dialogs {
  // Show error message snackbar
  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.blue.withOpacity(.8),
      behavior: SnackBarBehavior.floating,
    ));
  }

  // Show progress indicator
  static void showProgressBar(BuildContext context) {
    showDialog(context: context, builder: (_) => const Center(child: CircularProgressIndicator()));
  }
}
