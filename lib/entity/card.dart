class Flashcard {
  final String id;
  final String deckId;
  final String question;
  final String correctAnswer;
  final List<String> answers;
  final DateTime createdAt;
  final String userId;
  DateTime lastReview;
  DateTime nextReview;
  int numReviews;
  int sm2N;
  double sm2EF;
  int sm2I;

  int cardType;

  Flashcard({
    required this.id,
    required this.deckId,
    required this.question,
    required this.correctAnswer,
    required this.answers,
    required this.createdAt,
    required this.userId,
    required this.lastReview,
    required this.nextReview,
    this.numReviews = 0,
    this.sm2N = 1,
    this.sm2EF = 2.5,
    required this.sm2I,
    required this.cardType,
  });
}