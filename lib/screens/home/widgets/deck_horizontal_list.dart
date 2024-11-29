import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../custom_widgets/animated_progress_bar.dart';
import '../../../custom_widgets/animated_text.dart';
import '../../../custom_widgets/custom_physics.dart';
import '../../../entity/deck.dart';

List<DeckWithReviewCards> decksList = [
  // Mock DeckWithReviewCards 1
  DeckWithReviewCards(
    deck: Deck(
        id: '1',
        isGlobal: false,
        name: 'Hoàng thành Thăng Long',
        description: 'Description for Deck 1',
        createdAt: DateTime.now(),
        userId: 'user1',
        descriptionImgPath:
        "https://static.vinwonders.com/production/hoang-thanh-thang-long-2.jpg",
        totalCards: 25,
        totalNewCards: 14),
    numBlueCards: 10,
    numRedCards: 4,
    numGreenCards: 29,
    cards: [], // Empty list of flashcards
  ),

  // Mock DeckWithReviewCards 2
  DeckWithReviewCards(
    deck: Deck(
        id: '2',
        isGlobal: true,
        name: 'Chùa với tên siêu dài chẳng hạn',
        description: 'Description for Global Deck',
        createdAt: DateTime.now(),
        userId: 'user2',
        descriptionImgPath:
        "https://ik.imagekit.io/tvlk/blog/2022/09/chua-mot-cot-1.jpg?tr=dpr-2,w-675",
        totalCards: 25,
        totalNewCards: 3),
    numBlueCards: 4,
    numRedCards: 5,
    numGreenCards: 13,
    cards: [], // Empty list of flashcards
  ),

  // Mock DeckWithReviewCards 3
  DeckWithReviewCards(
    deck: Deck(
        id: '3',
        isGlobal: false,
        name: 'Deck 3',
        description: 'Description for Deck 3',
        createdAt: DateTime.now(),
        userId: 'user3',
        totalCards: 25,
        totalNewCards: 22),
    numBlueCards: 2,
    numRedCards: 3,
    numGreenCards: 4,
    cards: [], // Empty list of flashcards
  ),

  // Mock DeckWithReviewCards 4
  DeckWithReviewCards(
    deck: Deck(
        id: '4',
        isGlobal: true,
        name: 'Global Deck 2',
        description: 'Description for Global Deck 2',
        createdAt: DateTime.now(),
        userId: 'user4',
        totalCards: 20,
        totalNewCards: 18),
    numBlueCards: 30,
    numRedCards: 49,
    numGreenCards: 102,
    cards: [], // Empty list of flashcards
  ),

  // Mock DeckWithReviewCards 5
  DeckWithReviewCards(
    deck: Deck(
        id: '5',
        isGlobal: false,
        name: 'Deck 5',
        description: 'Description for Deck 5',
        createdAt: DateTime.now(),
        userId: 'user5',
        totalCards: 15,
        totalNewCards: 1),
    numBlueCards: 3,
    numRedCards: 3,
    numGreenCards: 3,
    cards: [], // Empty list of flashcards
  ),
];

class DeckHorizontalList extends StatelessWidget {
  final int itemCountPerGroup;

  DeckHorizontalList({this.itemCountPerGroup = 4});

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
                      return GestureDetector(
                        onTap: () => {},
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[
                            100], // Add a slightly grey background color
                            borderRadius: BorderRadius.circular(
                                30.0), // Optional: Add rounded corners
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10),
                          margin: EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 5),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                    child: CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      errorWidget: (context, _, __) =>
                                      const Image(
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                            'assets/deck_placeholder.png'),
                                      ),
                                      imageUrl: item.deck.descriptionImgPath,
                                      placeholder: (context, url) => Image(
                                        fit: BoxFit.fill,
                                        image: const AssetImage(
                                            'assets/deck_placeholder.png'),
                                      ),
                                    ),
                                  ),
                                ),

                                // Padding between leading and title/subtitle
                                SizedBox(width: 16.0),

                                // Title and Subtitle Section
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      AnimatedText(
                                        text: item.deck.name,
                                        pauseAfterRound:
                                        const Duration(
                                          seconds: 3,
                                        ),
                                        showFadingOnlyWhenScrolling:
                                        false,
                                        fadingEdgeEndFraction:
                                        0.1,
                                        fadingEdgeStartFraction:
                                        0.1,
                                        startAfter:
                                        const Duration(
                                          seconds: 3,
                                        ),
                                        style:
                                        const TextStyle(
                                            fontWeight:
                                            FontWeight
                                                .w900,
                                            fontSize: 17
                                        ),
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        defaultAlignment: TextAlign.start,
                                      ),
                                      SizedBox(
                                          height:
                                          4.0),

                                      RichText(
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(children: [
                                            TextSpan(
                                              text: (item.numBlueCards).toStringAsFixed(0),
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            WidgetSpan(
                                              child: SizedBox(
                                                  width:
                                                  6.0), // Adjust the width as needed for the space
                                            ),
                                            TextSpan(
                                              text: (item.numRedCards).toStringAsFixed(0),
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            WidgetSpan(
                                              child: SizedBox(
                                                  width:
                                                  6.0), // Adjust the width as needed for the space
                                            ),
                                            TextSpan(
                                              text: (item.numGreenCards).toStringAsFixed(0),
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                          ])),
                                      SizedBox(
                                          height:
                                          4.0),
                                      Row(
                                        children: [
                                          AnimatedProgressBar(
                                            width:
                                            150, // Adjust the width as needed
                                            height:
                                            14, // Adjust the height as needed
                                            progress: item.deck.totalNewCards /
                                                item.deck
                                                    .totalCards, // Adjust the progress value as needed
                                            backgroundColor:
                                            const Color(0xffD9D9D9),
                                            progressColor:
                                            const Color(0xff40a5e8),
                                            innerProgressColor:
                                            const Color(0xff6db7f4),
                                          ),

                                          // Spacer to add space between the ProgressBar and percentage
                                          SizedBox(width: 16.0),

                                          Text(
                                            '${(item.deck.totalNewCards / item.deck.totalCards * 100).toStringAsFixed(0)}%', // Replace with actual calculation
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
                    } else {
                      return SizedBox(); // Return an empty widget if the index is out of bounds
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
