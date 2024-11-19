import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/teenyicons.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
  PageController _pageController = PageController(initialPage: 0);
  int currentQuestionIndex = 0;
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
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.questions.length,
                  itemBuilder: (context, index) {
                    return SlidingUpPanel(
                        parallaxEnabled: true,
                        minHeight: 85,
                        maxHeight: 490,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24.0),
                          topRight: Radius.circular(24.0),
                        ),
                        panel: AnswersExpandedPanel(
                            answers: widget.questions[index].answers),
                        collapsed: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24.0),
                                topRight: Radius.circular(24.0),
                              )),
                          child: Column(
                            children: [
                              PanelHeaderRectangle(reverseOrder: true),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Iconify(Ic.baseline_swipe_up,
                                        color: Colors.blue),
                                  ), // Icon left-aligned
                                  Text("XEM ĐÁP ÁN",
                                      style: TextStyle(
                                          color: Color(0xffA6A6C6),
                                          fontSize: 20,
                                          fontWeight: FontWeight
                                              .bold)), // Text in the middle
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Iconify(Ic.baseline_swipe_up,
                                        color: Colors.blue),
                                  ), // Icon right-aligned
                                ],
                              ),
                            ],
                          ),
                        ),
                        body: Center(
                          child: Text(
                              "This is the Widget behind the sliding panel"),
                        ));
                  },
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
                  padding: const EdgeInsets.only(top: 5.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: blueCard.toString(),
                          style: TextStyle(
                            shadows: [
                              Shadow(color: Colors.blue, offset: Offset(0, -3))
                            ],
                            color: Colors.transparent,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue,
                            decorationThickness: 2,
                            decorationStyle: TextDecorationStyle.solid,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: '  '),
                        TextSpan(
                          text: redCard.toString(),
                          style: TextStyle(
                            shadows: [
                              Shadow(color: Colors.red, offset: Offset(0, -3))
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
                              Shadow(color: Colors.green, offset: Offset(0, -3))
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
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
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

class PanelHeaderRectangle extends StatelessWidget {
  final bool reverseOrder;
  PanelHeaderRectangle({required this.reverseOrder});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30, // Adjust the height as needed
      child: Center(
        child: Column(
          children: reverseOrder
              ? <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 3.0),
                    child: Container(
                      width: 15, // Adjust the width of the inner rectangle
                      height: 5, // Adjust the height of the inner rectangle
                      decoration: BoxDecoration(
                        color: Color(
                            0xffC7C6C6), // Change the inner rectangle color
                        borderRadius: BorderRadius.circular(
                            10), // Adjust the inner border radius
                      ),
                    ),
                  ),
                  Container(
                    width: 30, // Adjust the width of the inner rectangle
                    height: 5, // Adjust the height of the inner rectangle
                    decoration: BoxDecoration(
                      color:
                          Color(0xffC7C6C6), // Change the inner rectangle color
                      borderRadius: BorderRadius.circular(
                          10), // Adjust the inner border radius
                    ),
                  ),
                ]
              : <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 3.0),
                    child: Container(
                      width: 30, // Adjust the width of the inner rectangle
                      height: 5, // Adjust the height of the inner rectangle
                      decoration: BoxDecoration(
                        color: Color(
                            0xffC7C6C6), // Change the inner rectangle color
                        borderRadius: BorderRadius.circular(
                            10), // Adjust the inner border radius
                      ),
                    ),
                  ),
                  Container(
                    width: 15, // Adjust the width of the inner rectangle
                    height: 5, // Adjust the height of the inner rectangle
                    decoration: BoxDecoration(
                      color:
                          Color(0xffC7C6C6), // Change the inner rectangle color
                      borderRadius: BorderRadius.circular(
                          10), // Adjust the inner border radius
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}

class AnswersExpandedPanel extends StatefulWidget {
  final List<String> answers;

  AnswersExpandedPanel({required this.answers});

  List<bool> selectedAnswers = List.filled(4, false);

  @override
  _AnswersExpandedPanelState createState() => _AnswersExpandedPanelState();
}

class _AnswersExpandedPanelState extends State<AnswersExpandedPanel> {
  bool isCorrectVisible = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PanelHeaderRectangle(reverseOrder: false),
        Expanded(
          child: Stack(
            children: [
              SizedBox(
                height: 380,
                child: Container(
                  padding: EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0, // Adjust the horizontal spacing
                      mainAxisSpacing: 10.0, // Adjust the vertical spacing
                    ),
                    itemCount: widget.answers.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Toggle the selected state of the answer when tapped
                          setState(() {
                            widget.selectedAnswers[index] =
                                !widget.selectedAnswers[index];
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin:
                                  Alignment.bottomCenter, // Start from the bottom
                              end: Alignment.topCenter, // End at the top
                              stops: [0.04, 0.04], // Adjust the stops as needed
                              colors: [
                                widget.selectedAnswers[index]
                                    ? Color(0xff74CCF2)
                                    : Color(0xffC7C6C6),
                                Colors.white
                              ],
                            ),
                            border: Border.all(
                              color: widget.selectedAnswers[index]
                                  ? Color(0xff74CCF2)
                                  : Color(0xffC7C6C6),
                              width: 3.0,
                            ),
                            color: widget.selectedAnswers[index]
                                ? Color(0xff74CCF2)
                                : Colors.white, // Inner color
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Center(
                            child: Text(
                              widget.answers[index], // Display full answer
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                  bottom: isCorrectVisible ? 0 : -130,
                  left: 0,
                  right: 0,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 180), // Adjust the animation duration
                    height: isCorrectVisible ? 130 : 0,
                    color: Color(0xffd6fcb8),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Row(
                          children: [
                            Iconify(Teenyicons.tick_circle_solid, color: Color(0xff3a8c40), size: 20,),
                            SizedBox(width: 10),
                            Text(
                              'Chính xác!',
                              style: TextStyle(
                                color: Color(0xff3a8c40),
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              Positioned(
                bottom: 17,
                left: 16,
                child: SizedBox(
                  height: 55,
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          print("Button Clicked");
                          isCorrectVisible = true;
                        });
                      },
                      child: Container(
                        width: 360,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter, // Start from the bottom
                            end: Alignment.topCenter, // End at the top
                            stops: [0.1, 0.1], // Adjust the stops as needed
                            colors: [Color(0xff3a8c40), Color(0xff75E840)],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            'KIỂM TRA',
                            style: TextStyle(
                              color: Color(0xff3a8c40),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
