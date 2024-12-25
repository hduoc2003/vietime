import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_search_suggestions/google_search_suggestions.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

import '../entity/card.dart';
import '../entity/deck.dart';
import '../entity/user.dart';
import '../helpers/api.dart';

class APIHanlder {
  late ValueNotifier<bool> isLoggedIn;
  String accessToken = "";
  ValueNotifier<bool> newNotifcations = ValueNotifier<bool>(false);
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
  ValueNotifier<bool> userChanged = ValueNotifier<bool>(false);
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

    List<String> favoritePublicDecks = Hive.box('settings')
        .get('favoritePublicDecks', defaultValue: []).cast<String>();

    for (DeckWithCards d in publicDecks) {
      if (favoritePublicDecks.contains(d.deck.id)) {
        d.deck.isFavorite = true;
      }
    }

    user = User.fromJson(result['user'] ?? {});

    decksReview = (result['decks_review'] as List<dynamic>)
        .map((deckJson) => DeckWithReviewCards.fromJson(deckJson))
        .toList();

    allCards = [];
    for (DeckWithCards d in userDecks) {
      d.cards.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      int ptr = 0;
      for (Flashcard f in d.cards) {
        ptr++;
        f.index = ptr;
        allCards.add(f);
      }
      d.deck.totalCards = ptr;
    }
    for (DeckWithCards d in publicDecks) {
      d.cards.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      int ptr = 0;
      for (Flashcard f in d.cards) {
        ptr++;
        f.index = ptr;
        allCards.add(f);
      }
      d.deck.totalCards = ptr;
    }
    // allCards = (result['all_cards'] as List<dynamic>)
    //     .map((cardJson) => Flashcard.fromJson(cardJson))
    //     .toList();

    allDecks = [...userDecks, ...publicDecks];
    userDecksChanged.value ^= true;
    publicDecksChanged.value ^= true;
    userChanged.value ^= true;
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
    Hive.box('publicDeckViews').toMap().forEach((key, value) {
      APIHelper.submitViewDeckRequest(key as String, value as int)
          .then((viewDeckResponse) {
        if (viewDeckResponse.containsKey("error")) {
          // TODO: Retry or something
        }
      });
    });
    Hive.box('publicDeckViews').clear();
    int day = Hive.box('cache').get('notficationUpdatedDay', defaultValue: 0);
    int today = DateTime.now().day;
    if (day != today) {
      List<String> notifications = Hive.box('cache')
          .get('notifcations', defaultValue: []).cast<String>();
      APIHelper.submitGetFactRequest().then((getFactResponse) {
        if (getFactResponse.containsKey("error")) {
          // TODO: Retry or something
        } else {
          notifications.add(DateFormat('dd-MM-yyyy').format(DateTime.now()) +
              " " +
              getFactResponse['fact']);
          Hive.box('cache').put('notifcations', notifications);
          Hive.box('cache').put('notficationUpdatedDay', today);
          newNotifcations.value = true;
          Logger.root.info(notifications);
        }
      });
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

  void onDeleteCardSuccess(Flashcard card) {
    int cardType = -1;
    for (DeckWithReviewCards d in decksReview) {
      if (d.deck.id == card.deckId) {
        for (Flashcard f in d.cards) {
          if (f.id == card.id) {
            if (f.cardType == 0) {
              cardType = 0;
              d.numBlueCards--;
            } else if (f.cardType == 1) {
              cardType = 1;
              d.numRedCards--;
            } else if (f.cardType == 2) {
              cardType = 2;
              d.numGreenCards--;
            }
            break;
          }
        }

        d.cards.removeWhere((c) => c.id == card.id);
        for (Flashcard f in d.cards) {
          if (f.index > card.index) {
            f.index--;
          }
        }
        d.deck.totalCards--;
        break;
      }
    }

    for (DeckWithCards d in userDecks) {
      if (d.deck.id == card.deckId) {
        if (cardType == 0) {
          d.numBlueCards--;
        } else if (cardType == 1) {
          d.numRedCards--;
        } else if (cardType == 2) {
          d.numGreenCards--;
        }
        d.cards.removeWhere((c) => c.id == card.id);
        for (Flashcard f in d.cards) {
          if (f.index > card.index) {
            f.index--;
          }
        }
        d.deck.totalCards--;
        break;
      }
    }

    allCards.removeWhere((c) => c.id == card.id);

    userDecksChanged.value ^= true;
    decksReviewChanged.value ^= true;
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
    user = User.fromJson(result['user']);
    userChanged.value ^= true;
    decksReviewChanged.value ^= true;
    userDecksChanged.value ^= true;
  }

  void onCreateCardSuccess(String deckID, Map<String, dynamic> result) {
    Flashcard card = Flashcard.fromJson(result['card']);
    for (DeckWithCards d in userDecks) {
      if (d.deck.id == deckID) {
        card.index = d.cards.last.index + 1;
        d.cards.add(card);
      }
      d.deck.totalCards++;
    }
    allCards.add(card);
    allCardsChanged.value ^= true;
    userDecksChanged.value ^= true;
  }

  void onEditCardSuccess(Map<String, dynamic> result) {
    Flashcard card = Flashcard.fromJson(result['card']);
    String deckID = card.deckId;
    String cardID = card.id;
    for (DeckWithCards d in userDecks) {
      if (d.deck.id == deckID) {
        for (int i = 0; i < d.cards.length; ++i) {
          if (d.cards[i].id == cardID) {
            d.cards[i].question = card.question;
            d.cards[i].answers = card.answers;
            d.cards[i].correctAnswer = card.correctAnswer;
            d.cards[i].wrongAnswers = card.wrongAnswers;
            d.cards[i].questionImgURL = card.questionImgURL;
            d.cards[i].questionImgLabel = card.questionImgLabel;
            break;
          }
        }
      }
    }
    for (DeckWithReviewCards d in decksReview) {
      if (d.deck.id == deckID) {
        for (int i = 0; i < d.cards.length; ++i) {
          if (d.cards[i].id == cardID) {
            d.cards[i].question = card.question;
            d.cards[i].answers = card.answers;
            d.cards[i].correctAnswer = card.correctAnswer;
            d.cards[i].wrongAnswers = card.wrongAnswers;
            d.cards[i].questionImgURL = card.questionImgURL;
            d.cards[i].questionImgLabel = card.questionImgLabel;
            break;
          }
        }
      }
    }
    allCardsChanged.value ^= true;
    userDecksChanged.value ^= true;
    decksReviewChanged.value ^= true;
  }

  void onEditDeckSuccess(Map<String, dynamic> result) {
    Deck deck = Deck.fromJson(result['deck']);
    String deckID = deck.id;
    for (DeckWithCards d in userDecks) {
      if (d.deck.id == deckID) {
        d.deck = deck;
        break;
      }
    }
    for (DeckWithReviewCards d in decksReview) {
      if (d.deck.id == deckID) {
        d.deck = deck;
        break;
      }
    }
    userDecksChanged.value ^= true;
    decksReviewChanged.value ^= true;
  }

  void onCreateDeckSuccess(Map<String, dynamic> result) {
    DeckWithCards deck = DeckWithCards.fromJson(result['deck']);
    userDecks.add(deck);
    allDecks.add(deck);
    userDecksChanged.value ^= true;
    allDecksChanged.value ^= true;
  }

  void onUpdateUserSuccess(Map<String, dynamic> result) {
    user = User.fromJson(result['user']);
    userChanged.value ^= true;
  }
}
