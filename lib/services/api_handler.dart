import 'package:google_search_suggestions/google_search_suggestions.dart';
import '../entity/deck.dart';
import 'mock_data.dart';

class APIHanlder {
  Map<String, DeckWithReviewCards> idToDeckWithReviewCards = {};
  final GoogleSearchSuggestions googleSearchSuggestions = GoogleSearchSuggestions();
  APIHandler() {

  }
  Future<void> initData() async {
    for (DeckWithReviewCards deckWithReviewCards in mockDecksList) {
      idToDeckWithReviewCards[deckWithReviewCards.deck.id] = deckWithReviewCards;
    }
  }

  Future<void> initNecessaryData() async {

  }
}