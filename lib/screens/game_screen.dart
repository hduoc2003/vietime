import 'package:flutter/material.dart';
import 'package:vietime/entity/card.dart';
import 'package:vietime/screens/study_screen.dart';

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
                  Flashcard(
                    id: "1",
                    deckId: "1",
                    question: "What is the capital of France?",
                    correctAnswer: "Paris",
                    answers: ["London", "Berlin", "Madrid", "Paris"],
                    createdAt: DateTime.now(),
                    userId: "user1",
                    lastReview: DateTime.now(),
                    nextReview: DateTime.now(),
                    numReviews: 0,
                    sm2N: 1,
                    sm2EF: 2.5,
                    sm2I: 3,
                    cardType: 0,
                  ),
                  Flashcard(
                    id: "2",
                    deckId: "1",
                    question: "What is the capital of France?1",
                    correctAnswer: "Paris1",
                    answers: ["London1", "Berlin1", "Madrid1", "Paris1"],
                    createdAt: DateTime.now(),
                    userId: "user1",
                    lastReview: DateTime.now(),
                    nextReview: DateTime.now(),
                    numReviews: 0,
                    sm2N: 1,
                    sm2EF: 2.5,
                    sm2I: 1,
                    cardType: 0,
                  ),
                  Flashcard(
                    id: "3",
                    deckId: "2",
                    question: "Which planet is known as the Red Planet?",
                    correctAnswer: "Mars",
                    answers: ["Earth", "Venus", "Jupiter", "Mars"],
                    createdAt: DateTime.now(),
                    userId: "user2",
                    lastReview: DateTime.now(),
                    nextReview: DateTime.now(),
                    numReviews: 0,
                    sm2N: 1,
                    sm2EF: 2.5,
                    sm2I: 3,
                    cardType: 1,
                  ),
                  Flashcard(
                    id: "4",
                    deckId: "2",
                    question: "What is the largest mammal in the world?",
                    correctAnswer: "Blue Whale",
                    answers: ["Lion", "Elephant", "Giraffe", "Blue Whale"],
                    createdAt: DateTime.now(),
                    userId: "user2",
                    lastReview: DateTime.now(),
                    nextReview: DateTime.now(),
                    numReviews: 0,
                    sm2N: 1,
                    sm2EF: 2.5,
                    sm2I: 3,
                    cardType: 2,
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