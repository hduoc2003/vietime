import 'package:flutter/material.dart';
import 'package:vietime/screens/study.dart';

class GamePage extends StatefulWidget {
  static const title = 'Game';

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(GamePage.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Create a mock list of questions
                final mockQuestions = [
                  Question(
                    question: "What is the capital of France?",
                    answers: ["Paris", "London", "Berlin", "Madrid"],
                    correctAnswer: "Paris",
                    cardType: 0,
                    sm2Interval: 3,
                  ),
                  Question(
                    question: "What is the capital of France?1",
                    answers: ["Pari1s", "Lond1on", "Berli1n", "Ma1drid"],
                    correctAnswer: "Pari1s",
                    cardType: 0,
                    sm2Interval: 1,
                  ),
                  Question(
                    question: "Which planet is known as the Red Planet?",
                    answers: ["Earth", "Mars", "Venus", "Jupiter"],
                    correctAnswer: "Mars",
                    cardType: 1,
                    sm2Interval: 3,
                  ),
                  Question(
                    question: "What is the largest mammal in the world?",
                    answers: ["Lion", "Elephant", "Blue Whale", "Giraffe"],
                    correctAnswer: "Blue Whale",
                    cardType: 2,
                    sm2Interval: 3,
                  ),
                  // Add more mock questions as needed
                ];

                // Navigate to StudyScreen with the mock list of questions
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => StudyScreen(questions: mockQuestions),
                  ),
                );
              },
              child: Text("Start Studying"),
            ),
          ],
        ),
      ),
    );
  }
}
