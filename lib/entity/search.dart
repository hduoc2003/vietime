import 'package:flutter/cupertino.dart';
import 'package:vietime/entity/card.dart';

enum ResultType {
  userDeckResult,
  publicDeckResult,
  cardResult,
}

class SearchResult {
  final ResultType type;
  final int score;
  final dynamic data;

  SearchResult(this.type, this.score, this.data);
}

class FlashcardSearch {
  final Flashcard card;
  final RichText searchSentence;

  FlashcardSearch(this.card, this.searchSentence);
}