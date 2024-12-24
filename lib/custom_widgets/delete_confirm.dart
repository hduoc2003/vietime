import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final Function onConfirm;

  DeleteConfirmationDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Xác nhận Xóa'),
      content: Text('Bạn có chắc chắn muốn xóa không?',     style: TextStyle(fontSize: 17),),
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      actionsPadding: EdgeInsets.only(left: 5, right: 15, bottom: 15),
      contentPadding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 15),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('HỦY',     style: TextStyle(fontSize: 18),),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
          },
          child: Text(
            'XÓA',
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      ],
    );
  }
}
