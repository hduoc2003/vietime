class Flashcard {
  final String id;
  final String deckId;
  final String question;
  final String correctAnswer;
  final List<String> wrongAnswers;
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
    required this.wrongAnswers,
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
  factory Flashcard.fromJson(Map<String, dynamic> json) {
    String correctAnswer = json['correct_answer'] ?? '';
    List<String> wrongAnswers = List<String>.from(json['wrong_answers'] ?? []);
    List<String> answers = List.from(wrongAnswers);
    answers.add(correctAnswer);
    return Flashcard(
      id: json['id'] ?? '',
      deckId: json['deck_id'] ?? '',
      question: json['question'] ?? '',
      correctAnswer: correctAnswer,
      wrongAnswers: wrongAnswers,
      answers: answers,
      createdAt: DateTime.parse(json['created_at'] ?? ''),
      userId: json['user_id'] ?? '',
      lastReview: DateTime.parse(json['last_review'] ?? ''),
      nextReview: DateTime.parse(json['next_review'] ?? ''),
      numReviews: json['num_reviews'] ?? 0,
      sm2N: json['sm2_n'] ?? 1,
      sm2EF: json['sm2_ef'] ?? 2.5,
      sm2I: json['sm2_i'] ?? 0,
      cardType: json['card_type'] ?? 0,
    );
  }
}
