import 'package:flutter/material.dart';

class RoundedBoxWithText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: Colors.grey[300]!, width: 3)),
      child: Center(
        child: Text(
          'Trống',
          style: TextStyle(
            color: Colors.grey[400]!,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
