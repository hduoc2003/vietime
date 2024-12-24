import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class ShowSnackBar {
  void showSnackBar(
      BuildContext context,
      String title, {
        SnackBarAction? action,
        Duration duration = const Duration(milliseconds: 3000),
        bool noAction = false,
      }) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: duration,
          elevation: 6,
          backgroundColor: Colors.grey[900],
          behavior: SnackBarBehavior.floating,
          content: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          action: noAction
              ? null
              : action ??
              SnackBarAction(
                textColor: Colors.grey[200],
                label: "OK",
                onPressed: () {},
              ),
        ),
      );
    } catch (e) {
      Logger.root.severe(e.toString());
      Logger.root.severe('Failed to show Snackbar with title: $title', e);
    }
  }
}
