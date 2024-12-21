import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../entity/card.dart';
import '../entity/deck.dart';
import '../entity/search.dart';

List<DeckWithReviewCards> mockDecksList = [
  // Mock DeckWithReviewCards 1
  DeckWithReviewCards(
    deck: Deck(
        id: '1',
        isPublic: false,
        name: 'Hoàng thành Thăng Long',
        description:
            'Bộ thẻ về Hoàng thành Thăng Long nằm ở Hoàng Diệu, Điện Biên, Ba Đình, Hà Nội',
        createdAt: DateTime.now(),
        userId: 'user1',
        descriptionImgPath:
            "https://static.vinwonders.com/production/hoang-thanh-thang-long-2.jpg",
        totalCards: 25,
        totalLearnedCards: 14,
        views: 1500,
        rating: 4.5235),
    numBlueCards: 10,
    numRedCards: 4,
    numGreenCards: 29,
    cards: [], // Empty list of flashcards
  ),

  // Mock DeckWithReviewCards 2
  DeckWithReviewCards(
    deck: Deck(
        id: '2',
        isPublic: true,
        name: 'Chùa với tên siêu dài chẳng hạn siêu siêu dài dài và siêu dài',
        description: 'Description for Global Deck',
        createdAt: DateTime.now(),
        userId: 'user2',
        descriptionImgPath:
            "https://ik.imagekit.io/tvlk/blog/2022/09/chua-mot-cot-1.jpg?tr=dpr-2,w-675",
        totalCards: 25,
        totalLearnedCards: 3,
        views: 450,
        rating: 4.0),
    numBlueCards: 4,
    numRedCards: 5,
    numGreenCards: 13,
    cards: [], // Empty list of flashcards
  ),

  // Mock DeckWithReviewCards 3
  DeckWithReviewCards(
    deck: Deck(
        id: '3',
        isPublic: false,
        name: 'Deck 3',
        description: 'Description for Deck 3',
        createdAt: DateTime.now(),
        userId: 'user3',
        totalCards: 25,
        totalLearnedCards: 22,
        views: 150,
        rating: 4.9),
    numBlueCards: 2,
    numRedCards: 3,
    numGreenCards: 4,
    cards: [], // Empty list of flashcards
  ),

  // Mock DeckWithReviewCards 4
  DeckWithReviewCards(
    deck: Deck(
        id: '4',
        isPublic: true,
        name: 'Global Deck 2',
        description: 'Description for Global Deck 2',
        createdAt: DateTime.now(),
        userId: 'user4',
        totalCards: 20,
        totalLearnedCards: 18,
        views: 10,
        rating: 1.3),
    numBlueCards: 30,
    numRedCards: 49,
    numGreenCards: 102,
    cards: [], // Empty list of flashcards
  ),

  // Mock DeckWithReviewCards 5
  DeckWithReviewCards(
    deck: Deck(
        id: '5',
        isPublic: false,
        name: 'Deck 5',
        description: 'Description for Deck 5',
        createdAt: DateTime.now(),
        userId: 'user5',
        totalCards: 15,
        totalLearnedCards: 1,
        views: 88,
        rating: 0.5),
    numBlueCards: 3,
    numRedCards: 3,
    numGreenCards: 3,
    cards: [], // Empty list of flashcards
  ),
];

final mockQuestions = [
  Flashcard(
    id: "1",
    deckId: "1",
    question: "What is the capital of France?",
    correctAnswer: "Paris",
    answers: ["London", "Berlin", "Madrid", "Paris"],
    createdAt: DateTime.now(),
    userId: "user1",
    lastReview: DateTime.now(),
    nextReview: DateTime.now(),
    numReviews: 0,
    sm2N: 1,
    sm2EF: 2.5,
    sm2I: 3,
    cardType: 0,
  ),
  Flashcard(
    id: "2",
    deckId: "1",
    question: "What is the capital of France?1",
    correctAnswer: "Paris1",
    answers: ["London1", "Berlin1", "Madrid1", "Paris1"],
    createdAt: DateTime.now(),
    userId: "user1",
    lastReview: DateTime.now(),
    nextReview: DateTime.now(),
    numReviews: 0,
    sm2N: 1,
    sm2EF: 2.5,
    sm2I: 1,
    cardType: 0,
  ),
  Flashcard(
    id: "3",
    deckId: "2",
    question: "Which planet is known as the Red Planet?",
    correctAnswer: "Mars",
    answers: ["Earth", "Venus", "Jupiter", "Mars"],
    createdAt: DateTime.now(),
    userId: "user2",
    lastReview: DateTime.now(),
    nextReview: DateTime.now(),
    numReviews: 0,
    sm2N: 1,
    sm2EF: 2.5,
    sm2I: 3,
    cardType: 1,
  ),
  Flashcard(
    id: "4",
    deckId: "2",
    question: "What is the largest mammal in the world?",
    correctAnswer: "Blue Whale",
    answers: ["Lion", "Elephant", "Giraffe", "Blue Whale"],
    createdAt: DateTime.now(),
    userId: "user2",
    lastReview: DateTime.now(),
    nextReview: DateTime.now(),
    numReviews: 0,
    sm2N: 1,
    sm2EF: 2.5,
    sm2I: 3,
    cardType: 2,
  ),
  Flashcard(
    id: "5",
    deckId: "2",
    question:
        "Tại sao UNESCO công nhận Hoàng thành Thăng Long - Hà Nội là Di sản Văn hóa Thế giới UNESCO",
    correctAnswer: "13 thế kỷ lịch sử văn hóa",
    answers: [
      "Kiến trúc quân sự phương Tây.",
      "13 thế kỷ lịch sử văn hóa",
      "Cuộc chiến chống thuộc địa, tác động toàn cầu.",
      "Phát triển Phật giáo và Nho giáo"
    ],
    createdAt: DateTime.now(),
    userId: "user2",
    lastReview: DateTime.now(),
    nextReview: DateTime.now(),
    numReviews: 0,
    sm2N: 1,
    sm2EF: 2.5,
    sm2I: 3,
    cardType: 2,
  ),
];

List<FlashcardSearch> mockCardSearches = [
  FlashcardSearch(
      mockQuestions[0],
      RichText(
        maxLines: 3, // Set the maximum number of lines
        overflow: TextOverflow.ellipsis, // Use ellipsis for overflow
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: '... This is a sentence with ',
              style: TextStyle(color: Colors.black),
            ),
            TextSpan(
              text: 'bold',
              style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            TextSpan(
                text:
                ' words. This is a long sentence that will be truncated with ellipsis.',
                style: TextStyle(color: Colors.black)),
          ],
        ),
      )),
  FlashcardSearch(
      mockQuestions[4],
      RichText(
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: '... This is a sentence with ',
              style: TextStyle(color: Colors.black),
            ),
            TextSpan(
              text: 'really bold',
              style:
                  TextStyle(fontWeight: FontWeight.w900, color: Colors.black),
            ),
            TextSpan(
                text:
                    ' words. This is a long sentence that will be truncated with ellipsis.',
                style: TextStyle(color: Colors.black)),
          ],
        ),
      )),
];
