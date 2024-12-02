import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ion.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:vietime/custom_widgets/three_card_type_number_row.dart';
import 'package:vietime/helpers/validate.dart';

import '../../../custom_widgets/animated_progress_bar.dart';
import '../../../custom_widgets/animated_text.dart';
import '../../../custom_widgets/custom_physics.dart';
import '../../../entity/deck.dart';
import '../../deck_screen.dart';

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

class DeckHorizontalList extends StatelessWidget {
  final int itemCountPerGroup;
  final int deckType;
  final List<DeckWithReviewCards> decksList;

  DeckHorizontalList(
      {this.itemCountPerGroup = 4,
        required this.deckType,
        required this.decksList});

  @override
  Widget build(BuildContext context) {
    final double portion = (decksList.length <= itemCountPerGroup) ? 1.0 : 0.84;
    final double listSize = MediaQuery.of(context).size.width * portion;

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 4),
      child: SizedBox(
        height: decksList.length < itemCountPerGroup
            ? 110.0 * decksList.length
            : 110.0 * itemCountPerGroup,
        child: Align(
          alignment: Alignment.centerLeft,
          child: ListView.builder(
            physics: PagingScrollPhysics(itemDimension: listSize),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemExtent: listSize,
            itemCount: (decksList.length / itemCountPerGroup).ceil(),
            itemBuilder: (context, index) {
              return SizedBox(
                width: listSize,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: List.generate(itemCountPerGroup, (subIndex) {
                    final itemIndex = index * itemCountPerGroup + subIndex;
                    if (itemIndex < decksList.length) {
                      final item = decksList[itemIndex];
                      if (deckType == 0) {
                        return getUserDeckTile(item, context);
                      } else {
                        return getPublicDeckTile(item, context);
                      }
                    } else {
                      return const SizedBox(); // Return an empty widget if the index is out of bounds
                    }
                  }),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget getUserDeckTile(DeckWithReviewCards item, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeckScreen(deckData: item),
        ),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[100], // Add a slightly grey background color
        borderRadius:
        BorderRadius.circular(30.0), // Optional: Add rounded corners
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Leading Section
        Card(
          margin: EdgeInsets.zero,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: 75,
            height: 75,
            child: validateURL(item.deck.descriptionImgPath)
                ? CachedNetworkImage(
              fit: BoxFit.cover,
              errorWidget: (context, _, __) => const Image(
                fit: BoxFit.cover,
                image: AssetImage('assets/deck_placeholder.png'),
              ),
              imageUrl: item.deck.descriptionImgPath,
              placeholder: (context, url) => const Image(
                fit: BoxFit.cover,
                image: AssetImage('assets/deck_placeholder.png'),
              ),
            )
                : const Image(
              fit: BoxFit.cover,
              image: AssetImage('assets/deck_placeholder.png'),
            ),
          ),
        ),

        // Padding between leading and title/subtitle
        const SizedBox(width: 16.0),

        // Title and Subtitle Section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedText(
                text: item.deck.name,
                pauseAfterRound: const Duration(
                  seconds: 3,
                ),
                showFadingOnlyWhenScrolling: false,
                startAfter: const Duration(
                  seconds: 3,
                ),
                style:
                const TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
                crossAxisAlignment: CrossAxisAlignment.start,
                defaultAlignment: TextAlign.start,
              ),
              const SizedBox(height: 4.0),
              ThreeCardTypeNumbersRow(
                  numBlueCards: item.numBlueCards,
                  numRedCards: item.numRedCards,
                  numGreenCards: item.numGreenCards),
              SizedBox(height: 4.0),
              Row(
                children: [
                  AnimatedProgressBar(
                    width: 150, // Adjust the width as needed
                    height: 14, // Adjust the height as needed
                    progress: item.deck.totalLearnedCards /
                        item.deck
                            .totalCards, // Adjust the progress value as needed
                    backgroundColor: const Color(0xffD9D9D9),
                    progressColor: const Color(0xff40a5e8),
                    innerProgressColor: const Color(0xff6db7f4),
                  ),

                  // Spacer to add space between the ProgressBar and percentage
                  SizedBox(width: 16.0),

                  Text(
                    '${(item.deck.totalLearnedCards / item.deck.totalCards * 100).toStringAsFixed(0)}%', // Replace with actual calculation
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    ),
  );
}

Widget getPublicDeckTile(DeckWithReviewCards item, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeckScreen(deckData: item),
        ),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[100], // Add a slightly grey background color
        borderRadius:
        BorderRadius.circular(30.0), // Optional: Add rounded corners
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Leading Section
        Card(
          margin: EdgeInsets.zero,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: 75,
            height: 75,
            child: validateURL(item.deck.descriptionImgPath)
                ? CachedNetworkImage(
              fit: BoxFit.cover,
              errorWidget: (context, _, __) => const Image(
                fit: BoxFit.cover,
                image: AssetImage('assets/deck_placeholder.png'),
              ),
              imageUrl: item.deck.descriptionImgPath,
              placeholder: (context, url) => const Image(
                fit: BoxFit.cover,
                image: AssetImage('assets/deck_placeholder.png'),
              ),
            )
                : const Image(
              fit: BoxFit.cover,
              image: AssetImage('assets/deck_placeholder.png'),
            ),
          ),
        ),

        // Padding between leading and title/subtitle
        SizedBox(width: 16.0),

        // Title and Subtitle Section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedText(
                text: item.deck.name,
                pauseAfterRound: const Duration(
                  seconds: 3,
                ),
                showFadingOnlyWhenScrolling: false,
                startAfter: const Duration(
                  seconds: 3,
                ),
                style:
                const TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
                crossAxisAlignment: CrossAxisAlignment.start,
                defaultAlignment: TextAlign.start,
              ),
              SizedBox(height: 4.0),
              Row(
                children: [
                  Text(
                    "Số lượng: ",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${item.deck.totalCards}",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w900),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0, bottom: 2),
                    child: Iconify(
                      Mdi.cards_playing,
                      color: Colors.purple,
                      size: 20.0, // Adjust the size as needed
                    ),
                  ),
                ],
              ),
              SizedBox(width: 8.0), // Add some space between the two texts
              Row(
                children: [
                  Text(
                    "Đánh giá: ",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${item.deck.rating.toStringAsFixed(1)}",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w900),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0, bottom: 2),
                    child: Icon(
                      Icons.star,
                      color: Color(0xffedc202),
                      size: 20.0, // Adjust the size as needed
                    ),
                  ),
                  Text(
                    " ~ ${item.deck.views}",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w900),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0, bottom: 2),
                    child: Iconify(
                      Ion.ios_eye,
                      color: Colors.green,
                      size: 20.0, // Adjust the size as needed
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    ),
  );
}