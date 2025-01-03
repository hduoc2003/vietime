import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/teenyicons.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:vietime/entity/card.dart';

import '../custom_widgets/animated_progress_bar.dart';
import '../custom_widgets/confirm.dart';
import '../custom_widgets/error_dialog.dart';
import '../custom_widgets/long_button.dart';
import '../custom_widgets/snackbar.dart';
import '../helpers/api.dart';
import '../helpers/loader_dialog.dart';
import '../helpers/validate.dart';
import '../services/api_handler.dart';
import '../services/theme_manager.dart';

//ignore: must_be_immutable
class StudyScreen extends StatefulWidget {
  final String deckID;
  final List<Flashcard> questions;

  StudyScreen({required this.deckID, required this.questions});
  @override
  _StudyScreenState createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> with WidgetsBindingObserver {
  final ValueNotifier<bool> appBarUpdated = ValueNotifier<bool>(false);
  final ValueNotifier<bool> questionsUpdated = ValueNotifier<bool>(false);
  final Duration duration = const Duration(seconds: 1);
  PageController _pageController = PageController(initialPage: 0);
  final PanelController _pc = new PanelController();
  int blueCard = 0;
  int redCard = 0;
  int greenCard = 0;
  int xpEarned = 0;
  int totalCards = 0;
  int currentCardType = 0;
  int currentQuestionIndex = 0;
  int numCorrect = 0;
  int numIncorrect = 0;
  int _secondsTimer = 0;
  final List<String> learntCardsID = [];
  final List<bool> isCorrects = [];
  late final PausableTimer _timer;
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.questions.length; ++i) {
      if (widget.questions[i].cardType == 0) {
        blueCard++;
      } else if (widget.questions[i].cardType == 1) {
        redCard++;
      } else {
        greenCard++;
      }
    }
    currentCardType = widget.questions[0].cardType;
    totalCards = blueCard * 2 + redCard + greenCard;
    widget.questions[0].answers.shuffle();
    // Start the timer when the widget is created
    _startTimer();
    // Add the observer to listen for app lifecycle changes
    WidgetsBinding.instance.addObserver(this);
  }

  void _startTimer() {
    _timer = PausableTimer.periodic(
      Duration(seconds: 1),
      () {
        _secondsTimer++;
      },
    )..start();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    // Remove the observer when the widget is disposed
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App is in the background, pause the timer
      _timer.pause();
    } else if (state == AppLifecycleState.resumed) {
      // App is in the foreground, resume or start the timer
      _timer.start();
    }
  }

  void _increaseProgress(bool isCorrect) {
    appBarUpdated.value ^= true;
    int cardType = widget.questions[currentQuestionIndex].cardType;
    if (cardType == 0) {
      blueCard--;
    } else if (cardType == 1) {
      redCard--;
    } else {
      greenCard--;
    }
    if (!isCorrect || cardType == 0) {
      redCard++;
      Flashcard q = widget.questions[currentQuestionIndex];
      q.cardType = 1;
      widget.questions.add(q);
    }
    if (isCorrect) {
      xpEarned += 5;
      numCorrect++;
    } else {
      numIncorrect++;
    }
    currentCardType = (currentQuestionIndex < widget.questions.length - 1
        ? widget.questions[currentQuestionIndex + 1].cardType
        : 3);
    learntCardsID.add(widget.questions[currentQuestionIndex].id);
    isCorrects.add(isCorrect);
  }

  void _navigateToNextQuestion(bool isCorrect) {
    if (currentQuestionIndex < widget.questions.length - 1) {
      questionsUpdated.value ^= true;
      currentQuestionIndex++;
      widget.questions[currentQuestionIndex].answers.shuffle();
      _pageController.animateToPage(
        currentQuestionIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _timer.cancel();
      // Navigate to the summary page and replace the current route
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => EndStudyScreen(
                deckID: widget.deckID,
                xpEarned: xpEarned,
                timeInSeconds: _secondsTimer,
                accuracy: 100 * numCorrect ~/ (numCorrect + numIncorrect),
                learntCardsID: learntCardsID,
                isCorrects: isCorrects)),
      );
    }
  }

  void onExitLearn() {
    _timer.cancel();
    if (numCorrect + numIncorrect == 0) {
      Navigator.pop(context);
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => EndStudyScreen(
              deckID: widget.deckID,
              xpEarned: xpEarned,
              timeInSeconds: _secondsTimer,
              accuracy: 100 * numCorrect ~/ (numCorrect + numIncorrect),
              learntCardsID: learntCardsID,
              isCorrects: isCorrects)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MyColors myColors = Theme.of(context).extension<MyColors>()!;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              ValueListenableBuilder<bool>(
                  valueListenable: appBarUpdated,
                  builder: (context, value, _) {
                    return StudyAppBar(
                      blueCard: blueCard,
                      redCard: redCard,
                      greenCard: greenCard,
                      totalCards: totalCards,
                      xpEarned: xpEarned,
                      currentCardType: currentCardType,
                      onExitLearn: onExitLearn,
                    );
                  }),
              Expanded(
                child: ValueListenableBuilder<bool>(
                    valueListenable: questionsUpdated,
                    builder: (context, value, _) {
                      return PageView.builder(
                        controller: _pageController,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.questions.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _pc.open();
                            },
                            child: SlidingUpPanel(
                                color: myColors.panelColor!,
                                controller: _pc,
                                minHeight: 85,
                                maxHeight: 520,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(24.0),
                                  topRight: Radius.circular(24.0),
                                ),
                                panel: AnswersExpandedPanel(
                                    answers: widget.questions[index].answers,
                                    correctAnswer:
                                        widget.questions[index].correctAnswer,
                                    navigateToNextQuestion:
                                        _navigateToNextQuestion,
                                    increaseProgress: _increaseProgress),
                                collapsed: Container(
                                  decoration: BoxDecoration(
                                      color: myColors.panelColor,
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
                                                  color: Colors.grey[400],
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
                                body: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Text(
                                          widget.questions[currentQuestionIndex]
                                              .question,
                                          style: TextStyle(fontSize: 20.0),
                                        ),
                                      ),
                                      validateURL(widget
                                              .questions[currentQuestionIndex]
                                              .questionImgURL)
                                          ? Column(
                                              children: [
                                                Container(
                                                  constraints: BoxConstraints(
                                                    maxWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.91,
                                                    maxHeight:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.3,
                                                  ),
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    errorWidget:
                                                        (context, _, __) =>
                                                            const Image(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                          'assets/image_loading.jpg'),
                                                    ),
                                                    imageUrl: widget
                                                        .questions[
                                                            currentQuestionIndex]
                                                        .questionImgURL,
                                                    placeholder:
                                                        (context, url) =>
                                                            const Image(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                          'assets/image_loading.jpg'),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 10.0),
                                                Text(
                                                  widget
                                                      .questions[
                                                          currentQuestionIndex]
                                                      .questionImgLabel,
                                                  style:
                                                      TextStyle(fontSize: 16.0),
                                                ),
                                              ],
                                            )
                                          : SizedBox()
                                    ],
                                  ),
                                )),
                          );
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudyAppBar extends StatelessWidget {
  final int blueCard;
  final int redCard;
  final int greenCard;
  final int totalCards;
  final int xpEarned;
  final int currentCardType;
  final Function() onExitLearn;

  StudyAppBar(
      {required this.blueCard,
      required this.redCard,
      required this.greenCard,
      required this.totalCards,
      required this.xpEarned,
      required this.currentCardType,
      required this.onExitLearn});

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
                  icon: Icon(Icons.arrow_back, size: 32),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ConfirmationDialog(
                            onConfirm: () {
                              onExitLearn();
                            },
                          );
                        });
                  },
                ),
              ),
              AnimatedProgressBar(
                progress: progress,
                width: 280,
                height: 20,
              ), // Progress bar
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
                            decoration: (currentCardType == 0
                                ? TextDecoration.underline
                                : null),
                            decorationColor:
                                (currentCardType == 0 ? Colors.blue : null),
                            decorationThickness:
                                (currentCardType == 0 ? 2 : null),
                            decorationStyle: (currentCardType == 0
                                ? TextDecorationStyle.solid
                                : null),
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
                            decoration: (currentCardType == 1
                                ? TextDecoration.underline
                                : null),
                            decorationColor:
                                (currentCardType == 1 ? Colors.red : null),
                            decorationThickness:
                                (currentCardType == 1 ? 2 : null),
                            decorationStyle: (currentCardType == 1
                                ? TextDecorationStyle.solid
                                : null),
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
                            decoration: (currentCardType == 2
                                ? TextDecoration.underline
                                : null),
                            decorationColor:
                                (currentCardType == 2 ? Colors.green : null),
                            decorationThickness:
                                (currentCardType == 2 ? 2 : null),
                            decorationStyle: (currentCardType == 2
                                ? TextDecorationStyle.solid
                                : null),
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
                        color: Color(0xffC7C6C6),
                        borderRadius: BorderRadius.circular(
                            10), // Adjust the inner border radius
                      ),
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Color(0xffC7C6C6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ]
              : <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 3.0),
                    child: Container(
                      width: 30,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Color(0xffC7C6C6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Container(
                    width: 15,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Color(0xffC7C6C6),
                      borderRadius: BorderRadius.circular(10),
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
  final String correctAnswer;
  final Function(bool) navigateToNextQuestion;
  final Function(bool) increaseProgress;
  AnswersExpandedPanel(
      {required this.answers,
      required this.correctAnswer,
      required this.navigateToNextQuestion,
      required this.increaseProgress});

  final List<bool> selectedAnswers = List.filled(4, false);

  @override
  _AnswersExpandedPanelState createState() => _AnswersExpandedPanelState();
}

class _AnswersExpandedPanelState extends State<AnswersExpandedPanel> {
  bool isCheckAnswerButtonClicked = false;
  int isCorrect = -1;
  @override
  Widget build(BuildContext context) {
    final MyColors myColors = Theme.of(context).extension<MyColors>()!;
    return Column(
      children: [
        PanelHeaderRectangle(reverseOrder: false),
        SizedBox(
          height: 30,
        ),
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
                          if (isCheckAnswerButtonClicked) {
                            return;
                          }
                          // Toggle the selected state of the answer when tapped
                          setState(() {
                            for (int i = 0; i < 4; ++i) {
                              if (i != index) {
                                widget.selectedAnswers[i] = false;
                              }
                            }
                            widget.selectedAnswers[index] =
                                !widget.selectedAnswers[index];
                            if (widget.selectedAnswers[index]) {
                              isCorrect =
                                  (widget.answers[index] == widget.correctAnswer
                                      ? 1
                                      : 0);
                            } else {
                              isCorrect = -1;
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment
                                  .bottomCenter, // Start from the bottom
                              end: Alignment.topCenter, // End at the top
                              stops: [0.04, 0.04], // Adjust the stops as needed
                              colors: [
                                (isCheckAnswerButtonClicked
                                    ? (widget.answers[index] ==
                                            widget.correctAnswer
                                        ? Color(0xff85f274)
                                        : (widget.selectedAnswers[index]
                                            ? Color(0xfff27474)
                                            : myColors.grey300!))
                                    : widget.selectedAnswers[index]
                                        ? Color(0xff74CCF2)
                                        : myColors.grey300!),
                                myColors.panelColor!
                              ],
                            ),
                            border: Border.all(
                              color: (isCheckAnswerButtonClicked
                                  ? (widget.answers[index] ==
                                          widget.correctAnswer
                                      ? Color(0xff85f274)
                                      : (widget.selectedAnswers[index]
                                          ? Color(0xfff27474)
                                          : myColors.grey300!))
                                  : widget.selectedAnswers[index]
                                      ? Color(0xff74CCF2)
                                      : myColors.grey300!),
                              width: 3.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Center(
                            child: Stack(
                              children: [
                                // Text widget with maxLines set to 3
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0),
                                  child: Center(
                                    child: Text(
                                      widget.answers[index],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                ),
                                // GestureDetector for handling tap
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Chi tiết"),
                                          content: Text(
                                            widget.answers[index],
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          actionsPadding: EdgeInsets.only(
                                              left: 5, right: 15, bottom: 10),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'OK',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    alignment: Alignment.topRight,
                                    child: Iconify(
                                      Ic.outline_zoom_out_map,
                                      color: Colors.grey[500],
                                      size: 34,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: isCheckAnswerButtonClicked ? 0 : -140,
                left: 0,
                right: 0,
                child: AnimatedContainer(
                  duration: Duration(
                      milliseconds: 180), // Adjust the animation duration
                  height: isCheckAnswerButtonClicked ? 140 : 0,
                  color: (isCorrect == 1
                      ? myColors.greenBackground
                      : myColors.redBackground),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Row(
                        children: [
                          Iconify(
                            Teenyicons.tick_circle_solid,
                            color: (isCorrect == 1
                                ? Color(0xff1cb028)
                                : Color(0xffe02828)),
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            (isCorrect == 1
                                ? 'Chính xác!'
                                : 'Không chính xác!'),
                            style: TextStyle(
                              color: (isCorrect == 1
                                  ? Color(0xff1cb028)
                                  : Color(0xffe02828)),
                              fontWeight: FontWeight.w900,
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                child: LongButton(
                  text: (isCheckAnswerButtonClicked ? 'TIẾP TỤC' : 'KIỂM TRA'),
                  outerBoxColor: (isCorrect == -1
                      ? myColors.buttonTextColor!
                      : ((!isCheckAnswerButtonClicked || isCorrect == 1)
                          ? Color(0xff3a8c40)
                          : Color(0xffc43535))), // Set your desired color
                  innerBoxColor: (isCorrect == -1
                      ? myColors.buttonIdleColor!
                      : ((!isCheckAnswerButtonClicked || isCorrect == 1)
                          ? Color(0xff75E840)
                          : Color(0xffe84040))), // Set your desired color
                  textColor: (isCorrect == -1
                      ? myColors.buttonTextColor!
                      : Colors.white), // Set your desired color
                  onTap: () {
                    if (isCorrect == -1) {
                      return;
                    }
                    if (isCheckAnswerButtonClicked) {
                      widget.navigateToNextQuestion(isCorrect == 1);
                      return;
                    }
                    setState(() {
                      widget.increaseProgress(isCorrect == 1);
                      isCheckAnswerButtonClicked = true;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class StatsBox extends StatefulWidget {
  final String title;
  final String icon;
  final int number;
  final Color color;
  final String suffix;

  StatsBox({
    required this.title,
    required this.icon,
    required this.number,
    required this.color,
    required this.suffix,
  });

  @override
  _StatsBoxState createState() => _StatsBoxState();
}

class _StatsBoxState extends State<StatsBox>
    with SingleTickerProviderStateMixin {
  double opacityValue = 0.0;
  late AnimationController _controller;
  late Animation<double> _animation, _minutesAnimation, _secondsAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );

    _animation = Tween<double>(begin: 0.0, end: widget.number.toDouble())
        .animate(_controller);
    if (widget.title == 'TIME') {
      int mins = widget.number ~/ 60;
      int secs = widget.number % 60;
      _minutesAnimation = Tween<double>(begin: 0.0, end: (mins).toDouble())
          .animate(_controller);
      _secondsAnimation = Tween<double>(begin: 0.0, end: (secs).toDouble())
          .animate(_controller);
    }

    int delayMilliseconds;
    if (widget.title == 'XP EARNED') {
      delayMilliseconds = 300; // No delay for the first StatsBox
    } else if (widget.title == 'TIME') {
      delayMilliseconds = 1700; // 1-second delay for the second StatsBox
    } else {
      delayMilliseconds = 3100; // 2-second delay for the third StatsBox
    }

    // Start the animation after the specified delay
    Future.delayed(Duration(milliseconds: delayMilliseconds), () {
      setState(() {
        opacityValue = 1.0;
      });
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final MyColors myColors = Theme.of(context).extension<MyColors>()!;
    return Container(
      // Wrap with a Container to give it a fixed size
      width: 110, // Adjust the width as needed
      height: 150, // Adjust the height as needed
      child: Center(
        child: AnimatedOpacity(
          opacity: opacityValue,
          duration: Duration(seconds: 1),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Outer rounded rectangle with title
              Container(
                width: 105,
                height: 90,
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 3.5),
                    Center(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          color: myColors.panelColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Inner rounded rectangle with icon and animated number
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  width: 99,
                  height: 65,
                  decoration: BoxDecoration(
                    color: myColors.panelColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Iconify(widget.icon, size: 28, color: widget.color),
                      SizedBox(width: 7),
                      if (widget.title == "TIME") ...[
                        // Special case for "TIME" title
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Text(
                              _minutesAnimation.value
                                  .toStringAsFixed(0)
                                  .padLeft(2, '0'),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: widget.color,
                              ),
                            );
                          },
                        ),
                        Text(
                          ':',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: widget.color,
                          ),
                        ),
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Text(
                              _secondsAnimation.value
                                  .toStringAsFixed(0)
                                  .padLeft(2, '0'),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: widget.color,
                              ),
                            );
                          },
                        )
                      ] else ...[
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Text(
                              _animation.value.toStringAsFixed(0),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: widget.color,
                              ),
                            );
                          },
                        )
                      ],
                      if (widget.suffix.isNotEmpty)
                        Text(
                          widget.suffix,
                          style: TextStyle(
                            color: widget.color,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class EndStudyScreen extends StatelessWidget {
  final String deckID;
  final int xpEarned;
  final int timeInSeconds;
  final int accuracy;
  final List<String> learntCardsID;
  final List<bool> isCorrects;

  const EndStudyScreen({
    Key? key,
    required this.deckID,
    required this.xpEarned,
    required this.timeInSeconds,
    required this.accuracy,
    required this.learntCardsID,
    required this.isCorrects,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 300),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              'HOÀN THÀNH!',
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.w900,
                color: Colors.orange,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatsBox(
                title: 'XP EARNED',
                icon: Ph.lightning_fill,
                number: xpEarned,
                color: Color(0xfff0dd1a),
                suffix: " XP",
              ),
              StatsBox(
                title: 'TIME',
                icon: Ic.twotone_access_time,
                number: timeInSeconds,
                color: Color(0xff46a4e8),
                suffix: "",
              ),
              StatsBox(
                title: 'ACCURACY',
                icon: Ph.target_duotone,
                number: accuracy,
                color: Color(0xff54d158),
                suffix: "%",
              ),
            ],
          ),
          SizedBox(height: 220),
          Expanded(
            child: LongButton(
              text: 'TIẾP TỤC',
              outerBoxColor: Color(0xff1783d1),
              innerBoxColor: Color(0xff46a4e8),
              textColor: Colors.white,
              onTap: () {
                showLoaderDialog(context);
                APIHelper.submitReviewCardsRequest(
                        deckID, learntCardsID, isCorrects, xpEarned)
                    .then((reviewCardsResponse) {
                  if (reviewCardsResponse.containsKey("error")) {
                    Navigator.pop(context);
                  } else {
                    GetIt.I<APIHanlder>()
                        .onReviewCardsSuccess(deckID, reviewCardsResponse);
                    Navigator.pop(context);
                    Navigator.of(context).pop();
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
