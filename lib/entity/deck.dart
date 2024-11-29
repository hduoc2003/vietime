import 'package:flutter/material.dart';
import 'package:vietime/entity/card.dart';

class Deck {
  String id;
  bool isGlobal;
  String name;
  String description;
  DateTime createdAt;
  String userId;
  int maxNewCards;
  int maxReviewCards;
  DateTime lastReview;
  int curNewCards;
  int curReviewCards;
  String descriptionImgPath;
  int totalCards;
  int totalNewCards;

  Deck({
    required this.id,
    required this.isGlobal,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.userId,
    this.maxNewCards = 0,
    this.maxReviewCards = 0,
    lastReview_,
    this.curNewCards = 0,
    this.curReviewCards = 0,
    this.descriptionImgPath = "",
    required this.totalCards,
    required this.totalNewCards
  }) : lastReview = ( lastReview_ ?? DateTime.now() );
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
}