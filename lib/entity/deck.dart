import 'package:flutter/material.dart';
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