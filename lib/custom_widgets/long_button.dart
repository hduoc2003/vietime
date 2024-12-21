import 'package:flutter/material.dart';

class LongButton extends StatelessWidget {
  final String text;
  final Color outerBoxColor;
  final Color innerBoxColor;
  final Color textColor;
  final Function()? onTap;

  LongButton({
    required this.text,
    required this.outerBoxColor,
    required this.innerBoxColor,
    required this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double containerWidth = MediaQuery.of(context).size.width * 0.92;
    double containerHeight = MediaQuery.of(context).size.height * 0.071;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Outer rounded rectangle with title
          Container(
            width: containerWidth,
            height: containerHeight,
            decoration: BoxDecoration(
              color: outerBoxColor,
              borderRadius: BorderRadius.circular(20),
            ),
            // You can add other widgets here for the outer container if needed
          ),
          // Inner rounded rectangle with text
          Container(
            width: containerWidth, // Subtracting padding on both sides
            height: containerHeight - 5, // Subtracting padding on both sides
            decoration: BoxDecoration(
              color: innerBoxColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  wordSpacing: 2.0,
                  letterSpacing: 0.8
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
