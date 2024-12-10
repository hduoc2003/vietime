import '../entity/deck.dart';
import 'mock_data.dart';

class APIHanlder {
  Map<String, DeckWithReviewCards> idToDeckWithReviewCards = {};
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