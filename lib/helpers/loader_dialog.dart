import 'package:flutter/material.dart';

void showLoaderDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        child: Center(child: CircularProgressIndicator(color: Colors.white,)),
        height: 50.0,
        width: 50.0,
      );
    },
  );
}
