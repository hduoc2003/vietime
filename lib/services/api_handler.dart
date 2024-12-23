import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_search_suggestions/google_search_suggestions.dart';
import 'package:logging/logging.dart';
import 'package:vietime/entity/search.dart';

import '../entity/card.dart';
import '../entity/deck.dart';
import '../entity/user.dart';
import '../helpers/api.dart';
import 'mock_data.dart';

class APIHanlder {
  late ValueNotifier<bool> isLoggedIn;
  String accessToken = "";
  late List<DeckWithCards> userDecks;
  late List<DeckWithCards> publicDecks;
  late List<DeckWithReviewCards> decksReview;
  late List<Flashcard> allCards;
  late List<DeckWithCards> allDecks;
  late User user;
  Map<String, DeckWithReviewCards> idToDeckWithReviewCards = {};
  Map<String, DeckWithCards> idToDeckWithCards = {};
  final GoogleSearchSuggestions googleSearchSuggestions =
      GoogleSearchSuggestions();
  final storage = const FlutterSecureStorage();
  APIHandler() {}

  void assignInitData(Map<String, dynamic> result) {
    if (result.containsKey('refresh_token')) {
      storage.write(key: 'refresh_token', value: (result['refresh_token'] as String));
    }
    userDecks = (result['user_decks'] as List<dynamic>)
            .map((deckJson) => DeckWithCards.fromJson(deckJson))
            .toList() ??
        [];
    Logger.root.info(userDecks);

    publicDecks = (result['public_decks'] as List<dynamic>)
            .map((deckJson) => DeckWithCards.fromJson(deckJson))
            .toList() ??
        [];

    user = User.fromJson(result['user'] ?? {});

    decksReview = (result['decks_review'] as List<dynamic>)
            .map((deckJson) => DeckWithReviewCards.fromJson(deckJson))
            .toList() ??
        [];
    allCards = (result['all_cards'] as List<dynamic>)
            .map((cardJson) => Flashcard.fromJson(cardJson))
            .toList() ??
        [];
    allDecks = [...userDecks, ...publicDecks];
  }

  Future<void> initData() async {
    String? refreshToken = await storage.read(key: 'refresh_token');
    if (refreshToken == null) {
      isLoggedIn = ValueNotifier<bool>(false);
    } else {
      await APIHelper.getAllDataWithRefreshToken(refreshToken).then((result) {
        if (result['error'] != null) {
          isLoggedIn = ValueNotifier<bool>(false);
        } else {
          assignInitData(result);
          afterInitData();
          isLoggedIn = ValueNotifier<bool>(true);
        }
      });
    }
  }

  void afterInitData() {
    for (DeckWithReviewCards deckWithReviewCards in decksReview) {
      idToDeckWithReviewCards[deckWithReviewCards.deck.id] =
          deckWithReviewCards;
    }
    for (DeckWithCards deckWithCards in allDecks) {
      idToDeckWithCards[deckWithCards.deck.id] = deckWithCards;
    }
  }

  Future<void> initNecessaryData() async {}

  void updateAccessToken(String token) {
    accessToken = token;
  }
}
