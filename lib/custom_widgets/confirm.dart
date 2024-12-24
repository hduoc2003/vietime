import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final Function onConfirm;

  ConfirmationDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Xác nhận'),
      content: Text(
        'Bạn có chắc chắn không?',
        style: TextStyle(fontSize: 17),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      actionsPadding: EdgeInsets.only(left: 5, right: 15, bottom: 15),
      contentPadding: EdgeInsets.only(left: 25, right: 20, top: 20, bottom: 15),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(
            'HỦY',
            style: TextStyle(fontSize: 17, color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: Text(
            'XÁC NHẬN',
            style: TextStyle(color: Colors.blue, fontSize: 17),
          ),
        ),
      ],
    );
  }
}
