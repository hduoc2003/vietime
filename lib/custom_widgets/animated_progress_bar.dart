import 'dart:math';
import 'package:flutter/material.dart';

import '../services/theme_manager.dart';

class AnimatedProgressBar extends StatelessWidget {
  final double width;
  final double height;
  final double progress;
  Color backgroundColor;
  final Color progressColor;
  final Color innerProgressColor;

  AnimatedProgressBar({
    required this.width,
    required this.height,
    required this.progress,
    this.backgroundColor = const Color(0xffD9D9D9),
    this.progressColor = const Color(0xff75E840),
    this.innerProgressColor = const Color(0xff98F46D),
  });

  @override
  Widget build(BuildContext context) {
    final MyColors myColors = Theme.of(context).extension<MyColors>()!;
    backgroundColor = myColors.progressBarBackground!;
    double innerProgressHeight = 0.275 * height;
    double innerPadding = 0.0715 * width;
    double innerPadding1 = 0.0536 * width;
    double innerPadding2 = 0.0357 * width;
    double innerTopPadding = 0.225 * height;

    return Container(
      height: height,
      child: Stack(
        children: <Widget>[
          Container(
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: backgroundColor,
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 800),
            width: (width - innerPadding) * progress + innerPadding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: progressColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: innerPadding1, top: innerTopPadding),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 800),
              width: max(0, (width - innerPadding) * progress - innerPadding2),
              height: innerProgressHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: innerProgressColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}