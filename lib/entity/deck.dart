import 'package:vietime/entity/card.dart';

class Deck {
  String id;
  bool isPublic;
  String name;
  String description;
  DateTime createdAt;
  String userId;
  int maxNewCards;
  int maxReviewCards;
  DateTime lastReview;
  int curNewCards;
  int curReviewCards;
  String descriptionImgURL;
  int totalCards;
  int totalLearnedCards;
  int views;
  double rating;
  bool isFavorite;

  Deck({
    required this.id,
    required this.isPublic,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.userId,
    this.maxNewCards = 0,
    this.maxReviewCards = 0,
    lastReview_,
    this.curNewCards = 0,
    this.curReviewCards = 0,
    this.descriptionImgURL = "",
    required this.totalCards,
    required this.totalLearnedCards,
    this.views = 0,
    required this.rating,
    this.isFavorite = false,
  }) : lastReview = (lastReview_ ?? DateTime.now());
  factory Deck.fromJson(Map<String, dynamic> json) {
    return Deck(
      id: json['id'] ?? '',
      isPublic: json['is_public'] ?? false,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? ''),
      userId: json['user_id'] ?? '',
      maxNewCards: json['max_new_cards'] ?? 0,
      maxReviewCards: json['max_review_cards'] ?? 0,
      lastReview_: DateTime.parse(json['last_review'] ?? ''),
      curNewCards: json['cur_new_cards'] ?? 0,
      curReviewCards: json['cur_review_cards'] ?? 0,
      descriptionImgURL: json['description_img_url'] ?? '',
      totalCards: json['total_cards'] ?? 0,
      totalLearnedCards: json['total_learned_cards'] ?? 0,
      views: json['views'] ?? 0,
      rating: (json['rating'] as num).toDouble() ?? 0.0,
      isFavorite: json['is_favorite'] ?? false,
    );
  }
}

class DeckWithReviewCards {
  Deck deck;
  int numBlueCards;
  int numRedCards;
  int numGreenCards;
  List<Flashcard> cards;

  DeckWithReviewCards({
    required this.deck,
    required this.numBlueCards,
    required this.numRedCards,
    required this.numGreenCards,
    required this.cards,
  });

  factory DeckWithReviewCards.fromJson(Map<String, dynamic> json) {
    return DeckWithReviewCards(
      deck: Deck.fromJson(json),
      numBlueCards: json['num_blue_cards'] ?? 0,
      numRedCards: json['num_red_cards'] ?? 0,
      numGreenCards: json['num_green_cards'] ?? 0,
      cards: (json['cards'] as List<dynamic>?)
              ?.map((cardJson) => Flashcard.fromJson(cardJson))
              .toList() ??
          [],
    );
  }
}

class DeckWithCards {
  Deck deck;
  List<Flashcard> cards;
  int numBlueCards;
  int numRedCards;
  int numGreenCards;
  DeckWithCards({
    required this.deck,
    required this.cards,
    this.numBlueCards = 0,
    this.numRedCards = 0,
    this.numGreenCards = 0,
  });

  factory DeckWithCards.fromJson(Map<String, dynamic> json) {
    return DeckWithCards(
      deck: Deck.fromJson(json),
      numBlueCards: json['num_blue_cards'] ?? 0,
      numRedCards: json['num_red_cards'] ?? 0,
      numGreenCards: json['num_green_cards'] ?? 0,
      cards: (json['cards'] as List<dynamic>?)
              ?.map((cardJson) => Flashcard.fromJson(cardJson))
              .toList() ??
          [],
    );
  }
}
