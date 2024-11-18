import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Question {
  final String question;
  final List<String> answers;
  final String correctAnswer;
  int cardType;
  final int sm2Interval;

  Question({
    required this.question,
    required this.answers,
    required this.correctAnswer,
    required this.cardType,
    required this.sm2Interval,
  });
}

class StudyScreen extends StatefulWidget {
  final List<Question> questions;
  int blueCard = 0;
  int redCard = 0;
  int greenCard = 0;
  int xpEarned = 0;
  int totalCards = 0;
  StudyScreen({required this.questions}) {
    for (int i = 0; i < questions.length; ++i) {
      if (questions[i].cardType == 0) {
        blueCard++;
      } else if (questions[i].cardType == 1) {
        redCard++;
      } else {
        greenCard++;
      }
    }
    totalCards = blueCard * 2 + redCard + greenCard;
  }
  @override
  _StudyScreenState createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  final Duration duration = const Duration(seconds: 1);

  void increaseProgress() {
    setState(() {
      widget.blueCard--;
      widget.xpEarned += 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              StudyAppBar(
                blueCard: widget.blueCard,
                redCard: widget.redCard,
                greenCard: widget.greenCard,
                totalCards: widget.totalCards,
                xpEarned: widget.xpEarned,
                increaseProgress: increaseProgress,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Study content goes here'), // Updated text
                    ElevatedButton(
                      onPressed: increaseProgress,
                      child: Text('Increase Progress'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudyAppBar extends StatelessWidget {
  int blueCard;
  int redCard;
  int greenCard;
  int totalCards;
  int xpEarned;
  final VoidCallback increaseProgress;

  StudyAppBar({
    required this.blueCard,
    required this.redCard,
    required this.greenCard,
    required this.totalCards,
    required this.increaseProgress,
    required this.xpEarned,
  });

  @override
  Widget build(BuildContext context) {
    double progress = 1.0 - (blueCard * 2.0 + redCard + greenCard) / totalCards;
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, size: 32), // Left arrow icon
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the study screen
                  },
                ),
              ),
              CurvedProgressBar(progress: progress), // Progress bar
              IconButton(
                icon: Icon(Icons.more_vert, size: 32), // More icon
                onPressed: () {
                  // Handle more options
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Left Aligned Rich Text
                Padding(
                  padding: const EdgeInsets.only(top : 5.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: blueCard.toString(),
                          style: TextStyle(
                            shadows: [
                              Shadow(
                                  color: Colors.blue,
                                  offset: Offset(0, -3))
                            ],
                            color: Colors.transparent,
                            decoration:
                            TextDecoration.underline,
                            decorationColor: Colors.blue,
                            decorationThickness: 2,
                            decorationStyle:
                            TextDecorationStyle.solid,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: '  '),
                        TextSpan(
                          text: redCard.toString(),
                          style: TextStyle(
                            shadows: [
                              Shadow(
                                  color: Colors.red,
                                  offset: Offset(0, -3))
                            ],
                            color: Colors.transparent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: '  '),
                        TextSpan(
                          text: greenCard.toString(),
                          style: TextStyle(
                            shadows: [
                              Shadow(
                                  color: Colors.green,
                                  offset: Offset(0, -3))
                            ],
                            color: Colors.transparent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Right Aligned XP Display
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xffFFE6A7),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
                  child: Text(
                    xpEarned.toString() + ' XP',
                    style: TextStyle(
                      color: Color(0xffDB7210),
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CurvedProgressBar extends StatelessWidget {
  final double progress;
  final double innerProgressHeight;

  CurvedProgressBar({required this.progress, this.innerProgressHeight = 5.5});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.0, // Adjust the height as needed
      child: Stack(
        children: <Widget>[
          Container(
            width: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  15.0), // Use slightly smaller radius for the reflection indicator
              color: Color(0xffD9D9D9), // Color of the reflection indicator
            ),
          ),
          AnimatedContainer(
            duration: Duration(
                milliseconds:
                    800), // Adjust the duration for a smoother transition
            width: 260 * (progress) + 20, // Use the current progress value
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  15.0), // Use slightly smaller radius for the progress indicator
              color: Color(0xff75E840), // Color of the progress indicator
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 4.5),
            child: AnimatedContainer(
              duration: Duration(
                  milliseconds:
                      800), // Adjust the duration for a smoother transition
              width: max(
                  0, 260 * (progress) - 10), // Use the current progress value
              height:
                  innerProgressHeight, // Adjust the inner white progress height
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    15.0), // Use slightly smaller radius for the reflection indicator
                color: Color(0xff98F46D), // Color of the reflection indicator
              ),
            ),
          ),
        ],
      ),
    );
  }
}
