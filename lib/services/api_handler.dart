import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_search_suggestions/google_search_suggestions.dart';

import '../entity/card.dart';
import '../entity/deck.dart';
import '../entity/user.dart';
import '../helpers/api.dart';

class APIHanlder {
  late ValueNotifier<bool> isLoggedIn;
  String accessToken = "";
  ValueNotifier<bool> userDecksChanged = ValueNotifier<bool>(false);
  late List<DeckWithCards> userDecks;
  ValueNotifier<bool> publicDecksChanged = ValueNotifier<bool>(false);
  late List<DeckWithCards> publicDecks;
  ValueNotifier<bool> decksReviewChanged = ValueNotifier<bool>(false);
  late List<DeckWithReviewCards> decksReview;
  ValueNotifier<bool> allCardsChanged = ValueNotifier<bool>(false);
  late List<Flashcard> allCards;
  ValueNotifier<bool> allDecksChanged = ValueNotifier<bool>(false);
  late List<DeckWithCards> allDecks;
  late User user;
  Map<String, DeckWithReviewCards> idToDeckWithReviewCards = {};
  Map<String, DeckWithCards> idToDeckWithCards = {};
  final GoogleSearchSuggestions googleSearchSuggestions =
      GoogleSearchSuggestions();
  final storage = const FlutterSecureStorage();
  late final Function() onRebuildMainPage;
  APIHandler() {}

  void setOnRebuildMainPage(Function() rebuildMainPage) {
    onRebuildMainPage = rebuildMainPage;
  }

  void assignInitData(Map<String, dynamic> result) {
    if (result.containsKey('refresh_token')) {
      storage.write(
          key: 'refresh_token', value: (result['refresh_token'] as String));
    }
    accessToken = (result['access_token'] as String);
    userDecks = (result['user_decks'] as List<dynamic>)
            .map((deckJson) => DeckWithCards.fromJson(deckJson))
            .toList();

    publicDecks = (result['public_decks'] as List<dynamic>)
            .map((deckJson) => DeckWithCards.fromJson(deckJson))
            .toList();

    user = User.fromJson(result['user'] ?? {});

    decksReview = (result['decks_review'] as List<dynamic>)
            .map((deckJson) => DeckWithReviewCards.fromJson(deckJson))
            .toList();
    allCards = (result['all_cards'] as List<dynamic>)
            .map((cardJson) => Flashcard.fromJson(cardJson))
            .toList();
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

  void onCopyDeckSuccess(Map<String, dynamic> result) {
    DeckWithCards deck = DeckWithCards.fromJson(result['deck']);
    DeckWithReviewCards deckReview =
        DeckWithReviewCards.fromJson(result['deck_review']);
    userDecks.add(deck);
    decksReview.add(deckReview);
    allDecks.add(deck);
    allCards.addAll(deck.cards);
    idToDeckWithReviewCards[deckReview.deck.id] = deckReview;
    userDecksChanged.value ^= true;
    decksReviewChanged.value ^= true;
    allDecksChanged.value ^= true;
    allCardsChanged.value ^= true;
  }

  void onDeleteDeckSuccess(String deckID) {
    userDecks.removeWhere((deck) => deck.deck.id == deckID);
    decksReview.removeWhere((deck) => deck.deck.id == deckID);
    allDecks.removeWhere((deck) => deck.deck.id == deckID);
    allCards.removeWhere((card) => card.deckId == deckID);
    idToDeckWithReviewCards.remove(deckID);
    userDecksChanged.value ^= true;
    decksReviewChanged.value ^= true;
    allDecksChanged.value ^= true;
    allCardsChanged.value ^= true;
  }

  void onReviewCardsSuccess(String deckID, Map<String, dynamic> result) {
    DeckWithReviewCards deckReview = idToDeckWithReviewCards[deckID]!;
    deckReview.numBlueCards = result['num_blue_cards'] as int;
    deckReview.numRedCards = result['num_red_cards'] as int;
    deckReview.numGreenCards = result['num_green_cards'] as int;
    deckReview.cards = (result['cards'] as List<dynamic>?)
            ?.map((cardJson) => Flashcard.fromJson(cardJson))
            .toList() ??
        [];
    for (DeckWithCards d in userDecks) {
      if (d.deck.id == deckID) {
        d.numBlueCards = deckReview.numBlueCards;
        d.numRedCards = deckReview.numRedCards;
        d.numGreenCards = deckReview.numGreenCards;
      }
    }
    decksReviewChanged.value ^= true;
    userDecksChanged.value ^= true;
  }
}
